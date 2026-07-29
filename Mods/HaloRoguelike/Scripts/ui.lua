-- ui.lua — overlay rendering.
--
-- Two backends behind one view-model:
--   * ImGui, when the UE4SS build exposes Lua ImGui bindings (a global `ImGui`
--     table). The HCE UE4SS fork is C++-side ImGui; whether Lua bindings are
--     exposed depends on the build — adapt `imgui_render` to the fork's actual
--     binding shape once confirmed (this is intentionally the only function
--     that touches ImGui calls).
--   * Text fallback: the same panel rendered as lines into the UE4SS console/
--     log whenever it changes, with hotkeys standing in for buttons. This
--     keeps every milestone testable before the ImGui shape is pinned down.
--
-- Fog of war is enforced HERE and only here: floors > current_floor render as
-- "FLOOR n — ???" regardless of what the state file contains.

local Const   = require("const")
local Config  = require("config")
local Log     = require("log")
local State   = require("state")
local Presets = require("presets")

local Ui = {}

Ui.visible = false
-- Panel modes: "menu" | "confirm_new_run" | "floors" | "summary".
-- These names are shared with compact_lines (the in-menu rows); a mode that
-- only one of the two knew about rendered an empty panel and a row list that
-- changed length under the player's focus (on-device 2026-07-29).
Ui.mode = "menu"
-- Transient notice line (errors, capability warnings).
Ui.notice = nil

-- ---------------------------------------------------------------- lookups

local function mission_by_id(id)
    for _, m in ipairs(Const.MISSIONS) do
        if m.id == id then return m end
    end
    return { id = id, name = id }
end

local function skull_by_id(id)
    for _, s in ipairs(Const.MANDATORY_SKULLS) do
        if s.id == id then return s end
    end
    for _, s in ipairs(Const.SKULL_POOL) do
        if s.id == id then return s end
    end
    -- Visibility modifiers are skulls too, and they show up in a floor's
    -- active list; without this they rendered as raw ids ("LightsOut").
    for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do
        if v.skull == id then
            return { id = id, name = v.name, desc = "Visibility modifier" }
        end
    end
    return { id = id, name = id, desc = "" }
end

local function vis_by_id(id)
    for _, v in ipairs(Const.VISIBILITY_MODIFIERS) do
        if v.id == id then return v end
    end
    return { id = id, name = id }
end

