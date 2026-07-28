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
            check(id ~= "iron" and id ~= "adaptation" and id ~= "reload"
                and id ~= "armistice", seed .. ": mandatory skulls never rolled")
        end
        local vis_ok = fl.visibility == "default" or fl.visibility == "spore"
            or fl.visibility == "nightvision"
        check(vis_ok, seed .. ": visibility id valid")
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
check(active3[1] == "iron", "rungen: iron always first mandatory")

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

Ui.mode = "run" -- finished run (status=won from above): close-run rows
local cl = Ui.compact_lines()
check(prefixed(cl, "▶") == 1 and cl[2]:match("CLOSE RUN"),
    "ui: compact ended-run has one ▶ CLOSE RUN row")
check(prefixed(cl, "◀") == 1, "ui: compact ended-run has a ◀ BACK row")

State.clear()
Ui.mode = "menu" -- no run at all
cl = Ui.compact_lines()
check(prefixed(cl, "▶") == 1 and cl[1] == "▶ START NEW RUN",
    "ui: compact no-run offers START NEW RUN")
Ui.mode = "confirm_new_run"
cl = Ui.compact_lines()
check(prefixed(cl, "▶") == 1 and prefixed(cl, "◀") == 1,
    "ui: compact confirm has YES and BACK rows")

-- Active run: the current floor is the single ▶ row while briefing, and
-- flips to MARK FLOOR COMPLETE while the mission runs. Locked floors stay fogged.
State.new_run("HALO-7K2M-QX9", "20260728-000003")
Ui.mode = "run"
cl = Ui.compact_lines()
check(prefixed(cl, "▶") == 1 and cl[2]:match("^▶ FLOOR 1: ") ~= nil,
    "ui: compact briefing has one ▶ floor row")
check(table.concat(cl, "\n"):match("FLOOR 3 — LOCKED") ~= nil,
    "ui: compact locked floors fogged")
State.on_floor_launched()
cl = Ui.compact_lines()
check(prefixed(cl, "▶") == 1
    and table.concat(cl, "\n"):match("MARK FLOOR COMPLETE") ~= nil,
    "ui: compact in-mission has one ▶ MARK FLOOR COMPLETE row")
check(table.concat(cl, "\n"):match("⏳") ~= nil,
    "ui: compact in-mission floor marked in progress")

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
