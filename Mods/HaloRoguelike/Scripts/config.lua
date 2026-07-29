-- config.lua — user-tweakable settings. Everything else lives in const.lua.

local Config = {}

-- Hardcore rule: run ends in a loss when total deaths reach this cap.
-- Set to 0 to disable the cap (Iron still restarts the rally point).
Config.death_cap = 8

-- Refuse to initialise on a build string not listed in const.KNOWN_BUILDS.
-- Flip to true at your own risk after a game update, once you've re-verified
-- the UE4SS signatures still resolve.
Config.allow_unknown_build = false

-- Include the 3 prequel/bonus missions in the mission pool. Leave false until
-- their internal ids are confirmed via discovery (const.lua).
Config.include_bonus_missions = false

-- Extra skulls rolled per floor: floors 1-4 roll int in [min,max]; floor 5
-- always rolls `floor5` skulls on top of everything accumulated.
Config.skull_roll = { min = 1, max = 2, floor5 = 2 }

-- Log which skull gameplay tags the running mission actually has. Read-only
-- and safe, but it is reflection on a live component, so it can be switched
-- off. Note that gameplay tags can never be BUILT from Lua on this build —
-- doing so crashes the game — so this only ever reads. See docs/DISCOVERY.md.
Config.report_skull_tags = true

-- Try to switch the run's skulls on by calling the game's own skull UFunctions
-- (see gameapi.dump_skull_api). Only functions taking scalar arguments are
-- called and the console is the fallback, so nothing here constructs a struct
-- — this is the safe half of skull setting.
Config.set_skulls = true

-- Activate a roguelike menu row by RESTING on it, instead of pressing it.
--
-- Off, because resting on a row and having it fire is not what a menu does.
-- Rows now join the game's own button container, so A / Enter / a mouse click
-- activates them the way every other menu entry works.
--
-- Only turn this back on if pressing a roguelike row does nothing at all on
-- your build — it is the fallback that needs no working press at all.
Config.activate_on_focus_dwell = false

-- Seconds of resting on a row before it fires, when the above is on.
Config.focus_dwell_seconds = 1.0

-- Keybinds (UE4SS Key enum names; see main.lua).
Config.keys = {
    toggle_overlay   = "F6",  -- open/close the roguelike panel
    primary_action   = "F5",  -- confirm/new run/start floor (also a UI button)
    discovery_dump   = "F7",  -- write a UObject discovery report to UE4SS.log
    exit_mode        = "F8",  -- abandon run + restore save + clear modifiers
    emergency_restore = "F9", -- restore the campaign save backup NOW
}

-- Where run state and save backups are kept, relative to %LOCALAPPDATA%.
-- Resolved at runtime in saveguard.lua / state.lua.
Config.state_dir_name = "HaloRoguelike"

-- How many timestamped save backups to keep before pruning the oldest.
Config.max_save_backups = 5

-- Print the full floor plan to UE4SS.log at run start (spoils the fog of war
-- in the log file — handy for development, off for real runs).
Config.log_spoilers = false

return Config
