-- state.lua — run state machine with JSON persistence (Layer 2).
--
-- The state file survives game restarts, so a run can be resumed. All floor
-- data is present in the file from run start (generated from the seed); the
-- UI is responsible for hiding floors > current_floor (fog of war is
-- presentation-only).
--
-- Machine:
--   IDLE -> ACTIVE (new_run / resume)
--   ACTIVE floor loop: briefing -> in_mission -> (complete | death)
--   ACTIVE -> WON  (floor 5 complete)
--   ACTIVE -> LOST (death cap reached)
--   ACTIVE -> ABANDONED (player quits the mode)

local Config = require("config")
local Const  = require("const")
local Log    = require("log")
local Paths  = require("paths")
local Json   = require("json")
local Rng    = require("rng")
local Rungen = require("rungen")

local State = {}

State.STATUS = {
    IDLE = "idle", ACTIVE = "active", WON = "won",
    LOST = "lost", ABANDONED = "abandoned",
}
State.FLOOR = { BRIEFING = "briefing", IN_MISSION = "in_mission" }

-- The in-memory run document. nil while IDLE with no file on disk.
State.run = nil

-- ------------------------------------------------------------- persistence

function State.save()
    if not State.run then return end
    local path = Paths.run_state_file()
    if not path then return end
    local dir = Paths.mod_dir()
    if dir and not Paths.dir_exists(dir) then Paths.mkdir(dir) end
    local f = io.open(path, "w")
    if not f then
        Log.error("state: cannot write %s", path)
        return
    end
    f:write(Json.encode(State.run))
    f:close()
end

function State.load()
    local path = Paths.run_state_file()
    if not path or not Paths.file_exists(path) then return false end
    local f = io.open(path, "r")
    if not f then return false end
    local raw = f:read("a")
    f:close()
    local doc, err = Json.decode(raw)
    if not doc then
        Log.error("state: corrupt run.json (%s); ignoring", tostring(err))
        return false
    end
    -- Runs generated before the skull pool was rebuilt from the real game enum
    -- carry ids the game does not know ("grunt_bday"), which silently dropped
    -- skulls at launch. Such a run cannot be repaired — discard it so a fresh
    -- one gets rolled from the current content.
    if (doc.content_version or 1) ~= Const.CONTENT_VERSION then
        Log.warn("state: run %s was generated with content v%s but this build "
            .. "is v%d — discarding it; start a new run",
            tostring(doc.seed), tostring(doc.content_version or 1),
            Const.CONTENT_VERSION)
        State.run = nil
        return false
    end
    State.run = doc
    Log.info("state: loaded run %s (status=%s floor=%d deaths=%d)",
        doc.seed or "?", doc.status or "?", doc.current_floor or 0, doc.deaths or 0)
    return true
end

-- ------------------------------------------------------------- lifecycle

-- Start a new run. `seed_string` optional (random when nil).
-- `backup_id` is the verified save backup id from saveguard — required, the
-- caller must have completed the backup first.
function State.new_run(seed_string, backup_id)
    assert(backup_id, "state.new_run called without a save backup id")
    if seed_string then
        seed_string = Rng.normalize_seed_string(seed_string)
        if not seed_string then return nil, "invalid seed string" end
    else
        seed_string = Rng.generate_seed_string()
    end

    local gen = Rungen.generate(seed_string)
    State.run = {
        version       = 1,
        content_version = Const.CONTENT_VERSION,
        seed          = gen.seed,
        floors        = gen.floors,
        status        = State.STATUS.ACTIVE,
        current_floor = 1,
        floor_status  = State.FLOOR.BRIEFING,
        deaths        = 0,
        death_cap     = Config.death_cap,
        backup_id     = backup_id,
        started_at    = os.time(),
        finished_at   = nil,
        floor_log     = {},   -- per-floor completion records for the summary
    }
    State.save()

    Log.info("state: new run %s (backup %s)", gen.seed, tostring(backup_id))
    if Config.log_spoilers then
        for _, fl in ipairs(gen.floors) do
            Log.info("state: [spoiler] floor %d: %s @ %s, %s%s, +[%s], vis=%s",
                fl.index, fl.mission_id, fl.rally, fl.difficulty,
                fl.nerf and "+" or "", table.concat(fl.new_skulls, ","), fl.visibility)
        end
    end
    return State.run
