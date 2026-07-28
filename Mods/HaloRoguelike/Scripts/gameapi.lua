-- gameapi.lua — the only module that touches game UObjects.
--
-- Everything the brief lists as an unknown (§7) is isolated here behind an
-- adapter: candidate class/function names are tried in order, every attempt
-- is logged, and unresolved capabilities degrade to a loud log message plus a
-- UI notice instead of a crash. After the first instrumented playtest,
-- UE4SS.log tells you exactly which candidates hit, and the CANDIDATES table
-- below gets updated with the real names.
--
-- Resolution status is queryable (Gameapi.status()) so the UI can show which
-- capabilities are live.

local Log     = require("log")
local Const   = require("const")
local Presets = require("presets")

local Gameapi = {}

-- ------------------------------------------------------------ candidates

-- Candidate names for each unknown. Order matters: first hit wins.
-- Update these from the UObject dump (docs/DISCOVERY.md).
local CANDIDATES = {
    -- §7.6 the live user-settings object carrying ModifierPreset/PlayerTraits.
    -- CONFIRMED on-device 2026-07-28: instances are MeteoriteGameUserSettings
    -- (/Engine/Transient.MeteoriteGameUserSettings_*), found via the
    -- HaloUserSettings probe — Meteorite* is the concrete subclass.
    user_settings_class = {
        "MeteoriteGameUserSettings",
        "HaloUserSettings",
        "HaloGlobalGameUserSettings",
        "HaloGameUserSettings",
    },
    -- §7.1 the mission launch call (mission + insertion point + difficulty +
    -- skulls). These are guesses to seed the search; the discovery dump plus
    -- the HCEDebugMenu mod (Nexus 14) are the real sources.
    mission_launcher_class = {
        "CampaignMissionLauncher",
        "MissionDeployManager",
        "CampaignManager",
        "HaloCampaignSubsystem",
        "BlamCampaignSubsystem",
    },
    mission_launch_fn = {
        "DeployMission",
        "LaunchMission",
        "StartMission",
        "StartCampaignMission",
        "DeployRemixMission",
    },
    -- §7.4 mission-complete event hook paths.
    mission_complete_hooks = {
        "/Script/Meteorite.CampaignMissionState:OnMissionComplete",
        "/Script/Meteorite.HaloCampaignSubsystem:MissionCompleted",
        "/Script/Meteorite.BlamGameMode:HandleMissionComplete",
    },
    -- §7.5 player death hook paths for the death counter.
    player_death_hooks = {
        "/Script/Meteorite.BlamPlayerState:OnPlayerDeath",
        "/Script/Meteorite.HaloPlayerCharacter:OnDeath",
        "/Script/Engine.PlayerController:ClientRestart", -- rally-point reload fallback
    },
}

-- Resolved handles; nil until resolve() finds them.
local R = {
    user_settings      = nil,   -- live UObject
    mission_launcher   = nil,   -- live UObject
    mission_launch_fn  = nil,   -- string function name on the launcher
    mission_complete_hook = nil, -- registered hook path
    player_death_hook  = nil,   -- registered hook path
    build_version      = nil,
}

-- ------------------------------------------------------------ helpers

local function try(label, fn, ...)
    local ok, a, b = pcall(fn, ...)
    if not ok then
        Log.discover("%s: pcall failed: %s", label, tostring(a))
        return nil
    end
    return a, b
end

-- FString/FName-safe stringification: UE4SS string-likes need :ToString(),
-- plain tostring() yields "FString: 0x...".
local function fstr(v)
    if type(v) == "string" then return v end
    local ok, s = pcall(function() return v:ToString() end)
    if ok and type(s) == "string" then return s end
    return tostring(v)
end

local function full_name(obj)
    local ok, n = pcall(function() return obj:GetFullName() end)
    if not ok then return "?" end
    return fstr(n)
end

