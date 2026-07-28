-- menuinject.lua — inject a native "ROGUELIKE" entry into the main menu list.
--
-- Approach (the only editor-free way to get a native-looking entry, since
-- building new UMG assets is ruled out by brief §9): find the shipped
-- front-end widget at runtime, locate the vertical list of menu entries
-- (RESUME SOLO GAME / CAMPAIGN / CAMPAIGN REMIX / ...), spawn one more
-- instance of the SAME entry widget class the game uses, relabel it
-- "ROGUELIKE", and add it to the same container. Because it is literally the
-- game's own widget class, font/spacing/hover come for free.
--
-- Every class/property name here is a CANDIDATE until confirmed by a widget
-- dump (docs/DISCOVERY.md step "menu injection"). Until they resolve, this
-- module logs what it found and quietly does nothing — F6 keeps working as
-- the fallback entrance.
--
-- Click routing: cloned native buttons fire the game's shared click handler,
-- not ours. We hook the entry class's click UFunction and compare instances;
-- when the firing instance is our injected entry we open the roguelike panel
-- and swallow the event.

local Log = require("log")

local Menuinject = {}

local CANDIDATES = {
    -- Front-end screen widget classes (short names, as FindAllOf wants).
    menu_screen = {
        "WBP_MainMenu_C",
        "WBP_MainMenuScreen_C",
        "WBP_FrontEnd_C",
        "WBP_FrontEndScreen_C",
        "WBP_TitleScreen_C",
    },
    -- Per-entry widget classes (the thing we clone).
    menu_entry = {
        "WBP_MainMenuButton_C",
        "WBP_MenuListButton_C",
        "WBP_FrontEndButton_C",
        "WBP_NavButton_C",
    },
    -- Click handler UFunctions on the entry class (hooked, instance-compared).
    entry_click_fns = {
        "OnButtonClicked",
        "HandleButtonClicked",
        "OnClicked",
        "HandleClicked",
    },
    -- Text-setting: name of the TextBlock inside the entry, if SetText on a
    -- found TextBlock descendant fails.
    entry_label_widgets = { "Label", "Text", "ButtonText", "TXT_Label" },
}

local injected = nil       -- our injected entry widget, once created
local on_activate = nil    -- callback: open the roguelike panel
local click_hooked = false

local function try(fn, ...)
    local ok, res = pcall(fn, ...)
    if ok then return res end
    return nil
end

local function find_first_valid(short_class)
    local all = try(FindAllOf, short_class)
    if not all then return nil end
    for _, obj in ipairs(all) do
        if obj:IsValid() then return obj end
    end
    return nil
end

-- Set the entry's label. Tries a SetText API on the entry itself first (many
-- games expose one on their button widget), then named TextBlock children.
local function set_label(entry, text)
    local ftext = nil
    local ktl = try(StaticFindObject, "/Script/UMG.Default__KismetTextLibrary")
    if ktl and ktl:IsValid() then
        ftext = try(function() return ktl:Conv_StringToText(text) end)
    end
    if ftext and try(function() entry:SetText(ftext) return true end) then
        Log.discover("menuinject: label set via entry:SetText")
        return true
    end
    for _, name in ipairs(CANDIDATES.entry_label_widgets) do
        local ok = try(function()
            local tb = entry[name]
            if tb and tb:IsValid() and ftext then tb:SetText(ftext) return true end
        end)
        if ok then
            Log.discover("menuinject: label set via child %q", name)
            return true
        end
    end
    Log.discover("menuinject: could NOT set label — dump the entry widget tree "
        .. "and add the TextBlock name to CANDIDATES.entry_label_widgets")
    return false
end

