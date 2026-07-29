-- main.lua — HaloRoguelike entry point (UE4SS Lua mod).
--
-- Wires together: build check -> keybinds -> run state machine -> game hooks
-- -> overlay. See README.md for install and docs/DISCOVERY.md for resolving
-- the game-API unknowns. Requires the HCE-specific UE4SS fork (Nexus mod 9);
-- stock UE4SS does not start on this game.

local Log       = require("log")
local Config    = require("config")
local Const     = require("const")
local State     = require("state")
local Saveguard = require("saveguard")
local Gameapi   = require("gameapi")
local Ui        = require("ui")
local Menuinject = require("menuinject")

Log.info("=======================================================")
Log.info("Halo: Campaign Evolved — Roguelike mod loading")
Log.info("=======================================================")

-- Set true once init succeeds; every action checks it. F9 (emergency save
-- restore) is deliberately exempt so a bad build can still un-brick a save.
local enabled = false
local init_done = false

-- Debounce for the death hook: ClientRestart also fires on the initial spawn
-- after a launch, so the first event per floor is swallowed.
local expect_spawn_event = false

-- Last world name seen by the polling loop, used to react to transitions
-- (menu -> mission and back). Polled rather than hooked: RegisterLoadMapPost
-- Hook fired only for the first world on-device.
local last_world = nil

-- Set the moment a mission world appears after a launch, cleared when a
-- launch is issued. The watchdog checks THIS rather than "is a mission world
-- loaded right now": on-device the mission loaded fine, the player finished
-- with it and returned to the menu, and the 45s check then wrongly declared
-- the launch failed.
local mission_seen_since_launch = false

-- ------------------------------------------------------------- floor flow

local function handle_run_ended()
    -- WON or LOST: clear modifiers immediately so achievements come back the
    -- moment the run is over; save restore happens when the summary is closed.
    Gameapi.clear_modifiers()
    Ui.mode = "summary"
    Ui.visible = true
    Ui.dirty()
end

local function handle_floor_complete()
    local status = State.on_floor_complete()
    if status == State.STATUS.WON then
        Ui.set_notice("Run complete!")
        handle_run_ended()
    elseif status == State.STATUS.ACTIVE then
        Ui.set_notice(string.format("Floor complete — floor %d revealed",
            State.run.current_floor))
        Ui.mode = "floors"
        Ui.visible = true
        Ui.dirty()
    end
end

local function handle_death()
    if not State.run or State.run.floor_status ~= State.FLOOR.IN_MISSION then
        return
    end
    if expect_spawn_event then
        expect_spawn_event = false
        Log.info("main: swallowing initial spawn event")
        return
    end
    -- ClientRestart also fires on world transitions, so quitting a mission
    -- back to the menus counted as a death on-device (2026-07-29). A death
    -- only counts while a mission world is actually loaded.
    if Gameapi.in_mission_world() == false then
        Log.info("main: ignoring ClientRestart outside a mission world "
            .. "(quit to menu, not a death)")
        return
    end
    local result = State.on_death()
    Ui.dirty()
    if result == "lost" then
        Ui.set_notice("Death cap reached")
        handle_run_ended()
    end
end

local function start_current_floor()
    local fl = State.current_floor_data()
    if not fl then return end

    -- Difficulty modifiers: nerf preset live on floors 4-5, cleared otherwise.
    if fl.nerf then
        if not Gameapi.apply_nerf_preset() then
            Ui.set_notice("Nerf preset could NOT be applied — floor runs at plain "
                .. fl.difficulty .. " (see UE4SS.log)")
        end
    else
        Gameapi.clear_modifiers()
    end

    local skulls = State.active_skulls()
    mission_seen_since_launch = false
    local ok, err = Gameapi.launch_floor(fl, skulls)
    if ok then
        Ui.set_notice(nil)
        -- Restore the main menu before the mission takes over: leftover
        -- visible/focusable mod rows in the persistent widget tree steal
        -- controller focus in-game (symptom: pause menu never shows).
        Menuinject.close()
        -- Watchdog: a launch call can report OK yet load nothing (seen
        -- on-device with a wrong CampaignData asset). The check asks the
        -- engine which world is loaded rather than trusting a map-load hook —
        -- that hook fired only for the first world on-device and wrongly
        -- reverted a floor whose mission had in fact loaded.
        pcall(function()
            LoopAsync(45000, function()
                if not (State.run
                    and State.run.floor_status == State.FLOOR.IN_MISSION) then
                    return true
                end
                if not mission_seen_since_launch
                    and Gameapi.in_mission_world() == false then
                    Log.warn("main: launch reported OK but no mission world "
                        .. "ever loaded within 45s — reverting floor to briefing")
                    Gameapi.distrust_campmenu_launch()
                    State.run.floor_status = State.FLOOR.BRIEFING
                    State.save()
                    Ui.set_notice("Launch did not take — select the floor again")
                    Ui.dirty()
                else
                    Log.info("main: mission world confirmed loaded (%s)",
                        tostring(Gameapi.current_world_name()))
                end
                return true
            end)
        end)
    else
        -- Manual-launch fallback: the floor card shows mission/rally/difficulty;
        -- the player launches via Campaign -> New Game (+ debug menu for skulls).
        Ui.set_notice("Auto-launch unavailable — launch manually per the floor card. ("
            .. tostring(err) .. ")")
    end
    expect_spawn_event = true
    State.on_floor_launched()
    Ui.dirty()