end

function State.current_floor_data()
    if not State.run or State.run.status ~= State.STATUS.ACTIVE then return nil end
    return State.run.floors[State.run.current_floor]
end

function State.active_skulls()
    if not State.run then return {} end
    return Rungen.active_skulls(State.run, State.run.current_floor)
end

-- Skulls that will be active on an arbitrary floor. Used by the floor-select
-- detail panel, which describes any revealed floor, not only the current one.
function State.skulls_for_floor(index)
    if not State.run or not State.run.floors[index] then return {} end
    return Rungen.active_skulls(State.run, index)
end

-- Called when the mission for the current floor actually launches.
function State.on_floor_launched()
    if not State.run then return end
    State.run.floor_status = State.FLOOR.IN_MISSION
    State.run.floors[State.run.current_floor].launched_at =
        State.run.floors[State.run.current_floor].launched_at or os.time()
    State.save()
end

-- Player death during a floor. Returns "lost" if the cap was hit.
function State.on_death()
    if not State.run or State.run.status ~= State.STATUS.ACTIVE then return end
    if State.run.floor_status ~= State.FLOOR.IN_MISSION then return end
    State.run.deaths = State.run.deaths + 1
    Log.info("state: death %d/%s on floor %d", State.run.deaths,
        State.run.death_cap > 0 and tostring(State.run.death_cap) or "∞",
        State.run.current_floor)
    if State.run.death_cap > 0 and State.run.deaths >= State.run.death_cap then
        State.run.status = State.STATUS.LOST
        State.run.finished_at = os.time()
        Log.info("state: death cap reached — run LOST")
    end
    State.save()
    return State.run.status == State.STATUS.LOST and "lost" or "continue"
end

-- Mission completed. Advances the floor or wins the run.
function State.on_floor_complete()
    if not State.run or State.run.status ~= State.STATUS.ACTIVE then return end
    if State.run.floor_status ~= State.FLOOR.IN_MISSION then
        Log.warn("state: floor-complete event outside a floor; ignoring")
        return
    end
    local idx = State.run.current_floor
    State.run.floor_log[#State.run.floor_log + 1] = {
        floor = idx, completed_at = os.time(), deaths_so_far = State.run.deaths,
    }
    Log.info("state: floor %d complete", idx)

    if idx >= Const.FLOORS_PER_RUN then
        State.run.status = State.STATUS.WON
        State.run.finished_at = os.time()
        Log.info("state: run WON — seed %s, %d deaths", State.run.seed, State.run.deaths)
    else
        State.run.current_floor = idx + 1
        State.run.floor_status = State.FLOOR.BRIEFING
        Log.info("state: revealing floor %d", State.run.current_floor)
    end
    State.save()
    return State.run.status
end

-- Player abandons the run (also used for the hardcore loss cleanup path).
function State.abandon()
    if not State.run then return end
    if State.run.status == State.STATUS.ACTIVE then
        State.run.status = State.STATUS.ABANDONED
        State.run.finished_at = os.time()
        Log.info("state: run abandoned at floor %d", State.run.current_floor)
    end
    State.save()
end

-- Clear the run document (after the summary screen has been dismissed and
-- the save restored).
function State.clear()
    State.run = nil
    local path = Paths.run_state_file()
    if path and Paths.file_exists(path) then
        Paths.cmd('del /q ' .. Paths.q(path))
    end
end

function State.elapsed()
    if not State.run or not State.run.started_at then return 0 end
    local finish = State.run.finished_at or os.time()
    return finish - State.run.started_at
end

return State