local function find_first(short_class)
    local obj = try("FindFirstOf(" .. short_class .. ")", FindFirstOf, short_class)
    if obj and obj:IsValid() then return obj end
    return nil
end

-- ------------------------------------------------------------ build check

-- Best-effort build string. UKismetSystemLibrary::GetBuildVersion returns
-- FApp::GetBuildVersion, which for this game is the full 343 build string.
function Gameapi.get_build_version()
    if R.build_version then return R.build_version end
    local ksl = try("StaticFindObject(KismetSystemLibrary)", StaticFindObject,
        "/Script/Engine.Default__KismetSystemLibrary")
    if ksl and ksl:IsValid() then
        local v = try("GetBuildVersion", function() return ksl:GetBuildVersion() end)
        if v then
            -- UE4SS returns FString userdata; tostring() would yield the
            -- object address ("FString: 0x..."), not the text.
            local s
            if type(v) == "string" then
                s = v
            else
                s = try("FString:ToString", function() return v:ToString() end)
            end
            if s and not s:match("^FString:") then
                R.build_version = s
                Log.info("gameapi: build version = %s", R.build_version)
                return R.build_version
            end
            Log.warn("gameapi: build version FString could not be converted (%s)",
                tostring(v))
        end
    end
    Log.warn("gameapi: could not read build version")
    return nil
end

function Gameapi.is_known_build()
    local v = Gameapi.get_build_version()
    if not v then return false, "unreadable" end
    return Const.KNOWN_BUILDS[v] == true, v
end

-- ------------------------------------------------------------ resolve

function Gameapi.resolve()
    Log.info("gameapi: resolving game objects...")

    if not R.user_settings then
        for _, name in ipairs(CANDIDATES.user_settings_class) do
            local obj = find_first(name)
            if obj then
                R.user_settings = obj
                Log.discover("user_settings RESOLVED via FindFirstOf(%q): %s",
                    name, full_name(obj))
                break
            else
                Log.discover("user_settings: no instance of %q", name)
            end
        end
    end

    if not R.mission_launcher then
        for _, cls in ipairs(CANDIDATES.mission_launcher_class) do
            local obj = find_first(cls)
            if obj then
                Log.discover("mission_launcher candidate instance: %s",
                    full_name(obj))
                for _, fn in ipairs(CANDIDATES.mission_launch_fn) do
                    local has = try("probe " .. cls .. ":" .. fn, function()
                        return obj[fn] ~= nil
                    end)
                    if has then
                        R.mission_launcher, R.mission_launch_fn = obj, fn
                        Log.discover("mission launch RESOLVED: %s:%s", cls, fn)
                        break
                    end
                end
                if R.mission_launcher then break end
            end
        end
        if not R.mission_launcher then
            Log.discover("mission launch UNRESOLVED — run the F7 discovery dump "
                .. "and see docs/DISCOVERY.md")
        end
    end

    return Gameapi.status()
end

function Gameapi.status()
    return {
        build_version      = R.build_version,
        user_settings      = R.user_settings ~= nil,
        mission_launch     = R.mission_launcher ~= nil,
        mission_complete_hook = R.mission_complete_hook ~= nil,
        player_death_hook  = R.player_death_hook ~= nil,
    }
end

-- ------------------------------------------------------------ hooks

local function register_first_hook(label, paths, wrapper)
    for _, path in ipairs(paths) do
        local ok, err = pcall(RegisterHook, path, wrapper)
        if ok then
            Log.discover("%s hook REGISTERED at %s", label, path)
            return path
        else
            Log.discover("%s hook: %s not available (%s)", label, path, tostring(err))
        end
    end
    Log.warn("gameapi: no %s hook could be registered — floor advancement "
        .. "will need the manual fallback (overlay button)", label)
    return nil
end

