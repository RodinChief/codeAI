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

    return Gameapi.status()
end

function Gameapi.status()
    return {
        build_version      = R.build_version,
        user_settings      = R.user_settings ~= nil,
        -- Launch path CONFIRMED on-device 2026-07-28: WBP_MainMenu_C:
        -- LaunchCampaignMap(CampaignData, "b30") loaded the B30 mission map.
        mission_launch     = true,
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

-- Classic Halo scenario ids, CONFIRMED on-device 2026-07-28: launching floor 1
-- (silent_cartographer -> "b30") loaded /Game/Levels/Halo1/Solo/B30/B30.B30.
local SCENARIOS = {
    pillar_of_autumn = "a10", halo = "a30", truth_and_rec = "a50",
    silent_cartographer = "b30", assault_ctrl_room = "b40",
    guilty_spark = "c10", library = "c20", two_betrayals = "c40",
    keyes = "d20", maw = "d40",
}

-- One bounded GUObjectArray walk collecting objects whose full name contains
-- any of the substrings (classes/functions excluded). Walks are ~1s each, so
-- batch every lookup a launch needs into a single call.
local function scan_multi(substrs, cap_each)
    cap_each = cap_each or 20
    local out = {}
    for _, s in ipairs(substrs) do out[s] = {} end
    pcall(function()
        ForEachUObject(function(obj)
            pcall(function()
                local name = fstr(obj:GetFullName())
                if name:find("^Class ") or name:find("^Function ")
                    or name:find("^WidgetBlueprintGeneratedClass ") then
                    return
                end
                for _, s in ipairs(substrs) do
                    local t = out[s]
                    if #t < cap_each and name:find(s, 1, true) then
                        t[#t + 1] = { obj = obj, name = name }
                    end
                end
            end)
        end)
    end)
    return out
end

-- Log an object's property names/types (read-only reflection). The output is
-- the discovery data needed to switch from BPFL calls to direct writes.
local function dump_props(obj, label)
    local cls = try("GetClass", function() return obj:GetClass() end)
    if not cls then return end
    local parts = {}
    pcall(function()
        cls:ForEachProperty(function(prop)
            local pname = fstr(prop:GetFName())
            local ptype = "?"
            pcall(function() ptype = fstr(prop:GetClass():GetFName()) end)
            parts[#parts + 1] = pname .. ":" .. ptype
        end)
    end)
    Log.discover("PROPS %s: %s", label, table.concat(parts, ", "))
end

-- Set when a rally-capable CampaignMenu launch reported OK but no mission map
-- ever loaded (main.lua's watchdog): later launches skip that path and use
-- the known-good main-menu launch instead of failing the same way forever.
local campmenu_distrusted = false
function Gameapi.distrust_campmenu_launch()
    if not campmenu_distrusted then
        campmenu_distrusted = true
        Log.warn("gameapi: CampaignMenu launch path distrusted — future launches "
            .. "use the main-menu path (no rally point selection)")
    end
end

-- Locate the CampaignData asset LaunchCampaignMap wants. Candidates first,
-- then a substring scan over GUObjectArray (fast; ~50k objects).
local cached_campaign_data = nil
function Gameapi.find_campaign_data()
    if cached_campaign_data
        and pcall(function() return cached_campaign_data:IsValid() end)
        and cached_campaign_data:IsValid() then
        return cached_campaign_data
    end
    -- Known-good asset first: launching with DA_FirstPlayableCampaign loaded
    -- the B30 mission on-device (2026-07-28, 21:44 log).
    local known = try("find DA_FirstPlayableCampaign", StaticFindObject,
        "/Game/Blueprints/Campaign/DA_FirstPlayableCampaign.DA_FirstPlayableCampaign")
    if known and known:IsValid() then
        Log.discover("CD resolved via known asset path: %s", full_name(known))
        cached_campaign_data = known
        return known
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
    -- Scan fallback. Collect ALL candidates and prefer the non-test campaign:
    -- the scan order is not stable, and on-device it once returned
    -- DA_TestMapsCampaign — LaunchCampaignMap accepted it and silently did
    -- nothing ("b30" is not a scenario of that campaign).
    local cands = {}
    pcall(function()
        ForEachUObject(function(obj)
            if #cands >= 10 then return end
            pcall(function()
                local name = fstr(obj:GetFullName())
                if name:find("CampaignData", 1, true)
                    and not name:find("Default__", 1, true)
                    and not name:find("^Class ")
                    and not name:find("^Function ") then
                    Log.discover("CD candidate: %s", name)
                    cands[#cands + 1] = { obj = obj, name = name }
                end
            end)
        end)
    end)
    local pick = nil
    for _, c in ipairs(cands) do
        if not c.name:find("Test") and not c.name:find("test") then
            pick = c.obj
            break
        end
    end
    if not pick and cands[1] then pick = cands[1].obj end
    cached_campaign_data = pick
    return pick
end

-- The real campaign API, from the CXX header dump (discovery/dumps/cxx/
-- BlamEngine.hpp) — this is what WBP_MainMenu_C:LaunchCampaignMap wraps:
--
--   class UBlamCampaignFlowGameSubsystem : public UGameInstanceSubsystem
--     bool SetAndBeginCampaign(const UBlamCampaignDataAsset* Campaign,
--                              const FName StartingScenarioName,
--                              const FBlamScenarioGameOptions& Options);
--
--   struct FBlamScenarioGameOptions
--     bool                         bLoadFromCoreSave;
--     uint8                        SaveSlot;
--     FString                      SavedFilmName;
--     EBlamCampaignDifficultyLevel CampaignDifficultyLevel;
--     int32                        InsertionPoint;     <- the rally point
--     TSet<EBlamGameSkulls>        ActiveSkulls;       <- the skulls
--     bool                         bFriendlyFireEnabled;
--     bool                         bIsLASO;
--
-- One call sets mission + rally point + difficulty + skulls together, which
-- is why the previous lobby-helper approach never made the rally point stick:
-- LaunchCampaignMap builds this struct itself and overwrites the lobby values.
local function campaign_flow_subsystem()
    local ss = find_first("BlamCampaignFlowGameSubsystem")
    if ss then return ss end
    return find_first("UBlamCampaignFlowGameSubsystem")
end

-- Build the options struct as a Lua table. UE4SS marshals a table into a
-- struct parameter by field name; unknown/omitted fields keep their defaults.
local function scenario_game_options(diff_index, rally_index, skull_values)
    local opts = {
        bLoadFromCoreSave = false,
        SaveSlot = 0,
        CampaignDifficultyLevel = diff_index,
        InsertionPoint = rally_index,
        bFriendlyFireEnabled = false,
        bIsLASO = false,
    }
    -- ActiveSkulls is a TSet; only send it once real enum values are known
    -- (Gameapi.dump_enums resolves them). An empty/garbage set would clear
    -- the skulls Campaign Remix applies for us.
    if skull_values and #skull_values > 0 then
        opts.ActiveSkulls = skull_values
    end
    return opts
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

    local cd = Gameapi.find_campaign_data()

    -- PRIMARY PATH (from the reflection dump): drive the campaign subsystem
    -- directly, so the rally point and difficulty travel WITH the launch
    -- instead of being set on a lobby the launch then overwrites.
    local flow = campaign_flow_subsystem()
    if flow and cd then
        local skull_vals = Gameapi.skull_enum_values(active_skulls)
        Log.discover("launch: skull enum values = %s",
            skull_vals and ("[" .. table.concat(skull_vals, ",") .. "]")
            or "none yet (Campaign Remix keeps its own skulls)")

        -- With skulls first; if the TSet cannot be marshalled from a Lua
        -- table the same call is retried without them, so a skull problem
        -- can never cost the launch itself.
        local attempts = {}
        if skull_vals then
            attempts[#attempts + 1] = { desc = "with skulls",
                opts = scenario_game_options(diff_index, rally_index, skull_vals) }
        end
        attempts[#attempts + 1] = { desc = "no skulls",
            opts = scenario_game_options(diff_index, rally_index, nil) }

        for _, a in ipairs(attempts) do
            local ok, err = pcall(function()
                return flow:SetAndBeginCampaign(cd, FName(scen), a.opts)
            end)
            Log.discover("launch: SetAndBeginCampaign(%q, {diff=%d, rally=%d, %s}) -> %s",
                scen, diff_index, rally_index, a.desc,
                ok and "OK" or tostring(err))
            if ok then return true end
        end
        Log.discover("launch: subsystem path failed — falling back to the menu call")
    else
        Log.discover("launch: campaign flow subsystem %s, campaign data %s",
            flow and "found" or "MISSING", cd and "found" or "MISSING")
    end

    -- One object-array walk for the fallback paths: the MapInfo asset
    -- (rally-capable menu overload), the client lobby data and any live
    -- CampaignSetup (Selected* helpers).
    local scans = scan_multi({ "MapInfo", "ClientLobbyData", "CampaignSetup" }, 20)

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

        -- Skulls: pull the Campaign Remix skull set out of the game's own
        -- helper and push it into the lobby. SIGs: GetRemixSkullsSet(WC,
        -- RemixSkull:Set OUT) / SetClientLobbySkulls(Skulls:Set, WC). UE4SS
        -- out params take a Lua table that gets filled by the call.
        local out = {}
        local okg, errg = pcall(function()
            bpfl:GetRemixSkullsSet(screen, out)
        end)
        Log.discover("launch: GetRemixSkullsSet -> %s",
            okg and "OK" or tostring(errg))
        local skulls_set = out.RemixSkull or out[1]
        if okg then
            local keys = {}
            for k, v in pairs(out) do
                keys[#keys + 1] = tostring(k) .. "=" .. type(v)
                if skulls_set == nil then skulls_set = v end
            end
            Log.discover("launch: GetRemixSkullsSet out params: {%s}",
                table.concat(keys, ", "))
        end
        if skulls_set ~= nil then
            local oks, errs = pcall(function()
                bpfl:SetClientLobbySkulls(skulls_set, screen)
            end)
            Log.discover("launch: SetClientLobbySkulls(remix set) -> %s",
                oks and "OK" or tostring(errs))
        end

        -- Rally point + difficulty through the campaign-setup route, when a
        -- live CampaignSetup exists. SIGs: SelectedInsertionPoint(PC,
        -- CampaignSetup, InsertionPoint:Int, WC) / SelectedDifficulty(...).
        local pc = find_first("PlayerController")
        local setup = nil
        for _, e in ipairs(scans.CampaignSetup) do
            Log.discover("launch: CampaignSetup candidate: %s", e.name)
            if not setup and not e.name:find("Default__", 1, true) then
                setup = e.obj
            end
        end
        if pc and setup then
            local ok1, e1 = pcall(function()
                bpfl:SelectedDifficulty(pc, setup, diff_index, screen)
            end)
            Log.discover("launch: SelectedDifficulty(%d) -> %s", diff_index,
                ok1 and "OK" or tostring(e1))
            local ok2, e2 = pcall(function()
                bpfl:SelectedInsertionPoint(pc, setup, rally_index, screen)
            end)
            Log.discover("launch: SelectedInsertionPoint(%d) -> %s", rally_index,
                ok2 and "OK" or tostring(e2))
            -- Property dump AFTER the writes: shows whether the values stuck
            -- and which fields exist for direct writes (incl. a Skulls set).
            dump_props(setup, "CampaignSetup(after Selected*)")
        elseif not setup then
            Log.discover("launch: no live CampaignSetup object")
        end
    end

    -- ClientLobbyData discovery: SetClientLobby* writes into this object, so
    -- its property list is the recipe for direct rally/skull writes.
    for _, e in ipairs(scans.ClientLobbyData) do
        Log.discover("launch: ClientLobbyData: %s", e.name)
        if not e.name:find("Default__", 1, true) then
            dump_props(e.obj, e.name)
        end
    end

    -- Rally-capable launch: the campaign submenu's own overload, SIG-confirmed
    -- as LaunchCampaignMap(MapInfo:Object, InsertionPoint:Int). The widget
    -- does not exist while sitting on the main menu, so create an instance of
    -- its class on the fly — it is only used as the call target.
    local id_up = scen:upper()
    local mapinfo = nil
    for _, e in ipairs(scans.MapInfo) do
        Log.discover("launch: MapInfo candidate: %s", e.name)
        if not mapinfo and not e.name:find("Default__", 1, true)
            and (e.name:find(id_up, 1, true) or e.name:find(scen, 1, true)) then
            mapinfo = e
        end
    end
    local campmenu = (not campmenu_distrusted) and find_first("WBP_CampaignMenu_C")
        or nil
    if not campmenu and mapinfo and not campmenu_distrusted then
        local cls = try("find WBP_CampaignMenu class", StaticFindObject,
            "/Game/UI/Frontend/CampaignMenu/Widgets/WBP_CampaignMenu.WBP_CampaignMenu_C")
        local wbl = try("find WidgetBlueprintLibrary", StaticFindObject,
            "/Script/UMG.Default__WidgetBlueprintLibrary")
        if cls and cls:IsValid() and wbl and wbl:IsValid() then
            local owner = try("GetOwningPlayer", function()
                return screen:GetOwningPlayer()
            end)
            local okc, created = pcall(function()
                return wbl:Create(screen, cls, owner)
            end)
            if okc and created and created:IsValid() then
                campmenu = created
                Log.discover("launch: WBP_CampaignMenu created on the fly")
            else
                Log.discover("launch: could not create WBP_CampaignMenu (%s)",
                    tostring(created))
            end
        end
    end
    if campmenu and mapinfo then
        local okm, errm = pcall(function()
            campmenu:LaunchCampaignMap(mapinfo.obj, rally_index)
        end)
        Log.discover("launch: CampaignMenu.LaunchCampaignMap(%s, rally %d) -> %s",
            mapinfo.name, rally_index, okm and "OK" or tostring(errm))
        if okm then return true end
    elseif not mapinfo then
        Log.discover("launch: no MapInfo asset matched %q — rally point "
            .. "cannot be applied on this path", id_up)
    end

    -- Last resort: the menu's own LaunchCampaignMap(CampaignData, Scenario).
    -- Loads the mission but always at its start (no rally point).
    if cd then
        local ok, err = pcall(function()
            screen:LaunchCampaignMap(cd, FName(scen))
        end)
        Log.discover("launch: LaunchCampaignMap(%s, %q) -> %s",
            full_name(cd), scen, ok and "OK" or tostring(err))
        if ok then return true end
    else
        Log.discover("launch: CampaignData asset not found — using direct map travel")
    end

    -- Fallback: direct level travel. The real mission map path format is
    -- CONFIRMED from an on-device map-load log line (2026-07-28):
    --   /Game/Levels/Halo1/Solo/C20/C20  (C20 = The Library)
    -- This bypasses the campaign lobby (difficulty was already set above via
    -- SetClientLobbyDifficulty; rally point defaults to mission start).
    local id = scen:upper()
    local map = string.format("/Game/Levels/Halo1/Solo/%s/%s", id, id)
    local gs = try("find GameplayStatics", StaticFindObject,
        "/Script/Engine.Default__GameplayStatics")
    if gs and gs:IsValid() then
        local ok2, err2 = pcall(function()
            gs:OpenLevel(screen, FName(map), true, "")
        end)
        Log.discover("launch: OpenLevel(%q) -> %s", map,
            ok2 and "OK" or tostring(err2))
        if ok2 then return true end
        return false, "OpenLevel failed: " .. tostring(err2)
    end
    return false, "no launch path worked (LaunchCampaignMap + OpenLevel both failed)"
end

-- Continue support discovered in the same scan. Signature (SIG dump):
-- ResumeRemixSave(PlayerController).
function Gameapi.resume_remix_save()
    local statics = try("find MeteoriteUIStatics", StaticFindObject,
        "/Script/Meteorite.Default__MeteoriteUIStatics")
    if not (statics and statics:IsValid()) then return false end
    local pc = find_first("PlayerController")
    local ok, err = pcall(function() statics:ResumeRemixSave(pc) end)
    Log.discover("ResumeRemixSave -> %s", ok and "OK" or tostring(err))
    return ok
end

-- ------------------------------------------------------------ world

-- Name of the world that is currently loaded, e.g.
--   "World /Game/Levels/Halo1/Solo/B30/B30.B30"      (in a mission)
--   "World /Game/Levels/UI/Frontend/Frontend.Frontend" (in the menus)
--
-- RegisterLoadMapPostHook proved unreliable here: on-device it fired for the
-- first Frontend load and never again, including for the mission map that
-- demonstrably loaded (2026-07-29 log). Polling the live world is stable.
function Gameapi.current_world_name()
    for _, cls in ipairs({ "PlayerController", "GameModeBase", "HUD" }) do
        local obj = find_first(cls)
        if obj then
            local w = try("GetWorld", function() return obj:GetWorld() end)
            if w and w:IsValid() then
                local n = full_name(w)
                if n and n ~= "?" then return n end
            end
        end
    end
    return nil
end

-- True while a campaign mission map is loaded (Solo levels live under
-- /Game/Levels/Halo1/Solo/<ID>/<ID>, confirmed on-device).
function Gameapi.in_mission_world()
    local n = Gameapi.current_world_name()
    if not n then return nil end -- unknown, not "no"
    return n:find("/Solo/", 1, true) ~= nil
end

-- ------------------------------------------------------------ enums
--
-- The CXX header dump names the enums (EBlamGameSkulls,
-- EBlamCampaignDifficultyLevel) but not their members, so the values are read
-- from the live UEnum objects instead. Resolved values are cached here and
-- written to the log in a form that can be pasted straight into const.lua.
local ENUM_NAMES = {
    skulls     = "EBlamGameSkulls",
    difficulty = "EBlamCampaignDifficultyLevel",
}
local enum_values = {}   -- kind -> { [NAME] = value }
local enum_objects = nil -- short name -> UEnum, filled by one array scan

-- Locate the UEnum objects. The header dump does not say which package
-- declares them and guessing paths failed on-device ("enum object not found"),
-- so they are found by scanning GUObjectArray for "Enum <pkg>.<Name>".
local function find_enum_objects()
    if enum_objects then return enum_objects end
    enum_objects = {}
    local want = {}
    for _, n in pairs(ENUM_NAMES) do want[n] = true end
    pcall(function()
        ForEachUObject(function(obj)
            pcall(function()
                local name = fstr(obj:GetFullName())
                if not name:find("^Enum ") then return end
                local short = name:match("%.([%w_]+)$")
                if short and want[short] and not enum_objects[short] then
                    enum_objects[short] = obj
                    Log.discover("enum found: %s", name)
                end
            end)
        end)
    end)
    return enum_objects
end

-- Read a UEnum's members. UE4SS exposes no single guaranteed API for this, so
-- several read-only approaches are tried and whichever works is used.
local function read_enum(short_name)
    local e = find_enum_objects()[short_name]
    if not (e and e:IsValid()) then return nil, "enum object not found" end
    local out = {}

    -- 1. UE4SS >= 3.0 exposes ForEachName on UEnum objects.
    local ok = pcall(function()
        e:ForEachName(function(name, value)
            out[fstr(name)] = value
        end)
    end)
    if ok and next(out) then return out end

    -- 2. Names array (UEnum::Names is a TArray<TPair<FName,int64>>).
    out = {}
    pcall(function()
        local names = e.Names
        local n = names and names:GetArrayNum() or 0
        for i = 1, n do
            local pair = names[i]
            local key = fstr(pair.Key or pair.First or pair[1])
            local val = pair.Value or pair.Second or pair[2]
            if key then out[key] = val end
        end
    end)
    if next(out) then return out end

    -- 3. Brute-force lookup by value (works when GetNameByValue is exposed).
    out = {}
    for v = 0, 63 do
        local okv, nm = pcall(function() return fstr(e:GetNameByValue(v)) end)
        if okv and nm and nm ~= "" and not nm:match("^None$")
            and not nm:match("^%-?%d+$") then
            out[nm] = v
        end
    end
    if next(out) then return out end
    return nil, "no readable enum API"
end

-- Log every enum member. The skull list replaces the guessed SKULL_POOL ids
-- in const.lua; the difficulty list confirms the Easy/Normal/Heroic/Legendary
-- ordering the launch call relies on.
function Gameapi.dump_enums()
    for kind, short in pairs(ENUM_NAMES) do
        local vals, err = read_enum(short)
        if vals then
            enum_values[kind] = vals
            local parts = {}
            for name, v in pairs(vals) do
                parts[#parts + 1] = string.format("%s=%s", name, tostring(v))
            end
            table.sort(parts)
            Log.discover("ENUM %s (%d): %s", kind, #parts, table.concat(parts, ", "))
        else
            Log.discover("ENUM %s: UNREADABLE (%s)", kind, tostring(err))
        end
    end
end

-- Map this mod's skull ids onto real EBlamGameSkulls values. Returns nil until
-- the enum has been read AND const.lua's ids match real members — callers then
-- simply omit ActiveSkulls and keep whatever Campaign Remix applied.
function Gameapi.skull_enum_values(skull_ids)
    local vals = enum_values.skulls
    if not vals then return nil end
    -- Members come back fully qualified ("EBlamGameSkulls::Iron"), so the
    -- enum prefix has to go before comparing — without this every lookup
    -- missed and 0 of 5 skulls were sent (on-device 2026-07-29).
    local norm = {}
    for name, v in pairs(vals) do
        local short = name:match("::([%w_]+)$") or name
        norm[short:lower():gsub("[^%a%d]", "")] = v
    end
    local out, missing = {}, {}
    for _, id in ipairs(skull_ids) do
        local key = id:lower():gsub("[^%a%d]", "")
        if norm[key] then
            out[#out + 1] = norm[key]
        else
            missing[#missing + 1] = id
        end
    end
    if #missing > 0 then
        Log.discover("skulls: no enum member for [%s] — sending %d of %d",
            table.concat(missing, ","), #out, #skull_ids)
    end
    if #out == 0 then return nil end
    return out
end

-- ------------------------------------------------------------ skull writing
--
-- Difficulty and InsertionPoint travel fine inside the options struct, but
-- ActiveSkulls is a TSet<EBlamGameSkulls> and a plain Lua array does not
-- populate it: on-device the launch reported OK with values [0,38,37,31,7]
-- yet the mission ran with Iron + BlackEye, i.e. Campaign Remix's own random
-- roll rather than this mod's set.
--
-- So the set is (also) written in-mission, straight onto the live
-- BlamSkullsGameStateComponent, and every attempt is verified by reading the
-- field back. Whatever shape succeeds shows up in the log as "VERIFIED".

-- Describe an unknown container value: Lua type, length via whichever
-- accessor exists, and its elements when they can be read.
local function describe_container(v)
    if v == nil then return "nil" end
    local t = type(v)
    local parts = { t }
    local n = try("len", function() return #v end)
        or try("GetArrayNum", function() return v:GetArrayNum() end)
    if n then parts[#parts + 1] = "len=" .. tostring(n) end
    local elems = {}
    pcall(function()
        for i = 1, (tonumber(n) or 0) do
            elems[#elems + 1] = tostring(v[i])
        end
    end)
    if #elems == 0 then
        pcall(function()
            for _, e in ipairs(v) do elems[#elems + 1] = tostring(e) end
        end)
    end
    if #elems > 0 then
        parts[#parts + 1] = "{" .. table.concat(elems, ",") .. "}"
    end
    -- Method names, so a usable Add/Empty API shows up in the log if present.
    local mt = try("getmetatable", function() return getmetatable(v) end)
    if type(mt) == "table" then
        local names = {}
        pcall(function()
            for k in pairs(mt.__index or mt) do
                if type(k) == "string" then names[#names + 1] = k end
            end
        end)
        table.sort(names)
        if #names > 0 then
            parts[#parts + 1] = "methods=[" .. table.concat(names, ",") .. "]"
        end
    end
    return table.concat(parts, " ")
end

-- Live (non-CDO) skulls component for the current mission.
local function skulls_component()
    local all = try("FindAllOf(BlamSkullsGameStateComponent)", FindAllOf,
        "BlamSkullsGameStateComponent")
    if not all then return nil end
    for _, obj in ipairs(all) do
        local ok, valid = pcall(function() return obj:IsValid() end)
        if ok and valid and not full_name(obj):find("Default__", 1, true) then
            return obj
        end
    end
    return nil
end

-- CONFIRMED on-device 2026-07-29: writing the component's ActiveSkulls with a
-- number list failed with
--   "Can't copy struct of type None into GameplayTagContainer
--    Property: BlamSkullsGameStateComponent:ActiveSkulls"
-- In a live mission skulls are GAMEPLAY TAGS, not EBlamGameSkulls values —
-- which is also why OnSkullsAdded/Removed take an FGameplayTagContainer.
-- Sending enum numbers could never have worked.

local tag_lib_logged = false
local function tag_library()
    local lib = try("find BlueprintGameplayTagLibrary", StaticFindObject,
        "/Script/GameplayTags.Default__BlueprintGameplayTagLibrary")
    if lib and lib:IsValid() and not tag_lib_logged then
        tag_lib_logged = true
        local fns = {}
        pcall(function()
            lib:GetClass():ForEachFunction(function(fn)
                fns[#fns + 1] = fstr(fn:GetFName())
            end)
        end)
        Log.discover("tags: BlueprintGameplayTagLibrary functions: %s",
            #fns > 0 and table.concat(fns, ", ") or "(none)")
    end
    return lib
end

-- Read a tag container's contents. The exact break-out API varies, so several
-- are tried; whichever answers gives the real tag names, which is what the
-- skull ids have to be translated into.
local function read_tag_container(container)
    if container == nil then return nil end
    local lib = tag_library()
    if not (lib and lib:IsValid()) then return nil end
    local out = {}
    local ok = pcall(function()
        local res = {}
        lib:BreakGameplayTagContainer(container, res)
        local arr = res.GameplayTags or res[1]
        if arr == nil then for _, v in pairs(res) do arr = v break end end
        local n = try("len", function() return arr:GetArrayNum() end)
            or try("#", function() return #arr end) or 0
        for i = 1, n do
            local tag = arr[i]
            local name = try("TagName", function() return fstr(tag.TagName) end)
                or try("tostring", function() return fstr(tag) end)
            out[#out + 1] = tostring(name)
        end
    end)
    if ok and #out > 0 then return out end
    return nil
end

-- Log which gameplay tags the game currently has active. This is the naming
-- scheme the mod must produce (e.g. "Skull.Iron" vs "Blam.Skull.Iron"), and
-- it can only be learned from a live mission.
function Gameapi.dump_skull_tags()
    local comp = skulls_component()
    if not comp then
        Log.discover("tags: no live BlamSkullsGameStateComponent")
        return nil
    end
    tag_library()
    local container = try("read ActiveSkulls", function() return comp.ActiveSkulls end)
    Log.discover("tags: ActiveSkulls raw = %s", describe_container(container))
    local names = read_tag_container(container)
    if names then
        Log.discover("tags: ACTIVE SKULL TAGS (%d): %s", #names,
            table.concat(names, ", "))
    else
        Log.discover("tags: could not break the container into tags — the "
            .. "library's function list above shows what is callable")
    end
    -- Any gameplay tag mentioning a skull, wherever it lives.
    local hits = scan_multi({ "Skull" }, 40)
    local shown = 0
    for _, e in ipairs(hits.Skull or {}) do
        if e.name:find("Tag", 1, true) then
            Log.discover("tags: candidate %s", e.name)
            shown = shown + 1
        end
    end
    if shown == 0 then Log.discover("tags: no skull-tag objects found by scan") end
    return names
end

-- Force the run's skulls onto the live mission by writing gameplay tags.
-- `values` are enum numbers (kept for the launch path); `ids` are the mod's
-- skull ids, which map onto tag names. Returns true only when a read-back
-- confirms the tags actually landed.
function Gameapi.apply_skulls_in_mission(values, ids)
    local comp = skulls_component()
    if not comp then
        Log.discover("skullwrite: no live BlamSkullsGameStateComponent found")
        return false
    end
    Log.discover("skullwrite: component %s", full_name(comp))

    -- What is in there right now, and under what naming scheme?
    local current = Gameapi.dump_skull_tags()
    if not ids or #ids == 0 then return false end

    -- Derive the tag prefix from a tag that is already active, so the scheme
    -- comes from the game rather than a guess. Falls back to the common
    -- candidates when nothing is active yet.
    local prefixes = {}
    if current and current[1] then
        local pfx = current[1]:match("^(.*)%.[^.]+$")
        if pfx then prefixes[#prefixes + 1] = pfx .. "." end
    end
    for _, p in ipairs({ "Skull.", "Blam.Skull.", "Game.Skull.", "" }) do
        prefixes[#prefixes + 1] = p
    end

    local lib = tag_library()
    if not (lib and lib:IsValid()) then
        Log.warn("skullwrite: BlueprintGameplayTagLibrary unavailable")
        return false
    end

    for _, prefix in ipairs(prefixes) do
        local tags = {}
        for _, id in ipairs(ids) do tags[#tags + 1] = { TagName = prefix .. id } end
        local ok, err = pcall(function()
            local out = {}
            lib:MakeGameplayTagContainerFromArray(tags, out)
            local container = out.ReturnValue or out[1]
            if container == nil then
                for _, v in pairs(out) do container = v break end
            end
            if container == nil then error("no container returned") end
            comp.ActiveSkulls = container
        end)
        local after = read_tag_container(
            try("read ActiveSkulls", function() return comp.ActiveSkulls end))
        local hit = 0
        for _, id in ipairs(ids) do
            for _, name in ipairs(after or {}) do
                if name:find(id, 1, true) then hit = hit + 1 break end
            end
        end
        Log.discover("skullwrite: prefix %q -> write=%s, %d/%d tags present",
            prefix, ok and "ok" or tostring(err), hit, #ids)
        if hit == #ids then
            Log.info("skullwrite: VERIFIED — skulls forced via tag prefix %q", prefix)
            return true
        end
    end
    Log.warn("skullwrite: no tag prefix landed; the game keeps its own skulls. "
        .. "The ACTIVE SKULL TAGS line above shows the real naming scheme.")
    return false
end

-- In-mission skull discovery: the FN dump shows a game-state skulls component
-- (BP_BaseBlamEffect:GetGameStateSkullsComponent, BlamEngineAudioGameSubsystem:
-- GetActiveSkulls, Pawn OnSkullsAdded/Removed) — meaning skulls live on a
-- component that only exists inside a mission. This logs its class, functions
-- and properties so skull forcing can move from the lobby (fragile) to a
-- direct in-mission call. Triggered ~20s after a Solo map loads (main.lua).
function Gameapi.dump_skull_objects()
    Log.discover("==== in-mission skull discovery start ====")
    local matches = scan_multi({ "Skulls", "InsertionPoint" }, 30)
    local seen_cls = {}
    for _, key in ipairs({ "Skulls", "InsertionPoint" }) do
        for _, e in ipairs(matches[key]) do
            Log.discover("SKOBJ %s", e.name)
            local cls = try("GetClass", function() return e.obj:GetClass() end)
            local cname = cls and full_name(cls) or "?"
            if cls and not seen_cls[cname] then
                seen_cls[cname] = true
                local fns = {}
                pcall(function()
                    cls:ForEachFunction(function(fn)
                        fns[#fns + 1] = fstr(fn:GetFName())
                    end)
                end)
                if #fns > 0 then
                    Log.discover("SKFNS %s: %s", cname, table.concat(fns, ", "))
                end
                dump_props(e.obj, cname)
            end
        end
    end
    Log.discover("==== in-mission skull discovery end ====")
end

-- ------------------------------------------------------------ discovery

-- F7: log a discovery report. Complements UE4SS's own object dumper (use the
-- UE4SS GUI "Dump Objects" for the full UObject dump); this report focuses on
-- the specific classes this mod needs.
-- Can the floor cards show the game's own mission artwork? The scenario table
-- row carries MissionPreviewImage (TSoftObjectPtr<UTexture2D>) and the main
-- menu already owns a preview panel (WBP_ResumeCampaignInfoPanel_C with
-- SetCampaignUIInfo). This logs whether both are reachable at runtime, which
-- decides whether an image can be put beside the floor list at all.
function Gameapi.dump_image_sources()
    Log.discover("---- image sources ----")
    for _, cls in ipairs({ "WBP_ResumeCampaignInfoPanel_C", "HaloUIImage",
        "Image", "BlamScenarioDataTable" }) do
        local all = try("FindAllOf(" .. cls .. ")", FindAllOf, cls)
        Log.discover("IMG %s: %d instance(s)", cls, all and #all or 0)
        if all and all[1] then
            local cl = try("GetClass", function() return all[1]:GetClass() end)
            if cl then
                local fns = {}
                pcall(function()
                    cl:ForEachFunction(function(fn) fns[#fns + 1] = fstr(fn:GetFName()) end)
                end)
                if #fns > 0 then
                    Log.discover("IMG %s functions: %s", cls,
                        table.concat(fns, ", "):sub(1, 400))
                end
            end
        end
    end
    -- Mission artwork assets, if any are loaded.
    local hits = scan_multi({ "MissionPreview", "ScenarioDataTable", "T_Mission" }, 12)
    for key, list in pairs(hits) do
        for _, e in ipairs(list) do
            Log.discover("IMG %s -> %s", key, e.name)
        end
    end
    Log.discover("---- image sources end ----")
end

function Gameapi.discovery_dump()
    Log.discover("==== discovery dump start ====")
    Gameapi.get_build_version()
    Gameapi.dump_enums()
    Gameapi.dump_image_sources()

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
