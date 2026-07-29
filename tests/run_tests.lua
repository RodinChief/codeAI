-- run_tests.lua — offline tests for the platform-independent modules.
-- Run with: lua5.4 tests/run_tests.lua   (from the repo root)
--
-- Covers json, rng, rungen, state transitions and the ui view model. The
-- game-facing modules (gameapi, saveguard) need the live game and are only
-- exercised for load errors.

package.path = "Mods/HaloRoguelike/Scripts/?.lua;" .. package.path

-- Silence the mod's logging during tests unless VERBOSE=1.
local verbose = os.getenv("VERBOSE") == "1"
local real_print = print
if not verbose then print = function() end end

local failures, checks = 0, 0
local function check(cond, msg)
    checks = checks + 1
    if not cond then
        failures = failures + 1
        real_print("FAIL: " .. msg)
    end
end

-- ------------------------------------------------------------------- json
local Json = require("json")

local doc = {
    seed = "HALO-7K2M-QX9", deaths = 3, nerf = true,
    floors = { { index = 1, skulls = { "fog", "mythic" } }, { index = 2 } },
    note = 'quote " backslash \\ newline \n done',
}
local encoded = Json.encode(doc)
local decoded = Json.decode(encoded)
check(decoded.seed == doc.seed, "json roundtrip: seed")
check(decoded.deaths == 3, "json roundtrip: number")
check(decoded.nerf == true, "json roundtrip: boolean")
check(decoded.floors[1].skulls[2] == "mythic", "json roundtrip: nested array")
check(decoded.note == doc.note, "json roundtrip: escapes")
check(Json.decode('{"a": [1, 2.5, -3e2], "b": null}').a[3] == -300, "json: numbers")
check(Json.decode("{oops") == nil, "json: corrupt input returns nil")

-- -------------------------------------------------------------------- rng
local Rng = require("rng")

local a1, a2 = Rng.new("HALO-TEST-AAA"), Rng.new("HALO-TEST-AAA")
local same = true
for _ = 1, 100 do
    if a1:int(1, 1000) ~= a2:int(1, 1000) then same = false break end
end
check(same, "rng: same seed -> same sequence")

local b = Rng.new("HALO-TEST-AAB")
local diff = false
for _ = 1, 20 do
    if Rng.new("HALO-TEST-AAA"):int(1, 100000) ~= b:int(1, 100000) then diff = true break end
end
check(diff, "rng: different seed -> different sequence")

local r = Rng.new("HALO-BOUNDS-XX")
for _ = 1, 2000 do
    local v = r:int(3, 7)
    check(v >= 3 and v <= 7, "rng: int within bounds")
    if failures > 0 then break end
end

for _ = 1, 20 do
    local s = Rng.generate_seed_string()
    check(s:match("^HALO%-[2-9A-HJKMNP-Z][2-9A-HJKMNP-Z][2-9A-HJKMNP-Z][2-9A-HJKMNP-Z]%-[2-9A-HJKMNP-Z][2-9A-HJKMNP-Z][2-9A-HJKMNP-Z]$") ~= nil,
        "rng: seed format " .. s)
    check(Rng.normalize_seed_string(s) == s, "rng: generated seed normalizes to itself")
end
check(Rng.normalize_seed_string("halo-7k2m-qx9") == "HALO-7K2M-QX9", "rng: normalize lowercase")
check(Rng.normalize_seed_string("7K2MQX9") == "HALO-7K2M-QX9", "rng: normalize bare")
check(Rng.normalize_seed_string("HALO-7K2M-QX0") == nil, "rng: reject ambiguous char 0")
check(Rng.normalize_seed_string("TOO-SHORT") == nil, "rng: reject bad length")

-- ----------------------------------------------------------------- rungen
local Const = require("const")
local Config = require("config")
local Rungen = require("rungen")

-- Valid-id sets are derived from const.lua rather than hardcoded, so renaming
-- skulls (e.g. to the real EBlamGameSkulls member names) cannot silently
-- invalidate these checks.
local mandatory_ids, pool_ids, vis_ids = {}, {}, {}
for _, s in ipairs(Const.MANDATORY_SKULLS) do mandatory_ids[s.id] = true end
for _, s in ipairs(Const.SKULL_POOL) do pool_ids[s.id] = true end
for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do vis_ids[v.id] = true end

-- A skull may not be both mandatory and rollable, and visibility modifiers
-- must stay out of the roll pool (they are rolled separately, one per floor).
for id in pairs(mandatory_ids) do
    check(not pool_ids[id], "const: mandatory skull not in roll pool (" .. id .. ")")
end
for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do
    if v.skull then
        check(not pool_ids[v.skull],
            "const: visibility skull not in roll pool (" .. v.skull .. ")")
    end
