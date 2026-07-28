-- const.lua — static game data used by the run generator and UI.
--
-- IMPORTANT: `internal_id` values below are *candidates* until confirmed by a
-- UObject dump (docs/DISCOVERY.md). Anything with verified=false is display
-- data plus a best-guess identifier; gameapi.lua resolves the real handles at
-- runtime and logs what it finds. Update this file from UE4SS.log after the
-- first discovery pass.

local Const = {}

-- Build strings this mod is known to work against. Anything else refuses to
-- load (see config.allow_unknown_build) rather than crash on stale offsets.
-- GetBuildVersion reports the string WITHOUT the "5.5.4-" engine prefix seen
-- in the full build string (confirmed on-device 2026-07-28); both forms are
-- listed so either source matches.
Const.KNOWN_BUILDS = {
    ["2026.06.26.1097863.1-Rel-i343-Meteorite-2606-CU2"] = true,
    ["5.5.4-2026.06.26.1097863.1-Rel-i343-Meteorite-2606-CU2"] = true,
}

Const.RALLY_POINTS = { "Alpha", "Bravo", "Charlie", "Delta" }

-- 13 campaign missions: 10 original CE + 3 prequel/bonus.
-- rally lists are conservative (Alpha/Bravo/Charlie everywhere) until the
-- insertion-point tables are dumped; missions with a confirmed Delta should
-- get it added here.
Const.MISSIONS = {
    { id = "pillar_of_autumn",  name = "The Pillar of Autumn",       rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "halo",              name = "Halo",                        rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "truth_and_rec",     name = "Truth and Reconciliation",    rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "silent_cartographer", name = "The Silent Cartographer",   rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "assault_ctrl_room", name = "Assault on the Control Room", rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "guilty_spark",      name = "343 Guilty Spark",            rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "library",           name = "The Library",                 rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "two_betrayals",     name = "Two Betrayals",               rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "keyes",             name = "Keyes",                       rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    { id = "maw",               name = "The Maw",                     rally = { "Alpha", "Bravo", "Charlie" }, verified = false },
    -- Prequel/bonus missions: ids unknown until discovery. Excluded from the
    -- pool unless config.include_bonus_missions is set AND they are verified.
    { id = "prequel_1", name = "Prequel Mission 1", rally = { "Alpha", "Bravo" }, verified = false, bonus = true },
    { id = "prequel_2", name = "Prequel Mission 2", rally = { "Alpha", "Bravo" }, verified = false, bonus = true },
    { id = "prequel_3", name = "Prequel Mission 3", rally = { "Alpha", "Bravo" }, verified = false, bonus = true },
}

Const.DIFFICULTIES = { "Easy", "Normal", "Heroic", "Legendary" }

-- Floor -> base difficulty. Floors 4-5 additionally apply the nerf preset
-- (presets.lua); floor 5 additionally guarantees a 2-skull roll.
Const.DIFFICULTY_LADDER = {
    [1] = { difficulty = "Normal",    nerf = false },
    [2] = { difficulty = "Heroic",    nerf = false },
    [3] = { difficulty = "Legendary", nerf = false },
    [4] = { difficulty = "Legendary", nerf = true  },
    [5] = { difficulty = "Legendary", nerf = true  },
}

-- Mandatory skulls, active for the entire run.
-- Adaptation / Reload / Armistice come free with Campaign Remix (§5 of the
-- brief); the mod itself only has to force Iron.
Const.MANDATORY_SKULLS = {
    { id = "iron",       name = "Iron",       desc = "Death restarts the rally point",        via = "mod"   },
    { id = "adaptation", name = "Adaptation", desc = "Randomises enemy factions",             via = "remix" },
    { id = "reload",     name = "Reload",     desc = "Randomises pre-placed weapons",         via = "remix" },
    { id = "armistice",  name = "Armistice",  desc = "Enemy factions never fight each other", via = "remix" },
}

-- Roll pool for the 1-2 extra skulls per floor. 42 skulls exist in total;
-- this pool is seeded with the classic CE skull set as candidates and MUST be
-- reconciled against the real skull enum from the UObject dump (§7.2).
-- Skulls in the mandatory set are never rolled.
Const.SKULL_POOL = {
    { id = "mythic",       name = "Mythic",              desc = "Enemies have double health",                 verified = false },
    { id = "boom",         name = "Boom",                desc = "Explosion radius doubled",                   verified = false },
    { id = "foreign",      name = "Foreign",             desc = "Cannot use Covenant weapons",                verified = false },
    { id = "famine",       name = "Famine",              desc = "Dropped weapons have half ammo",             verified = false },
    { id = "fog",          name = "Fog",                 desc = "Motion tracker disabled",                    verified = false },
    { id = "malfunction",  name = "Malfunction",         desc = "A random HUD element drops out on respawn",  verified = false },
    { id = "recession",    name = "Recession",           desc = "Every shot costs double ammo",               verified = false },
    { id = "black_eye",    name = "Black Eye",           desc = "Shields only recharge on melee hits",        verified = false },
    { id = "eye_patch",    name = "Eye Patch",           desc = "Auto-aim disabled",                          verified = false },
    { id = "pinata",       name = "Piñata",              desc = "Melee makes enemies drop grenades",          verified = false },
    { id = "grunt_funeral", name = "Grunt Funeral",      desc = "Grunts explode on death",                    verified = false },
    { id = "grunt_bday",   name = "Grunt Birthday Party", desc = "Headshot Grunts celebrate",                 verified = false },
    { id = "tough_luck",   name = "Tough Luck",          desc = "Enemies always dodge and never flee",        verified = false },
    { id = "catch",        name = "Catch",               desc = "Enemies throw far more grenades",            verified = false },
}

-- Visibility modifier, one per floor, not cumulative. Campaign Remix rolls
-- Spore/Nightvision automatically on deploy; "Default" means the mod must
-- suppress/ignore the roll if that turns out to be possible (§7.3).
Const.VISIBILITY_MODIFIERS = {
    { id = "default",    name = "Default" },
    { id = "spore",      name = "Spore Visibility" },
    { id = "nightvision", name = "Nightvision" },
}

Const.FLOORS_PER_RUN = 5

return Const
