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

-- Bumped whenever the skull pool, mission list or visibility list changes.
-- A saved run generated under an older version references ids that may no
-- longer exist (e.g. the pre-enum "grunt_bday"), so state.load discards it
-- rather than carrying phantom skulls into a launch.
Const.CONTENT_VERSION = 2

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

-- Skull ids below are the REAL EBlamGameSkulls member names, read from the
-- live enum on-device 2026-07-29 (/Script/BlamGlue.EBlamGameSkulls, 56
-- members). gameapi maps id -> enum value case-insensitively, so these must
-- keep matching the enum spelling.
--
-- Mandatory skulls, active for the entire run.
Const.MANDATORY_SKULLS = {
    { id = "Iron",       name = "Iron",       desc = "Death restarts the rally point", via = "mod"   },
    { id = "Reload",     name = "Reload",     desc = "Randomises pre-placed weapons",  via = "remix" },
    { id = "Adaptation", name = "Adaptation", desc = "Randomises enemy factions",      via = "remix" },
}

-- Roll pool for the extra skulls per floor: EVERY skull the game can activate,
-- serious or goofy. The only enum members held back are
--   * the three mandatory ones above (always on, never rolled),
--   * the three visibility modifiers (rolled separately, one per floor),
--   * CustomRed/CustomYellow/CustomBlue, which are the game's empty custom
--     skull slots rather than gameplay skulls,
--   * the None/Num/_MAX sentinels, which are not skulls at all.
-- That leaves 47 rollable skulls.
--
-- Descriptions are the classic Halo effects where the skull is a classic one.
-- Campaign Evolved adds skulls whose effect the reflection dump does not
-- describe; those say so rather than invent one — the game's own skull menu
-- has the real text.
Const.SKULL_POOL = {
    -- Classic "harder" skulls
    { id = "Mythic",            name = "Mythic",            desc = "Enemies have double health",                verified = true },
    { id = "BlackEye",          name = "Black Eye",         desc = "Shields only recharge on melee hits",       verified = true },
    { id = "ToughLuck",         name = "Tough Luck",        desc = "Enemies always dodge and never flee",       verified = true },
    { id = "Catch",             name = "Catch",             desc = "Enemies throw far more grenades",           verified = true },
    { id = "Fog",               name = "Fog",               desc = "Motion tracker disabled",                   verified = true },
    { id = "Famine",            name = "Famine",            desc = "Dropped weapons have half ammo",            verified = true },
    { id = "Thunderstorm",      name = "Thunderstorm",      desc = "Enemies are promoted to higher ranks",      verified = true },
    { id = "Tilt",              name = "Tilt",              desc = "Enemy resistances are far more punishing",  verified = true },
    { id = "Assassin",          name = "Assassin",          desc = "Enemies are permanently cloaked",           verified = true },
    { id = "Blind",             name = "Blind",             desc = "HUD and weapon are hidden",                 verified = true },
    { id = "Boom",              name = "Boom",              desc = "Explosion radius doubled",                  verified = true },
    { id = "EyePatch",          name = "Eye Patch",         desc = "Auto-aim disabled",                         verified = true },
    { id = "Foreign",           name = "Foreign",           desc = "Cannot use Covenant weapons",               verified = true },
    { id = "Malfunction",       name = "Malfunction",       desc = "A random HUD element drops out on respawn", verified = true },
    { id = "Recession",         name = "Recession",         desc = "Every shot costs double ammo",              verified = true },
    { id = "GruntFuneral",      name = "Grunt Funeral",     desc = "Grunts explode on death",                   verified = true },
    { id = "Jacked",            name = "Jacked",            desc = "Enemies hijack vehicles aggressively",      verified = true },
    { id = "Masterblaster",     name = "Masterblaster",     desc = "Enemies favour heavy weapons",              verified = true },
    { id = "SoAngry",           name = "So Angry",          desc = "Enemies are enraged from the start",        verified = true },
    { id = "Swarm",             name = "Swarm",             desc = "Far more enemies per encounter",            verified = true },
    { id = "ThatsJustWrong",    name = "That's Just Wrong", desc = "Enemies hear further and react faster",     verified = true },
    { id = "TheyComeBack",      name = "They Come Back",    desc = "Fallen combat forms reanimate",             verified = true },
    { id = "Armistice",         name = "Armistice",         desc = "Enemy factions never fight each other",     verified = true },
    -- Goofy / player-favouring skulls: in the pool by request, so a floor can
    -- roll a lucky break or a joke as easily as a beating.
    { id = "Cowbell",           name = "Cowbell",           desc = "Explosion force sends everything flying",   verified = true },
    { id = "GruntBirthdayParty", name = "Grunt Birthday Party", desc = "Headshot Grunts pop in confetti",       verified = true },
    { id = "IWHBYD",            name = "IWHBYD",            desc = "Rare combat dialogue becomes common",       verified = true },
    { id = "Bandana",           name = "Bandana",           desc = "Bottomless ammo and grenades",              verified = true },
    { id = "Envy",              name = "Envy",              desc = "Active camouflage while not firing",        verified = true },
    { id = "Pinata",            name = "Piñata",            desc = "Melee makes enemies drop grenades",         verified = true },
    { id = "Scarab",            name = "Scarab",            desc = "Your weapons fire Scarab beams",            verified = true },
    { id = "ThirdPerson",       name = "Third Person",      desc = "Play from a third-person camera",           verified = true },
    -- Real enum members whose effect is not documented in the reflection dump.
    { id = "Angry",             name = "Angry",             desc = "Effect not documented in the game data",    verified = true },
    { id = "BondedPair",        name = "Bonded Pair",       desc = "Effect not documented in the game data",    verified = true },
    { id = "Ghost",             name = "Ghost",             desc = "Effect not documented in the game data",    verified = true },
    -- Campaign Evolved additions: real enum members, effects not documented
    -- in the reflection dump. The game's own skull menu describes them.
    { id = "BootsOffTheGround", name = "Boots Off The Ground", desc = "Campaign Evolved skull",                 verified = true },
    { id = "Riskrun",           name = "Riskrun",           desc = "Campaign Evolved skull",                    verified = true },
    { id = "Pop",               name = "Pop",               desc = "Campaign Evolved skull",                    verified = true },
    { id = "EnduranceSpec",     name = "Endurance Spec",    desc = "Campaign Evolved skull",                    verified = true },
    { id = "GiveAndTake",       name = "Give And Take",     desc = "Campaign Evolved skull",                    verified = true },
    { id = "StowAndGrow",       name = "Stow And Grow",     desc = "Campaign Evolved skull",                    verified = true },
    { id = "HipFire",           name = "Hip Fire",          desc = "Campaign Evolved skull",                    verified = true },
    { id = "Temperamental",     name = "Temperamental",     desc = "Campaign Evolved skull",                    verified = true },
    { id = "FloorIsLava",       name = "Floor Is Lava",     desc = "Campaign Evolved skull",                    verified = true },
    { id = "Magnified",         name = "Magnified",         desc = "Campaign Evolved skull",                    verified = true },
    { id = "JohnnyAmmoTree",    name = "Johnny Ammo Tree",  desc = "Campaign Evolved skull",                    verified = true },
    { id = "Leadhead",          name = "Leadhead",          desc = "Campaign Evolved skull",                    verified = true },
    { id = "Efficient",         name = "Efficient",         desc = "Campaign Evolved skull",                    verified = true },
}

-- Visibility modifier, one per floor, not cumulative. These are real skulls in
-- EBlamGameSkulls (SporeVisibility=39, NightVision=40, LightsOut=41, confirmed
-- on-device), kept out of SKULL_POOL so exactly one is rolled per floor.
-- "default" carries no skull: the floor runs with normal visibility.
Const.VISIBILITY_MODIFIERS = {
    { id = "default",         name = "Default",          skull = nil },
    { id = "SporeVisibility", name = "Spore Visibility", skull = "SporeVisibility" },
    { id = "NightVision",     name = "Nightvision",      skull = "NightVision" },
    { id = "LightsOut",       name = "Lights Out",       skull = "LightsOut" },
}

Const.FLOORS_PER_RUN = 5

return Const
