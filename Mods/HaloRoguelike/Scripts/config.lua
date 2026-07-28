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