end

local function begin_new_run()
    local backup_id, err = Saveguard.backup()
    if not backup_id then
        Ui.set_notice("SAVE BACKUP FAILED — run NOT started: " .. tostring(err))
        return
    end
    local run, rerr = State.new_run(nil, backup_id)
    if not run then
        Ui.set_notice("Could not start run: " .. tostring(rerr))
        return
    end
    Ui.mode = "floors"
    Ui.set_notice("Run started — seed " .. run.seed
        .. " (achievements likely disabled until you exit the mode)")
end

local function exit_mode()
    -- Restore save + clear modifiers, per brief §10 step 10.
    Gameapi.clear_modifiers()
    if State.run and State.run.status == State.STATUS.ACTIVE then
        State.abandon()
    end
    local ok, err = Saveguard.restore()
    if ok then
        Ui.set_notice("Campaign save restored; modifiers cleared")
    elseif err ~= "no backups exist" then
        Ui.set_notice("Save restore FAILED: " .. tostring(err))
    end
    if State.run and State.run.status ~= State.STATUS.ACTIVE then
        Ui.mode = "summary"
    else
        Ui.mode = "menu"
    end
    Ui.visible = true
    Ui.dirty()
end

local function close_summary()
    -- Summary dismissed: make sure the save is back, then clear the run.
    Saveguard.restore()
    Gameapi.clear_modifiers()
    State.clear()
    Ui.mode = "menu"
    Ui.set_notice("Save restored — back to normal campaign")
end

-- ------------------------------------------------------------- actions

-- Rows are dispatched on their TEXT, not on the current mode: the submenu now
-- shows several distinct actions per screen (start / continue / a specific
-- floor / mark complete), so a single "primary action" per mode no longer
-- describes what the player picked.
local function on_menu_row(text)
    if not enabled then
        Log.warn("main: mod disabled (build check failed?) — ignoring input")
        return
    end
    local run = State.run

    if text:find("YES — START THE RUN", 1, true) then
        begin_new_run()

    elseif text:find("START NEW RUN", 1, true) then
        Ui.mode = "confirm_new_run"

    elseif text:find("CONTINUE PREVIOUS RUN", 1, true) then
        if run and run.status == State.STATUS.ACTIVE then
            Ui.mode = "floors"
        elseif run then
            Ui.mode = "summary"
        else
            Ui.set_notice("No previous run saved — start a new one")
        end

    elseif text:find("CLOSE RUN", 1, true) then
        close_summary()

    elseif text:find("MARK FLOOR COMPLETE", 1, true) then
        Log.info("main: manual floor-complete trigger")
        handle_floor_complete()

    else
        local n = tonumber(text:match("FLOOR (%d+)"))
        if n and run then
            if n ~= run.current_floor then
                Ui.set_notice(string.format(
                    "Floor %d is not the floor you are on — play floor %d next",
                    n, run.current_floor))
            elseif run.floor_status ~= State.FLOOR.BRIEFING then
                Ui.set_notice("That floor is already running")
            else
                start_current_floor()
            end
        end
    end
    Ui.visible = true
    Ui.dirty()
end