-- cb() fires once per mission completion.
function Gameapi.on_mission_complete(cb)
    R.mission_complete_hook = register_first_hook("mission-complete",
        CANDIDATES.mission_complete_hooks, function()
            ExecuteInGameThread(function()
                Log.info("gameapi: mission-complete event")
                cb()
            end)
        end)
    return R.mission_complete_hook ~= nil
end

-- cb() fires once per player death. Debounced: ClientRestart also fires on
-- initial spawn, so the first event after a launch is swallowed by main.lua.
function Gameapi.on_player_death(cb)
    R.player_death_hook = register_first_hook("player-death",
        CANDIDATES.player_death_hooks, function()
            ExecuteInGameThread(function()
                Log.info("gameapi: player-death event")
                cb()
            end)
        end)
    return R.player_death_hook ~= nil
end

-- ------------------------------------------------------------ modifiers

local function set_props(obj, tbl, prefix)
    for k, v in pairs(tbl) do
        local ok, err = pcall(function() obj[k] = v end)
        Log.info("gameapi: set %s%s = %s -> %s", prefix or "", k, tostring(v),
            ok and "ok" or ("FAILED: " .. tostring(err)))
    end
end

-- Apply the Legendary+ nerf preset live (floors 4-5). Never writes the ini.
function Gameapi.apply_nerf_preset()
    if not R.user_settings then Gameapi.resolve() end
    local us = R.user_settings
    if not us then
        Log.error("gameapi: HaloUserSettings not resolved; cannot apply nerf preset")
        return false
    end
    local slot = "PlayerTraits" .. Presets.SLOT
    local ok = pcall(function()
        local traits = us[slot]
        for group, fields in pairs(Presets.NERF) do
            local g = traits[group]
            set_props(g, fields, slot .. "." .. group .. ".")
        end
        us.ModifierPreset = Presets.MODIFIER_PRESET_VALUE
    end)
    if not ok then
        -- Struct layout may differ; fall back to flat property attempts and log.
        Log.warn("gameapi: struct-path write failed; property layout needs discovery")
        return false
    end
    -- Signature confirmed by SIG dump: SetDifficultyModifiersEnabled(bEnabled).
    local statics = try("find MeteoriteUIStatics", StaticFindObject,
        "/Script/Meteorite.Default__MeteoriteUIStatics")
    if statics and statics:IsValid() then
        local okt = pcall(function() statics:SetDifficultyModifiersEnabled(true) end)
        Log.info("gameapi: SetDifficultyModifiersEnabled(true) -> %s", tostring(okt))
    end
    Log.info("gameapi: nerf preset applied (ModifierPreset=%s)",
        Presets.MODIFIER_PRESET_VALUE)
    return true
end

-- Restore ModifierPreset=None (run exit / floors 1-3). Re-enables achievements.
function Gameapi.clear_modifiers()
    if not R.user_settings then Gameapi.resolve() end
    local us = R.user_settings
    if not us then return false end
    local ok = pcall(function() us.ModifierPreset = "None" end)
    Log.info("gameapi: ModifierPreset=None -> %s", ok and "ok" or "FAILED")
    return ok
end

-- ------------------------------------------------------------ launch

-- Launch a floor: mission + rally point + difficulty + skull set.
-- CONFIRMED by the F7 UFunction scan (2026-07-28): the game's own menu flow is
--   BPFL_CampaignMenuHelpers_C: SelectedDifficulty / SelectedInsertionPoint /
--     SetClientLobbySkulls / GetRemixSkullsSet ...
--   WBP_MainMenu_C:LaunchCampaignMap
-- Signatures are still unknown, so every call is attempted through pcall with
-- several arg shapes and the engine's own error text is logged verbatim —
-- those errors state the expected parameter count/types, which is exactly the
-- data needed to finalize the shapes.
local BPFL_PATH = "/Game/UI/Frontend/CampaignMenu/Data/BPFL_CampaignMenuHelpers."
    .. "BPFL_CampaignMenuHelpers_C"

