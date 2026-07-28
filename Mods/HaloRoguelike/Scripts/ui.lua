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
-- Panel modes: "menu" | "confirm_new_run" | "run" | "summary"
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

-- Whole panel as lines (used verbatim by the text backend; the ImGui backend
-- renders the same view model with widgets).
function Ui.panel_lines(capability_status)
    local k = Config.keys
    local lines = { "╔═ HALO ROGUELIKE ═════════════════════" }
    local function add(l) lines[#lines + 1] = l end

    if Ui.notice then add("‼ " .. Ui.notice) end

    if Ui.mode == "menu" then
        add("  [" .. k.primary_action .. "] New run"
            .. (State.run and State.run.status == State.STATUS.ACTIVE
                and "   (a run is in progress — resumes instead)" or ""))
        if State.run and State.run.status == State.STATUS.ACTIVE then
            add(string.format("  Resume: floor %d/%d, seed %s",
                State.run.current_floor, Const.FLOORS_PER_RUN, State.run.seed))
        end
        add("  [" .. k.exit_mode .. "] Exit mode (restore save)")
    elseif Ui.mode == "confirm_new_run" then
        add("  STARTING A RUN WILL:")
        add("   • back up, then OVERWRITE your solo campaign save (New Game)")
        add("   • very likely DISABLE ACHIEVEMENTS while modifiers are active")
        add("  Your save is restored and modifiers cleared when you exit the mode.")
        add("  [" .. k.primary_action .. "] I understand — start the run")
        add("  [" .. k.toggle_overlay .. "] Cancel")
    elseif Ui.mode == "run" and State.run then
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
            add("  [" .. k.primary_action .. "] START FLOOR "
                .. run.current_floor)
        else
            add("  Floor in progress. [" .. k.primary_action
                .. "] mark floor complete (manual fallback)")
        end
        if capability_status and not capability_status.mission_launch then
            add("  (launch call unresolved: start the mission manually with the")
            add("   settings above; skulls via debug menu 'G' — see README)")
        end
    elseif Ui.mode == "summary" then
        for _, l in ipairs(Ui.summary_lines()) do add(l) end
        add("  [" .. k.primary_action .. "] Done (restore save & clear run)")
    end

    add("╚══════════════════════════════════════")
    return lines
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