-- F5 keeps working as a shortcut for "the obvious thing on this screen".
local function primary_action()
    if not enabled then return end
    if Ui.mode == "confirm_new_run" then
        on_menu_row("▶ YES — START THE RUN")
    elseif Ui.mode == "summary" then
        on_menu_row("▶ CLOSE RUN")
    elseif Ui.mode == "floors" and State.run then
        if State.run.floor_status == State.FLOOR.BRIEFING then
            on_menu_row("FLOOR " .. State.run.current_floor)
        else
            on_menu_row("▶ MARK FLOOR COMPLETE")
        end
    elseif State.run and State.run.status == State.STATUS.ACTIVE then
        on_menu_row("▶ CONTINUE PREVIOUS RUN")
    else
        on_menu_row("▶ START NEW RUN")
    end
end

-- ------------------------------------------------------------- init

local function register_keybinds()
    local K = Key or {}
    local binds = {
        { Config.keys.toggle_overlay, function()
            if not enabled then return end
            if State.run and (State.run.status ~= State.STATUS.ACTIVE)
                and Ui.mode ~= "summary" then
                Ui.mode = "summary"
            end
            Ui.toggle()
        end },
        { Config.keys.primary_action, primary_action },
        { Config.keys.discovery_dump, function() Gameapi.discovery_dump() end },
        { Config.keys.exit_mode, function()
            if not enabled then return end
            exit_mode()
        end },
        { Config.keys.emergency_restore, function()
            -- Works even when disabled: this is the un-brick button.
            local ok, err = Saveguard.restore()
            Ui.set_notice(ok and "EMERGENCY RESTORE done"
                or ("EMERGENCY RESTORE failed: " .. tostring(err)))
        end },
    }
    for _, b in ipairs(binds) do
        local keyname, fn = b[1], b[2]
        local ok, err = pcall(function()
            RegisterKeyBind(K[keyname], {}, fn)
        end)
        if ok then
            Log.info("main: bound %s", keyname)
        else
            Log.error("main: could not bind %s: %s", keyname, tostring(err))
        end
    end
end