end

-- Every skull the game can activate must be accounted for exactly once:
-- mandatory, rollable, or a visibility modifier. This list is the real
-- /Script/BlamGlue.EBlamGameSkulls member set read on-device (see
-- discovery/dumps/enums.md); a typo in const.lua would otherwise only surface
-- as a silently dropped skull at launch.
local REAL_SKULL_ENUM = [[Iron BlackEye ToughLuck Catch Fog Famine Thunderstorm
Tilt Mythic Assassin Blind Cowbell GruntBirthdayParty IWHBYD CustomRed
CustomYellow CustomBlue Angry Bandana BondedPair Boom Envy EyePatch Foreign
Ghost GruntFuneral Jacked Malfunction Masterblaster Pinata Recession Scarab
SoAngry Swarm ThatsJustWrong TheyComeBack BootsOffTheGround Adaptation Reload
SporeVisibility NightVision LightsOut Riskrun Pop Armistice EnduranceSpec
GiveAndTake StowAndGrow HipFire Temperamental FloorIsLava Magnified
JohnnyAmmoTree Leadhead Efficient ThirdPerson]]

local real_skulls, claimed = {}, {}
for w in REAL_SKULL_ENUM:gmatch("%S+") do real_skulls[w] = true end
local function claim_skull(id, where)
    check(real_skulls[id], "const: " .. where .. " id exists in the game enum (" .. id .. ")")
    check(not claimed[id], "const: id claimed only once (" .. id .. ")")
    claimed[id] = true
end
for _, s in ipairs(Const.MANDATORY_SKULLS) do claim_skull(s.id, "mandatory") end
for _, s in ipairs(Const.SKULL_POOL) do claim_skull(s.id, "pool") end
for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do
    if v.skull then claim_skull(v.skull, "visibility") end
end
-- Only the game's three empty custom-skull slots may be left out.
for id in pairs(real_skulls) do
    if not claimed[id] then
        check(id:match("^Custom") ~= nil,
            "const: unused enum member is a Custom slot, not a real skull (" .. id .. ")")
    end
end