local function fmt_elapsed(seconds)
    return string.format("%d:%02d:%02d",
        seconds // 3600, (seconds // 60) % 60, seconds % 60)
end

-- ---------------------------------------------------------------- view model

-- One floor card as a list of text lines. `revealed` controls fog of war.
function Ui.floor_card_lines(run, index)
    local fl = run.floors[index]
    local lines = {}
    if index > run.current_floor and run.status == State.STATUS.ACTIVE then
        return { string.format("FLOOR %d — ???", index) }
    end

    local diff = fl.difficulty .. (fl.nerf and " +" or "")
    lines[#lines + 1] = string.format("FLOOR %d — %s", index,
        mission_by_id(fl.mission_id).name)
    lines[#lines + 1] = string.format("  Rally Point %s · %s · Visibility: %s",
        fl.rally, diff, vis_by_id(fl.visibility).name)
    if fl.nerf then
        for _, l in ipairs(Presets.describe()) do
            lines[#lines + 1] = "    " .. l
        end
    end
    if index == run.current_floor and run.status == State.STATUS.ACTIVE then
        lines[#lines + 1] = "  New skulls this floor:"
        for _, id in ipairs(fl.new_skulls) do
            local s = skull_by_id(id)
            lines[#lines + 1] = string.format("    + %s — %s", s.name, s.desc)
        end
    else
        local names = {}
        for _, id in ipairs(fl.new_skulls) do names[#names + 1] = skull_by_id(id).name end
        lines[#lines + 1] = "  Skulls gained: " .. table.concat(names, ", ")
    end
    return lines
end

function Ui.active_skull_lines()
    local lines = {}
    for _, id in ipairs(State.active_skulls()) do
        local s = skull_by_id(id)
        lines[#lines + 1] = string.format("  %s — %s", s.name, s.desc)
    end
    return lines
end

-- In-mission corner counter: "FLOOR 1/5 · DEATHS 2/8"
function Ui.corner_counter()
    local run = State.run
    if not run or run.status ~= State.STATUS.ACTIVE then return nil end
    local cap = run.death_cap > 0 and tostring(run.death_cap) or "∞"
    return string.format("FLOOR %d/%d · DEATHS %d/%s",
        run.current_floor, Const.FLOORS_PER_RUN, run.deaths, cap)
end

function Ui.summary_lines()
    local run = State.run
    if not run then return {} end
    local lines = {}
    local verdict = run.status == State.STATUS.WON and "RUN COMPLETE"
        or run.status == State.STATUS.LOST and "RUN LOST — DEATH CAP REACHED"
        or "RUN ABANDONED"
    lines[#lines + 1] = "════════════════════════════════════"
    lines[#lines + 1] = "  " .. verdict
    lines[#lines + 1] = "  Seed: " .. run.seed
    lines[#lines + 1] = "════════════════════════════════════"
    for i = 1, Const.FLOORS_PER_RUN do
        local fl = run.floors[i]
        local reached = i <= run.current_floor
        local mark
        if run.status == State.STATUS.WON then mark = "✓"
        elseif i < run.current_floor then mark = "✓"
        elseif i == run.current_floor and reached then mark = "✗"
        else mark = "·" end
        lines[#lines + 1] = string.format("  %s Floor %d: %s @ Rally %s (%s%s)",
            mark, i, mission_by_id(fl.mission_id).name, fl.rally,
            fl.difficulty, fl.nerf and " +" or "")
    end
    local skulls = {}
    for _, s in ipairs(Const.MANDATORY_SKULLS) do skulls[#skulls + 1] = s.name end
    local last = run.status == State.STATUS.WON and Const.FLOORS_PER_RUN
        or run.current_floor
    for i = 1, last do
        for _, id in ipairs(run.floors[i].new_skulls) do
            skulls[#skulls + 1] = skull_by_id(id).name
        end
    end
    lines[#lines + 1] = "  Skulls carried: " .. table.concat(skulls, ", ")
    lines[#lines + 1] = string.format("  Deaths: %d", run.deaths)
    lines[#lines + 1] = string.format("  Time: %s", fmt_elapsed(State.elapsed()))
    lines[#lines + 1] = "════════════════════════════════════"
    return lines
end

-- The mode actually rendered. "floors" and "summary" both need a run; without
-- one they fall back to the root screen, so the panel and the in-menu rows can
-- never disagree about which screen is showing.
local function effective_mode()
    local m = Ui.mode
    if (m == "floors" or m == "summary") and not State.run then return "menu" end
    return m
end

-- Whole panel as lines (used verbatim by the text backend; the ImGui backend
-- renders the same view model with widgets).
function Ui.panel_lines(capability_status)
    local mode = effective_mode()
    local k = Config.keys
    local lines = { "╔═ HALO ROGUELIKE ═════════════════════" }
    local function add(l) lines[#lines + 1] = l end

    if Ui.notice then add("‼ " .. Ui.notice) end

    if mode == "menu" then
        add("  ▶ Select ROGUELIKE in the main menu to "
            .. ((State.run and State.run.status == State.STATUS.ACTIVE)
                and "resume the run" or "start a new run"))
        if State.run and State.run.status == State.STATUS.ACTIVE then
            add(string.format("  Resume: floor %d/%d, seed %s",
                State.run.current_floor, Const.FLOORS_PER_RUN, State.run.seed))
        end
        add("  Exit mode (restore save): " .. k.exit_mode .. " key")
    elseif mode == "confirm_new_run" then
        add("  STARTING A RUN WILL:")
        add("   • back up, then OVERWRITE your solo campaign save (New Game)")
        add("   • very likely DISABLE ACHIEVEMENTS while modifiers are active")
        add("  Your save is restored and modifiers cleared when you exit the mode.")
        add("  ▶ Confirm with the YES row in the ROGUELIKE menu")
        add("  ◀ Cancel with the NO row (or the " .. k.toggle_overlay .. " key)")
    elseif mode == "floors" and State.run then
        local run = State.run
        add("  Seed: " .. run.seed .. "   " .. (Ui.corner_counter() or ""))
        add("")
        for i = 1, Const.FLOORS_PER_RUN do
            for _, l in ipairs(Ui.floor_card_lines(run, i)) do add(l) end
        end
        add("")
        add("  Active skulls:")
        for _, l in ipairs(Ui.active_skull_lines()) do add(l) end
        if run.floor_status == State.FLOOR.BRIEFING then
            add("  ▶ Select the FLOOR " .. run.current_floor
                .. " row in the ROGUELIKE menu to launch it")
        else
            add("  Floor in progress — select MARK FLOOR COMPLETE in the")
            add("  ROGUELIKE menu after beating the mission")
        end
        if capability_status and not capability_status.mission_launch then
            add("  (launch call unresolved: start the mission manually with the")
            add("   settings above; skulls via debug menu 'G' — see README)")
        end
    elseif mode == "summary" then
        for _, l in ipairs(Ui.summary_lines()) do add(l) end
        add("  ▶ Select CLOSE RUN in the ROGUELIKE menu (restores save)")
    end

    add("╚══════════════════════════════════════")
    return lines
end

-- ------------------------------------------------- in-menu submenu rendering
--
-- Row prefixes are the contract menuinject dispatches on:
--   "▶ " selectable action · "◀ " back · anything else informational.
-- Rows are activated by clicking them or by holding gamepad focus on them,
-- so no keyboard is ever required.
--
-- Screens (Ui.mode):
--   "menu"            root: START NEW RUN / CONTINUE PREVIOUS RUN
--   "confirm_new_run" warning + YES/NO
--   "floors"          mission-select-style floor list + detail panel
--   "summary"         end-of-run verdict
--
-- Ui.focus_text is the text of the row the player is currently highlighting,
-- fed back by menuinject. The floor screen uses it to fill the detail panel,
-- mirroring how the game's own Mission Select shows a description beside the
-- highlighted mission.
Ui.focus_text = nil

-- Detail panel is a FIXED number of rows: the row list must not change length
-- while the player moves through it, or the focused row shifts under them.
local DETAIL_ROWS = 6

local function pad_to(lines, n)
    while #lines < n do lines[#lines + 1] = " " end
    return lines
end

-- Which floor the player is highlighting, parsed from the focused row text.
function Ui.focused_floor()
    if not Ui.focus_text then return nil end
    local n = Ui.focus_text:match("FLOOR (%d+)")
    return n and tonumber(n) or nil
end

-- The detail panel for one floor: mission, rally point, difficulty and every
-- skull active on that floor. Fog of war applies — a locked floor shows
-- nothing but its lock.
function Ui.floor_detail_lines(index)
    local run = State.run
    if not run or not run.floors[index] then return {} end
    local fl = run.floors[index]
    local locked = index > run.current_floor and run.status == State.STATUS.ACTIVE
    if locked then
        return pad_to({
            string.format("FLOOR %d — LOCKED", index),
            "Clear the floors before it to reveal this one.",
        }, DETAIL_ROWS)
    end

    local out = {
        string.format("FLOOR %d — %s", index, mission_by_id(fl.mission_id).name),
        string.format("Rally Point %s  ·  %s%s  ·  Visibility: %s",
            fl.rally, fl.difficulty, fl.nerf and " +" or "",
            vis_by_id(fl.visibility).name),
    }
    -- Every skull that will be on for this floor, not just the new ones.
    local names = {}
    for _, id in ipairs(State.skulls_for_floor(index)) do
        names[#names + 1] = skull_by_id(id).name
    end
    out[#out + 1] = string.format("Skulls active (%d):", #names)
    -- Fill each row up to the menu row's usable width rather than splitting
    -- the names evenly, which left rows half empty.
    local room = DETAIL_ROWS - #out
    local line = ""
    for i, n in ipairs(names) do
        local sep = (line == "") and "" or ", "
        if #line + #sep + #n > 58 and #out < DETAIL_ROWS then
            out[#out + 1] = "  " .. line
            line = n
        else
            line = line .. sep .. n
        end
        -- Out of rows: fold whatever is left into a count.
        if #out == DETAIL_ROWS - 1 and i < #names then
            line = line .. string.format(" (+%d more)", #names - i)
            break
        end
    end
    if line ~= "" and #out < DETAIL_ROWS then out[#out + 1] = "  " .. line end
    return pad_to(out, DETAIL_ROWS)
end

function Ui.compact_lines()
    local run = State.run
    local mode = effective_mode()

    if mode == "confirm_new_run" then
        return {
            "START RUN? Your save is backed up first, then overwritten",
            "Achievements likely OFF until you exit the mode",
            "▶ YES — START THE RUN",
            "◀ NO — BACK",
        }
    end

    if mode == "summary" and run then
        local verdict = run.status == State.STATUS.WON and "RUN WON"
            or run.status == State.STATUS.LOST and "RUN LOST" or "RUN ENDED"
        return {
            string.format("%s · seed %s · %d deaths", verdict, run.seed, run.deaths),
            "▶ CLOSE RUN — RESTORE MY CAMPAIGN SAVE",
            "◀ BACK",
        }
    end

    -- Floor select: the mission-select-style screen.
    if mode == "floors" and run then
        local in_mission = run.floor_status ~= State.FLOOR.BRIEFING
        local lines = {
            string.format("%s  ·  %s", run.seed, Ui.corner_counter() or ""),
        }
        for i = 1, Const.FLOORS_PER_RUN do
            local fl = run.floors[i]
            if i > run.current_floor then
                lines[#lines + 1] = string.format("FLOOR %d — LOCKED", i)
            elseif i < run.current_floor then
                lines[#lines + 1] = string.format("FLOOR %d ✓ %s", i,
                    mission_by_id(fl.mission_id).name)
            elseif in_mission then
                lines[#lines + 1] = string.format("FLOOR %d ⏳ %s (in progress)", i,
                    mission_by_id(fl.mission_id).name)
            else
                lines[#lines + 1] = string.format("▶ FLOOR %d — %s", i,
                    mission_by_id(fl.mission_id).name)
            end
        end
        lines[#lines + 1] = "────────────────────────────"
        -- Detail for whichever floor is highlighted, defaulting to the current
        -- one so the panel is never blank.
        for _, l in ipairs(Ui.floor_detail_lines(Ui.focused_floor()
            or run.current_floor)) do
            lines[#lines + 1] = l
        end
        if in_mission then
            lines[#lines + 1] = "▶ MARK FLOOR COMPLETE (after beating the mission)"
        end
        lines[#lines + 1] = "◀ BACK"
        return lines
    end

    -- Root: always both entries, exactly as the campaign menu offers new game
    -- and resume side by side.
    local resume = "▶ CONTINUE PREVIOUS RUN"
    if run and run.status == State.STATUS.ACTIVE then
        resume = string.format("▶ CONTINUE PREVIOUS RUN — %s, floor %d/%d",
            run.seed, run.current_floor, Const.FLOORS_PER_RUN)
    elseif run then
        resume = "▶ CONTINUE PREVIOUS RUN — finished run, view summary"
    else
        resume = "▶ CONTINUE PREVIOUS RUN — (no run saved yet)"
    end
    return {
        "▶ START NEW RUN",
        resume,
        "◀ BACK",
    }
end

-- ---------------------------------------------------------------- backends

local have_imgui = type(_G.ImGui) == "table"

-- Text backend: reprint on every dirty render.
local last_render = nil
local function text_render(capability_status)
    if not Ui.visible then return end
    local lines = Ui.panel_lines(capability_status)
    local blob = table.concat(lines, "\n")
    if blob == last_render then return end
    last_render = blob
    for _, l in ipairs(lines) do
        print("[HRLK-UI] " .. l .. "\n")
    end
end

-- ImGui backend. NOTE: adapt to the HCE fork's actual Lua binding shape; the
-- calls below assume a conventional Begin/Text/Button/End surface.
local function imgui_render(capability_status)
    if not Ui.visible then return end
    local ImGui = _G.ImGui
    if not ImGui.Begin("Halo Roguelike") then ImGui.End() return end
    for _, l in ipairs(Ui.panel_lines(capability_status)) do
        ImGui.Text(l)
    end
    ImGui.End()
end

function Ui.render(capability_status)
    if have_imgui then
        local ok, err = pcall(imgui_render, capability_status)
        if not ok then
            Log.warn("ui: ImGui backend failed (%s); falling back to text", tostring(err))
            have_imgui = false
        end
    end
    if not have_imgui then
        text_render(capability_status)
    end
end

function Ui.dirty()
    last_render = nil
end

function Ui.toggle()
    Ui.visible = not Ui.visible
    -- Cancel path for the confirm dialog.
    if not Ui.visible and Ui.mode == "confirm_new_run" then Ui.mode = "menu" end
    Ui.dirty()
    if Ui.visible then
        Log.info("ui: overlay opened (mode=%s, backend=%s)", Ui.mode,
            have_imgui and "imgui" or "text")
    end
end

function Ui.set_notice(msg)
    Ui.notice = msg
    Ui.dirty()
    if msg then Log.info("ui: notice — %s", msg) end
end

return Ui
