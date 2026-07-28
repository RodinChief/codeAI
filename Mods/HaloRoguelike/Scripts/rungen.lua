-- rungen.lua — deterministic run generation.
--
-- All 5 floors are generated up front from the seed (Layer 2 of the brief);
-- fog of war is presentation-only, enforced by the UI, never by this module.

local Const  = require("const")
local Config = require("config")
local Rng    = require("rng")

local Rungen = {}

local function mission_pool()
    local pool = {}
    for _, m in ipairs(Const.MISSIONS) do
        local excluded = m.bonus and not (Config.include_bonus_missions and m.verified)
        if not excluded then
            pool[#pool + 1] = m
        end
    end
    return pool
end

-- Rally points on a mission later than Alpha.
local function later_rally_points(mission)
    local out = {}
    for _, rp in ipairs(mission.rally) do
        if rp ~= "Alpha" then out[#out + 1] = rp end
    end
    return out
end

-- Generate a full run from a seed string. Pure function of the seed:
-- same seed -> same missions, rally points, skull rolls, visibility rolls.
function Rungen.generate(seed_string)
    local rng = Rng.new(seed_string)

    -- 5 distinct missions.
    local pool = mission_pool()
    assert(#pool >= Const.FLOORS_PER_RUN,
        "mission pool smaller than floors per run")
    local missions = {}
    for _ = 1, Const.FLOORS_PER_RUN do
        missions[#missions + 1] = rng:draw(pool)
    end

    -- Exactly one floor gets Rally Point Alpha.
    local alpha_floor = rng:int(1, Const.FLOORS_PER_RUN)

    -- Skull pool for the extra rolls; never contains the mandatory four.
    local skull_pool = {}
    for _, s in ipairs(Const.SKULL_POOL) do skull_pool[#skull_pool + 1] = s end

    local floors = {}
    for i = 1, Const.FLOORS_PER_RUN do
        local mission = missions[i]
        local rally
        if i == alpha_floor then
            rally = "Alpha"
        else
            local later = later_rally_points(mission)
            rally = later[rng:int(1, #later)]
        end

        -- 1-2 new skulls, no duplicates across the run, cumulative afterwards.
        local roll_count
        if i == Const.FLOORS_PER_RUN then
            roll_count = Config.skull_roll.floor5
        else
            roll_count = rng:int(Config.skull_roll.min, Config.skull_roll.max)
        end
        roll_count = math.min(roll_count, #skull_pool)
        local new_skulls = {}
        for _ = 1, roll_count do
            local s = rng:draw(skull_pool)
            new_skulls[#new_skulls + 1] = s.id
        end

        local vis = Const.VISIBILITY_MODIFIERS[rng:int(1, #Const.VISIBILITY_MODIFIERS)]
        local ladder = Const.DIFFICULTY_LADDER[i]

        floors[i] = {
            index      = i,
            mission_id = mission.id,
            rally      = rally,
            difficulty = ladder.difficulty,
            nerf       = ladder.nerf,
            new_skulls = new_skulls,
            visibility = vis.id,
        }
    end

    return {
        seed   = seed_string,
        floors = floors,
    }
end

-- Skulls active on a given floor: the 4 mandatory ones plus every skull
-- rolled on floors 1..floor_index.
function Rungen.active_skulls(run, floor_index)
    local active = {}
    for _, s in ipairs(Const.MANDATORY_SKULLS) do
        active[#active + 1] = s.id
    end
    for i = 1, floor_index do
        for _, id in ipairs(run.floors[i].new_skulls) do
            active[#active + 1] = id
        end
    end
    return active
end

return Rungen