local function validate_run(run, seed)
    check(#run.floors == 5, seed .. ": 5 floors")
    local mission_seen, alpha_count = {}, 0
    local skull_seen = {}
    for i, fl in ipairs(run.floors) do
        check(not mission_seen[fl.mission_id], seed .. ": missions distinct")
        mission_seen[fl.mission_id] = true
        if fl.rally == "Alpha" then alpha_count = alpha_count + 1 end
        check(fl.difficulty == Const.DIFFICULTY_LADDER[i].difficulty,
            seed .. ": ladder difficulty floor " .. i)
        check(fl.nerf == Const.DIFFICULTY_LADDER[i].nerf,
            seed .. ": ladder nerf floor " .. i)
        local n = #fl.new_skulls
        if i == 5 then
            check(n == Config.skull_roll.floor5, seed .. ": floor 5 skull count")
        else
            check(n >= Config.skull_roll.min and n <= Config.skull_roll.max,
                seed .. ": skull roll count floor " .. i)
        end
        for _, id in ipairs(fl.new_skulls) do
            check(not skull_seen[id], seed .. ": no duplicate skull " .. id)
            skull_seen[id] = true
            check(not mandatory_ids[id], seed .. ": mandatory skulls never rolled")
            check(pool_ids[id], seed .. ": rolled skull is in the pool (" .. id .. ")")
        end
        check(vis_ids[fl.visibility], seed .. ": visibility id valid")
    end
    check(alpha_count == 1, seed .. ": exactly one Alpha floor (got " .. alpha_count .. ")")
end

for i = 1, 200 do
    local seed = Rng.generate_seed_string() .. tostring(i)
    validate_run(Rungen.generate(seed), seed)
end

-- Determinism: same seed -> identical run.
local g1 = Rungen.generate("HALO-7K2M-QX9")
local g2 = Rungen.generate("HALO-7K2M-QX9")
check(Json.encode(g1) == Json.encode(g2), "rungen: deterministic from seed")

-- Cumulative skulls.
local active3 = Rungen.active_skulls(g1, 3)
local active5 = Rungen.active_skulls(g1, 5)
check(#active3 >= 4 + 3 and #active5 > #active3, "rungen: skulls accumulate")
check(active3[1] == Const.MANDATORY_SKULLS[1].id,
    "rungen: Iron always first mandatory")

-- The floor's visibility modifier rides along in active_skulls, and only that
-- floor's (visibility is per-floor, never cumulative).
for floor = 1, 5 do
    local act = Rungen.active_skulls(g1, floor)
    local seen_vis = {}
    for _, id in ipairs(act) do
        for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do
            if v.skull == id then seen_vis[#seen_vis + 1] = id end
        end
    end
    local want = nil
    for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do
        if v.id == g1.floors[floor].visibility then want = v.skull end
    end
    check(#seen_vis == (want and 1 or 0),
        "rungen: exactly this floor's visibility skull on floor " .. floor)
    if want then
        check(seen_vis[1] == want, "rungen: correct visibility skull floor " .. floor)
    end
end

-- ------------------------------------------------------------------ state
-- Stub paths so state persists into a temp dir on this (Linux) host.
local tmpdir = os.getenv("TMPDIR") or "/tmp"
local statefile = tmpdir .. "/hrlk_test_run.json"
package.loaded["paths"] = {
    join = function(...) return table.concat({ ... }, "/") end,
    run_state_file = function() return statefile end,
    mod_dir = function() return tmpdir end,
    dir_exists = function() return true end,
    file_exists = function(p) local f = io.open(p, "rb") if f then f:close() return true end return false end,
    mkdir = function() return true end,
    cmd = function() return {}, true end,
    q = function(p) return '"' .. p .. '"' end,
    count_files = function() return 0 end,
    list_dirs = function() return {} end,
}
local State = require("state")

os.remove(statefile)
local run = State.new_run("halo-7k2m-qx9", "20260728-000000")
check(run ~= nil and run.seed == "HALO-7K2M-QX9", "state: new run normalizes seed")
check(run.status == "active" and run.current_floor == 1, "state: starts active on floor 1")
check(State.current_floor_data().index == 1, "state: current floor data")

State.on_floor_launched()
check(run.floor_status == "in_mission", "state: launch -> in_mission")
check(State.on_death() == "continue", "state: death below cap continues")
check(run.deaths == 1, "state: death counted")

-- Floor advance
check(State.on_floor_complete() == "active", "state: floor 1 complete -> still active")
check(run.current_floor == 2 and run.floor_status == "briefing",
    "state: advanced to floor 2 briefing")

-- Death outside a mission is ignored
State.on_death()
check(run.deaths == 1, "state: death ignored during briefing")

-- Persistence roundtrip
State.run = nil
check(State.load(), "state: reload from disk")
check(State.run.seed == "HALO-7K2M-QX9" and State.run.current_floor == 2,
    "state: persisted fields survive reload")

-- Death cap loss
State.run.floor_status = "in_mission"
State.run.deaths = State.run.death_cap - 1
check(State.on_death() == "lost", "state: cap reached -> lost")
check(State.run.status == "lost", "state: status lost")

-- Win path
os.remove(statefile)
local run2 = State.new_run(nil, "20260728-000001")
check(run2.seed:match("^HALO%-") ~= nil, "state: random seed generated")
for floor = 1, 5 do
    State.on_floor_launched()
    local status = State.on_floor_complete()
    if floor < 5 then
        check(status == "active", "state: win path floor " .. floor)
    else
        check(status == "won", "state: run won after floor 5")
    end
end

-- --------------------------------------------------------------------- ui
local Ui = require("ui")

-- Fog of war: with an ACTIVE run on floor 2, floors 3+ must be hidden.
os.remove(statefile)
State.new_run("HALO-7K2M-QX9", "20260728-000002")
State.on_floor_launched()
State.on_floor_complete() -- now on floor 2
local card3 = Ui.floor_card_lines(State.run, 3)
check(#card3 == 1 and card3[1] == "FLOOR 3 — ???", "ui: fog of war hides floor 3")
local card1 = Ui.floor_card_lines(State.run, 1)
check(card1[1]:match("^FLOOR 1 — ") ~= nil, "ui: completed floor visible")
local card2 = Ui.floor_card_lines(State.run, 2)
check(card2[1]:match("^FLOOR 2 — ") ~= nil, "ui: current floor visible")

local counter = Ui.corner_counter()
check(counter:match("^FLOOR 2/5 · DEATHS 0/8$") ~= nil,
    "ui: corner counter format (" .. tostring(counter) .. ")")

-- Floor 4 card must print the literal nerf numbers once revealed.
State.run.current_floor = 4
local card4 = table.concat(Ui.floor_card_lines(State.run, 4), "\n")
check(card4:match("damage resistance: 50%%") ~= nil, "ui: nerf numbers on floor 4 card")
check(card4:match("Legendary %+") ~= nil, "ui: 'Legendary +' label")

-- Summary renders for a finished run.
State.run.status = "won"
State.run.finished_at = State.run.started_at + 3725
local summary = table.concat(Ui.summary_lines(), "\n")
check(summary:match("RUN COMPLETE") ~= nil, "ui: summary verdict")
check(summary:match("HALO%-7K2M%-QX9") ~= nil, "ui: summary shows seed")
check(summary:match("Time: 1:02:05") ~= nil, "ui: summary elapsed time")
check(summary:match("Iron") ~= nil, "ui: summary lists skulls")

-- Panel renders in every mode without erroring.
for _, mode in ipairs({ "menu", "confirm_new_run", "run", "summary" }) do
    Ui.mode = mode
    local ok, err = pcall(Ui.panel_lines, { mission_launch = false })
    check(ok, "ui: panel_lines mode " .. mode .. " (" .. tostring(err) .. ")")
end

-- compact_lines drives the in-menu submenu; the ▶/◀ prefixes are the contract
-- menuinject dispatches on, so every state must expose exactly the right rows.
local function prefixed(lines, prefix)
    local n = 0
    for _, l in ipairs(lines) do
        if l:sub(1, #prefix) == prefix then n = n + 1 end
    end
    return n
end

Ui.mode = "summary" -- finished run (status=won from above): close-run rows
local cl = Ui.compact_lines()
check(prefixed(cl, "\u{25B6}") == 1 and cl[2]:match("CLOSE RUN"),
    "ui: summary screen has one CLOSE RUN action")
check(prefixed(cl, "\u{25C0}") == 1, "ui: summary screen has a BACK row")

-- Root screen: BOTH entries are always offered, whether or not a run exists.
State.clear()
Ui.mode = "menu"
cl = Ui.compact_lines()
check(prefixed(cl, "\u{25B6}") == 2, "ui: root screen offers two actions")
check(cl[1] == "\u{25B6} START NEW RUN", "ui: root screen starts with START NEW RUN")
check(cl[2]:match("CONTINUE PREVIOUS RUN") ~= nil,
    "ui: root screen offers CONTINUE PREVIOUS RUN")
check(cl[2]:match("no run saved") ~= nil,
    "ui: continue entry says so when there is no run")

Ui.mode = "confirm_new_run"
cl = Ui.compact_lines()
check(prefixed(cl, "\u{25B6}") == 1 and prefixed(cl, "\u{25C0}") == 1,
    "ui: confirm screen has YES and BACK rows")

-- Floor select: five floor rows, a fixed-height detail panel, and fog of war.
State.new_run("HALO-7K2M-QX9", "20260728-000003")
Ui.mode = "menu"
cl = Ui.compact_lines()
check(cl[2]:match("floor 1/5") ~= nil,
    "ui: continue entry shows the run's progress once a run exists")

Ui.mode = "floors"
Ui.focus_text = nil
cl = Ui.compact_lines()
local blob = table.concat(cl, "\n")
check(prefixed(cl, "\u{25B6}") == 1 and cl[2]:match("^\u{25B6} FLOOR 1 ") ~= nil,
    "ui: only the current floor is launchable")
check(blob:match("FLOOR 3 \u{2014} LOCKED") ~= nil, "ui: locked floors stay fogged")
check(blob:match("Skulls active %\u{28}%d+%\u{29}:") ~= nil,
    "ui: detail panel lists the active skulls")
check(blob:match("Rally Point") ~= nil, "ui: detail panel names the rally point")

-- The row count must not change as the highlight moves, or the focused row
-- would shift under the player mid-selection.
local base = #cl
for floor = 1, 5 do
    Ui.focus_text = "FLOOR " .. floor
    check(#Ui.compact_lines() == base,
        "ui: row count is stable while highlighting floor " .. floor)
end

-- Highlighting a revealed floor describes THAT floor; a locked one stays hidden.
Ui.focus_text = "FLOOR 1"
check(table.concat(Ui.compact_lines(), "\n"):match("FLOOR 1 \u{2014} ") ~= nil,
    "ui: highlighting floor 1 describes floor 1")
Ui.focus_text = "FLOOR 4"
check(table.concat(Ui.compact_lines(), "\n"):match("Clear the floors before it") ~= nil,
    "ui: highlighting a locked floor reveals nothing")

Ui.focus_text = nil
State.on_floor_launched()
cl = Ui.compact_lines()
check(table.concat(cl, "\n"):match("MARK FLOOR COMPLETE") ~= nil,
    "ui: in-mission floor offers MARK FLOOR COMPLETE")
check(table.concat(cl, "\n"):match("in progress") ~= nil,
    "ui: in-mission floor is marked in progress")

-- ------------------------------------------------------------------ done
os.remove(statefile)
print = real_print
if failures == 0 then
    real_print(string.format("OK — %d checks passed", checks))
    os.exit(0)
else
    real_print(string.format("%d/%d checks FAILED", failures, checks))
    os.exit(1)
end