-- Read-only signature reflection: logs each UFunction's parameter names and
-- types. No game code executes — this replaced the blind-call probing that
-- crashed the game (param-count errors: LaunchCampaignMap=2, Selected*=4).
local SIG_TARGETS = {
    "/Game/UI/Frontend/MainMenu/Widgets/WBP_MainMenu.WBP_MainMenu_C:LaunchCampaignMap",
    BPFL_PATH .. ":SelectedDifficulty",
    BPFL_PATH .. ":SelectedInsertionPoint",
    BPFL_PATH .. ":SelectedSkulls",
    BPFL_PATH .. ":LaunchCampaign",
    BPFL_PATH .. ":SetClientLobbyInsertionPoint",
    BPFL_PATH .. ":SetClientLobbySkulls",
    BPFL_PATH .. ":SetClientLobbyDifficulty",
    BPFL_PATH .. ":GetRemixSkullsSet",
    BPFL_PATH .. ":GetAllSkullsSet",
    "/Script/Meteorite.MeteoriteUIStatics:ResumeRemixSave",
    "/Script/Meteorite.MeteoriteUIStatics:SetDifficultyModifiersEnabled",
    "/Script/Meteorite.MeteoriteUIStatics:IsInsertionPointLocked",
    "/Game/UI/Frontend/CampaignMenu/Data/RandomSkulls/BPFL_RandomSkullsHelpers."
        .. "BPFL_RandomSkullsHelpers_C:GetRandomizedSkulls",
}