-- Hook the click function once per resolved entry class.
local function hook_clicks(entry_class_name)
    if click_hooked then return end
    for _, fn in ipairs(CANDIDATES.entry_click_fns) do
        -- Hook path needs the full class path; derive it from the instance.
        local ok = pcall(function()
            RegisterHook(string.format("%s:%s", entry_class_name, fn),
                function(Context)
                    local this = Context:get()
                    if injected and this:IsValid()
                        and this:GetFullName() == injected:GetFullName() then
                        Log.info("menuinject: ROGUELIKE entry activated")
                        ExecuteInGameThread(function()
                            if on_activate then on_activate() end
                        end)
                    end
                end)
        end)
        if ok then
            click_hooked = true
            Log.discover("menuinject: click hook on %s:%s", entry_class_name, fn)
            return
        end
    end
    Log.discover("menuinject: no click hook resolved for %s — entry will show "
        .. "but not respond; F6 remains the entrance", entry_class_name)
end

-- One injection attempt. Returns true when done (stops the retry loop).
local function attempt()
    if injected and try(function() return injected:IsValid() end) then
        return true
    end
    injected = nil

    local screen
    for _, cls in ipairs(CANDIDATES.menu_screen) do
        screen = find_first_valid(cls)
        if screen then
            Log.discover("menuinject: menu screen found: %s (%s)",
                cls, tostring(screen:GetFullName()))
            break
        end
    end
    if not screen then return false end

    -- Find an existing entry to use as the template.
    local template, template_class_name
    for _, cls in ipairs(CANDIDATES.menu_entry) do
        template = find_first_valid(cls)
        if template then
            template_class_name = tostring(template:GetClass():GetFullName())
                :gsub("^%S+%s", "") -- strip "WidgetBlueprintGeneratedClass " prefix
            Log.discover("menuinject: entry template: %s (%s)", cls, template_class_name)
            break
        end
    end
    if not template then
        Log.discover("menuinject: screen present but no entry class matched — "
            .. "dump widgets under the menu screen and extend CANDIDATES.menu_entry")
        return false
    end

    -- Parent container of the entries (VerticalBox or similar panel).
    local parent = try(function() return template:GetParent() end)
    if not parent or not parent:IsValid() then
        Log.discover("menuinject: template has no reachable parent panel")
        return false
    end

    -- Spawn a sibling of the same class.
    local wbl = try(StaticFindObject, "/Script/UMG.Default__WidgetBlueprintLibrary")
    local owner = try(function() return template:GetOwningPlayer() end)
    local clone = wbl and try(function()
        return wbl:Create(screen, template:GetClass(), owner)
    end) or nil
    if not clone or not clone:IsValid() then
        Log.discover("menuinject: WidgetBlueprintLibrary.Create failed")
        return false
    end

    local added = try(function() return parent:AddChild(clone) end)
    if not added then
        Log.discover("menuinject: parent:AddChild failed (panel class: %s)",
            tostring(try(function() return parent:GetClass():GetFullName() end)))
        return false
    end

    -- Position: after CAMPAIGN REMIX = index 3 (0-based slot 3). ShiftChild
    -- exists on some panels at runtime; harmless if absent (entry lands at
    -- the bottom of the list instead).
    try(function() parent:ShiftChild(3, clone) end)

    set_label(clone, "ROGUELIKE")
    hook_clicks(template_class_name)

    injected = clone
    Log.info("menuinject: ROGUELIKE entry injected into the main menu")
    return click_hooked -- keep retrying label/hook refinement until clicks work
end

-- Start polling for the menu. `activate_cb` opens the roguelike panel.
function Menuinject.start(activate_cb)
    on_activate = activate_cb
    local tries = 0
    local ok = pcall(function()
        LoopAsync(2000, function()
            tries = tries + 1
            local done = try(attempt) or false
            -- Menus get recreated (e.g. returning from a mission), so never
            -- fully stop; back off to a slow re-check once resolved.
            if tries > 150 and not injected then
                Log.discover("menuinject: giving up after %d attempts — see "
                    .. "docs/DISCOVERY.md (menu injection); F6 overlay unaffected",
                    tries)
                return true
            end
            return false
        end)
    end)
    if not ok then
        Log.warn("menuinject: LoopAsync unavailable; native menu entry disabled")
    end
end

return Menuinject
