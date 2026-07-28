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

    -- One object-array walk for everything this launch needs: the MapInfo
    -- asset (rally-capable launch), the client lobby data (skull/rally
    -- property discovery) and any live CampaignSetup (Selected* helpers).
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

    -- Preferred path: the menu's own LaunchCampaignMap(CampaignData, Scenario).
    local cd = Gameapi.find_campaign_data()
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