function Gameapi.dump_signatures()
    for _, path in ipairs(SIG_TARGETS) do
        local fn = try("find " .. path, StaticFindObject, path)
        if fn and fn:IsValid() then
            local parts = {}
            local ok = pcall(function()
                fn:ForEachProperty(function(prop)
                    local pname = fstr(prop:GetFName())
                    local ptype = "?"
                    pcall(function()
                        ptype = fstr(prop:GetClass():GetFName())
                    end)
                    parts[#parts + 1] = string.format("%s:%s", pname, ptype)
                end)
            end)
            if ok then
                Log.discover("SIG %s(%s)", path:match("[^:]+$"),
                    table.concat(parts, ", "))
            else
                Log.discover("SIG %s: ForEachProperty unavailable", path)
            end
        else
            Log.discover("SIG %s: function object not found", path)
        end
    end
end

-- Classic Halo scenario ids, confirmed plausible by the menu's own
-- "PlayButton_B30New" (b30 = The Silent Cartographer).
local SCENARIOS = {
    pillar_of_autumn = "a10", halo = "a30", truth_and_rec = "a50",
    silent_cartographer = "b30", assault_ctrl_room = "b40",
    guilty_spark = "c10", library = "c20", two_betrayals = "c40",
    keyes = "d20", maw = "d40",
}

-- Locate the CampaignData asset LaunchCampaignMap wants. Candidates first,
-- then a substring scan over GUObjectArray (fast; ~50k objects).
local cached_campaign_data = nil
function Gameapi.find_campaign_data()
    if cached_campaign_data
        and pcall(function() return cached_campaign_data:IsValid() end)
        and cached_campaign_data:IsValid() then
        return cached_campaign_data
    end
    for _, cls in ipairs({ "CampaignData", "MeteoriteCampaignData",
        "BlamCampaignData", "CampaignUIInfo" }) do
        local obj = find_first(cls)
        if obj then
            Log.discover("CD resolved via FindFirstOf(%q): %s", cls, full_name(obj))
            cached_campaign_data = obj
            return obj
        end
    end
    local found = nil
    pcall(function()
        ForEachUObject(function(obj)
            if found then return end
            pcall(function()
                local name = fstr(obj:GetFullName())
                if name:find("CampaignData", 1, true)
                    and not name:find("Default__", 1, true)
                    and not name:find("^Class ")
                    and not name:find("^Function ") then
                    Log.discover("CD candidate: %s", name)
                    found = obj
                end
            end)
        end)
    end)
    cached_campaign_data = found
    return found
end

function Gameapi.launch_floor(floor, active_skulls)
    Log.info("gameapi: launch request — mission=%s rally=%s difficulty=%s skulls=[%s]",
        floor.mission_id, floor.rally, floor.difficulty,
        table.concat(active_skulls, ","))

    local screen = find_first("WBP_MainMenu_C")
    if not screen then
        return false, "main menu widget not found (launch only works from the menu)"
    end
    local scen = SCENARIOS[floor.mission_id]
    if not scen then
        return false, "no scenario id known for mission " .. tostring(floor.mission_id)
    end

    local diff_index = ({ Easy = 0, Normal = 1, Heroic = 2, Legendary = 3 })
        [floor.difficulty] or 1
    local rally_index = ({ Alpha = 0, Bravo = 1, Charlie = 2, Delta = 3 })
        [floor.rally] or 0

    -- Lobby setup via the game's own helpers (signatures confirmed by SIG dump:
    -- SetClientLobbyDifficulty(Difficulty, WorldContext)).
    local bpfl = try("find BPFL_CampaignMenuHelpers", StaticFindObject,
        BPFL_PATH:gsub("BPFL_CampaignMenuHelpers_C$", "Default__BPFL_CampaignMenuHelpers_C"))
    if bpfl and bpfl:IsValid() then
        local okd, errd = pcall(function()
            bpfl:SetClientLobbyDifficulty(diff_index, screen)
        end)
        Log.discover("launch: SetClientLobbyDifficulty(%d) -> %s",
            diff_index, okd and "OK" or tostring(errd))
        local has_ip = try("probe SetClientLobbyInsertionPoint", function()
            return bpfl.SetClientLobbyInsertionPoint ~= nil
        end)
        if has_ip then
            local oki, erri = pcall(function()
                bpfl:SetClientLobbyInsertionPoint(rally_index, screen)
            end)
            Log.discover("launch: SetClientLobbyInsertionPoint(%d) -> %s",
                rally_index, oki and "OK" or tostring(erri))
        end
    end

    local cd = Gameapi.find_campaign_data()
    if not cd then
        Gameapi.dump_signatures()
        return false, "CampaignData asset not found — see CD lines in UE4SS.log"
    end

    -- The launch itself: LaunchCampaignMap(CampaignData, StartingScenarioName).
    local ok, err = pcall(function()
        screen:LaunchCampaignMap(cd, FName(scen))
    end)
    Log.discover("launch: LaunchCampaignMap(%s, %q) -> %s",
        full_name(cd), scen, ok and "OK" or tostring(err))
    if ok then return true end
    return false, tostring(err)
end

-- Continue support discovered in the same scan.
function Gameapi.resume_remix_save()
    local statics = try("find MeteoriteUIStatics", StaticFindObject,
        "/Script/Meteorite.Default__MeteoriteUIStatics")
    if not (statics and statics:IsValid()) then return false end
    return attempt_calls("ResumeRemixSave", {
        { desc = "()", fn = function() statics:ResumeRemixSave() end },
        { desc = "(0)", fn = function() statics:ResumeRemixSave(0) end },
    })
end

-- ------------------------------------------------------------ discovery