local function finish_init(build_ok, build)
    if not build_ok and not Config.allow_unknown_build then
        Log.error("main: UNKNOWN BUILD %q — refusing to enable. Known builds are "
            .. "listed in const.lua; set config.allow_unknown_build=true to force "
            .. "after re-verifying signatures.", tostring(build))
        Log.error("main: F9 (emergency save restore) remains available.")
        enabled = false
        return
    end
    if not build_ok then
        Log.warn("main: unknown build %q but allow_unknown_build=true — proceeding",
            tostring(build))
    end

    enabled = true
    Gameapi.resolve()
    -- Read EBlamGameSkulls / EBlamCampaignDifficultyLevel from the live UEnum
    -- objects: the CXX header dump names these enums but not their members,
    -- and the launch call needs the real values.
    pcall(Gameapi.dump_enums)
    Gameapi.on_mission_complete(handle_floor_complete)
    Gameapi.on_player_death(handle_death)

    -- Native "ROGUELIKE" entry in the main-menu list. Activating it (click or
    -- ~1s of gamepad focus) opens the roguelike SUBMENU: the game's own menu
    -- rows are hidden and replaced by the mod's rows (menuinject). Fires when
    -- the submenu opens — sync the UI mode to the run state.
    Menuinject.start(function()
        if State.run and State.run.status ~= State.STATUS.ACTIVE then
            Ui.mode = "summary"
        elseif State.run then
            Ui.mode = "run"
        else
            Ui.mode = "menu"
        end
        Ui.visible = true
        Ui.dirty()
    end)
    -- Submenu row activated. "◀" rows go back (menuinject already restored
    -- the main menu); "▶" rows are the primary action for the current mode:
    -- start run confirm -> begin run -> launch floor / mark complete -> close.
    Menuinject.set_row_callback(function(text)
        if text:sub(1, #"◀") == "◀" then
            -- BACK steps one screen up rather than closing outright, so the
            -- floor list returns to the start/continue screen first.
            if Ui.mode == "floors" or Ui.mode == "summary"
                or Ui.mode == "confirm_new_run" then
                Ui.mode = "menu"
                Ui.dirty()
                Menuinject.reopen()
            else
                Ui.visible = false
                Ui.dirty()
            end
            return
        end
        on_menu_row(text)
    end)
    -- Highlighting a floor fills the detail panel beside the list.
    Menuinject.set_focus_callback(function(text)
        if Ui.focus_text ~= text then
            Ui.focus_text = text
            Ui.dirty()
        end
    end)

    -- Map-load hook: logs real mission level names (discovery), force-closes
    -- the in-menu submenu on every transition (stale mod rows must never sit
    -- visible/focusable over a mission — that blocks the pause menu), and
    -- kicks the in-mission skull discovery once a Solo mission map is up.
    local ok_hook = pcall(function()
        RegisterLoadMapPostHook(function(...)
            local parts = {}
            for i = 1, select("#", ...) do
                local v = select(i, ...)
                local ok, s = pcall(function()
                    local obj = (type(v) ~= "string" and v.get) and v:get() or v
                    local n = obj.GetFullName and obj:GetFullName() or obj
                    if type(n) ~= "string" and n.ToString then n = n:ToString() end
                    return tostring(n)
                end)
                if ok and s then parts[#parts + 1] = s end
            end
            Log.discover("map loaded: %s", table.concat(parts, " | "))
        end)
    end)
    Log.info("main: map-load logging %s", ok_hook and "active" or "unavailable")

    if State.load() and State.run.status == State.STATUS.ACTIVE then
        Log.info("main: resumable run found (seed %s, floor %d)",
            State.run.seed, State.run.current_floor)
        -- If we were mid-mission when the game closed, drop back to briefing so
        -- the floor is relaunched cleanly.
        if State.run.floor_status == State.FLOOR.IN_MISSION then
            State.run.floor_status = State.FLOOR.BRIEFING
            State.save()
        end
    end

    Log.info("main: ready — %s opens the roguelike panel", Config.keys.toggle_overlay)
end

-- Build version needs game objects, which may not exist at script load.
-- Poll briefly until readable, then finish init once.
local function deferred_init()
    if init_done then return true end
    local known, build = Gameapi.is_known_build()
    if build == "unreadable" or build == nil then
        return false -- retry
    end
    init_done = true
    finish_init(known, build)
    return true
end

-- World-transition watcher, polled once per second. Reacts to menu <-> mission
-- changes: closes the submenu so no mod row is left focusable over gameplay,
-- and kicks the one-off in-mission skull discovery.
local skull_dump_done = false
function watch_world()
    local world = Gameapi.current_world_name()
    if not world or world == last_world then return end
    local was, now = last_world, world
    last_world = world
    Log.discover("main: world changed -> %s", world)
    pcall(Menuinject.close)

    local entering_mission = world:find("/Solo/", 1, true) ~= nil
    if entering_mission then
        mission_seen_since_launch = true
        -- The options-struct TSet does not carry the skulls (confirmed
        -- on-device), so force them onto the live mission a few seconds after
        -- the world is up, once the game state exists.
        if State.run and State.run.floor_status == State.FLOOR.IN_MISSION then
            local wanted = Gameapi.skull_enum_values(State.active_skulls())
            if wanted then
                pcall(function()
                    LoopAsync(5000, function()
                        pcall(Gameapi.apply_skulls_in_mission, wanted)
                        return true
                    end)
                end)
            end
        end
    end
    if entering_mission and not skull_dump_done then
        -- Let the mission settle, then dump the skull component once.
        skull_dump_done = true
        pcall(function()
            LoopAsync(20000, function()
                pcall(Gameapi.dump_skull_objects)
                return true
            end)
        end)
    end
    -- Leaving a mission for the menus: the floor is NOT auto-completed here.
    -- Quitting to the menu looks identical to finishing, and no reliable
    -- mission-complete event has been found yet, so completion stays manual.
    if was and was:find("/Solo/", 1, true) and not entering_mission then
        Log.info("main: returned from mission to %s (floor completion is still "
            .. "confirmed manually)", world)
    end
end

register_keybinds()

-- LoopAsync(interval_ms, fn): fn returning true stops the loop.
local tick = 0
local ok_loop = pcall(function()
    LoopAsync(1000, function()
        tick = tick + 1
        if not init_done then
            if deferred_init() then return false end
            if tick > 60 then
                Log.error("main: build version unreadable after 60s — staying disabled "
                    .. "(is the HCE UE4SS fork installed? see README)")
                init_done = true
                return true
            end
            return false
        end
        -- Render loop for the overlay (text backend prints only on change).
        if enabled then
            pcall(Ui.render, Gameapi.status())
            -- Mirror the run state into native rows inside the main menu, so
            -- the mode is visible in the game window itself.
            pcall(function() Menuinject.set_status_lines(Ui.compact_lines()) end)
            pcall(watch_world)
        end
        return false
    end)
end)
if not ok_loop then
    Log.error("main: LoopAsync unavailable — falling back to immediate init")
    deferred_init()
end

Log.info("main: script loaded; waiting for engine objects")