-- F7: log a discovery report. Complements UE4SS's own object dumper (use the
-- UE4SS GUI "Dump Objects" for the full UObject dump); this report focuses on
-- the specific classes this mod needs.
function Gameapi.discovery_dump()
    Log.discover("==== discovery dump start ====")
    Gameapi.get_build_version()

    local probes = {
        "MeteoriteGameUserSettings",
        "HaloUserSettings", "HaloGlobalGameUserSettings", "GameUserSettings",
        "CampaignMissionLauncher", "MissionDeployManager", "CampaignManager",
        "HaloCampaignSubsystem", "BlamCampaignSubsystem", "CampaignSaveGame",
        "BlamAchievementDefinition", "DebugMenuSettings",
    }
    for _, cls in ipairs(probes) do
        local all = try("FindAllOf(" .. cls .. ")", FindAllOf, cls)
        if all and #all > 0 then
            Log.discover("%s: %d instance(s)", cls, #all)
            for i, obj in ipairs(all) do
                if i > 5 then Log.discover("  ... (%d more)", #all - 5) break end
                Log.discover("  %s", full_name(obj))
            end
        else
            Log.discover("%s: none loaded", cls)
        end
    end

    -- UI widget scan: read every TextBlock's text and log widgets that live
    -- under menu-ish outers. The TextBlock showing "CAMPAIGN REMIX" pinpoints
    -- the exact entry-button widget class menuinject needs to clone.
    local tbs = try("FindAllOf(TextBlock)", FindAllOf, "TextBlock")
    if tbs then
        Log.discover("TextBlock scan: %d instances (menu-related shown)", #tbs)
        local shown = 0
        for _, tb in ipairs(tbs) do
            if shown >= 80 then Log.discover("  ... (truncated at 80)") break end
            local name = full_name(tb)
            if name:lower():find("menu") or name:lower():find("frontend")
                or name:lower():find("uilayout") then
                local text = try("TextBlock:GetText", function()
                    return fstr(tb:GetText())
                end)
                Log.discover("  text=%q  at %s", tostring(text), name)
                shown = shown + 1
            end
        end
    else
        Log.discover("TextBlock scan: FindAllOf unavailable")
    end

    -- UFunction scan: walk every UObject, keep the UFunctions whose names
    -- touch this mod's unknowns. One press answers the menu-button click
    -- handler AND is the best shot at the mission-launch call. The walk can
    -- hitch the game for a few seconds — expected, it's a manual F7 action.
    local func_class = try("find Function class", StaticFindObject,
        "/Script/CoreUObject.Function")
    if func_class and func_class:IsValid() and type(ForEachUObject) == "function" then
        Log.discover("UFunction scan: walking all UObjects (game may hitch)...")
        local fc_addr = func_class:GetAddress()
        local pats = { "StandaloneButton", "MainMenu", "Skull", "Insertion",
            "Remix", "Deploy", "StartMission", "LaunchMission", "StartCampaign",
            "RallyPoint", "Difficulty", "ModifierPreset",
            "Cinematic", "Cutscene", "SkipCinematic", "LaunchCampaign" }
        local total, funcs, matched = 0, 0, {}
        local ok_scan = pcall(function()
            ForEachUObject(function(obj)
                total = total + 1
                pcall(function()
                    if obj:GetClass():GetAddress() == fc_addr then
                        funcs = funcs + 1
                        local name = fstr(obj:GetFullName())
                        for _, p in ipairs(pats) do
                            if name:find(p, 1, true) then
                                if #matched < 300 then matched[#matched + 1] = name end
                                break
                            end
                        end
                    end
                end)
            end)
        end)
        Log.discover("UFunction scan: %d objects, %d functions, %d matches (ok=%s)",
            total, funcs, #matched, tostring(ok_scan))
        for _, n in ipairs(matched) do
            Log.discover("  FN %s", n)
        end
    else
        Log.discover("UFunction scan unavailable (no ForEachUObject in this UE4SS)")
    end

    -- Where do saves actually live? List the Saved dir so saveguard can be
    -- pointed at the right subfolder.
    local Paths = require("paths")
    local saved = Paths.saved_root()
    if saved then
        local dirs = Paths.list_dirs(saved)
        Log.discover("Saved/ subdirectories (%d):", #dirs)
        for _, d in ipairs(dirs) do
            Log.discover("  Saved\\%s", d)
        end
    end

    Log.discover("Next: deploy a Campaign Remix mission manually — map loads are "
        .. "logged, which captures the real mission level names")
    Log.discover("==== discovery dump end ====")
end

return Gameapi
