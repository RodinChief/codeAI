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
    -- Named entry properties on the menu screen (CONFIRMED on-device via the
    -- F7 TextBlock scan 2026-07-28): each menu row is a named child widget.
    -- RemixButton is the preferred template (sits where ROGUELIKE goes).
    entry_props = {
        "RemixButton",
        "CampaignMenuButton",
        "CustomizationButton",
        "CollectiblesButton",
        "QuitButton",
    },
    -- Per-entry widget classes (fallback template lookup by class).
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
    -- Text-setting: name of the TextBlock inside the entry. "NameText" is
    -- CONFIRMED on-device (every menu row labels itself via a NameText child).
    entry_label_widgets = { "NameText", "Label", "Text", "ButtonText" },
}

local injected = nil       -- our injected entry widget, once created
local on_activate = nil    -- callback: open the roguelike panel
local click_hooked = false
local last_log = nil       -- de-spam: repeat log lines are suppressed
local cached_screen, cached_template, cached_parent = nil, nil, nil
local hover_watch_started = false
local status_rows = {}     -- extra native rows rendering run state in-menu
local last_status = nil

-- Log only when the message changes, so the 5s retry loop stays quiet.
local function log_state(fmt, ...)
    local msg = string.format(fmt, ...)
    if msg ~= last_log then
        Log.discover("menuinject: %s", msg)
        last_log = msg
    end
end

local function try(fn, ...)
    local ok, res = pcall(fn, ...)
    if ok then return res end
    return nil
end

-- FString-safe stringification (plain tostring on UE4SS FStrings yields the
-- object address, not the text).
local function fstr(v)
    if type(v) == "string" then return v end
    local s = try(function() return v:ToString() end)
    if type(s) == "string" then return s end
    return tostring(v)
end

local function full_name(obj)
    return fstr(try(function() return obj:GetFullName() end) or "?")
end

local function find_first_valid(short_class)
    local all = try(FindAllOf, short_class)
    if not all then return nil end
    for _, obj in ipairs(all) do
        if obj:IsValid() then return obj end
    end
    return nil
end

-- Build an FText. UE4SS >= 3.0 has a global FText() constructor; fall back to
-- KismetTextLibrary (Engine module — NOT UMG, that lookup silently fails).
local function make_ftext(text)
    local ok, ft = pcall(function() return FText(text) end)
    if ok and ft then return ft end
    local ktl = try(StaticFindObject, "/Script/Engine.Default__KismetTextLibrary")
    if ktl and ktl:IsValid() then
        return try(function() return ktl:Conv_StringToText(text) end)
    end
    return nil
end

-- Set the entry's label. Tries a SetText API on the entry itself first (many
-- games expose one on their button widget), then named TextBlock children.
local function set_label(entry, text, quiet)
    local ftext = make_ftext(text)
    if not ftext then
        if not quiet then
            Log.discover("menuinject: could not construct FText — no label possible")
        end
        return false
    end
    if try(function() entry:SetText(ftext) return true end) then
        if not quiet then Log.discover("menuinject: label set via entry:SetText") end
        return true
    end
    for _, name in ipairs(CANDIDATES.entry_label_widgets) do
        local ok = try(function()
            local tb = entry[name]
            if tb and tb:IsValid() then tb:SetText(ftext) return true end
        end)
        if ok then
            if not quiet then Log.discover("menuinject: label set via child %q", name) end
            return true
        end
    end
    if not quiet then
        Log.discover("menuinject: could NOT set label — dump the entry widget tree "
            .. "and add the TextBlock name to CANDIDATES.entry_label_widgets")
    end
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
                        and full_name(this) == full_name(injected) then
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

-- Hover fallback: while the real click UFunction is unresolved, highlighting
-- the ROGUELIKE row activates it (edge-triggered on hover).
local hover_was = false
function start_hover_watcher()
    if hover_watch_started then return end
    hover_watch_started = true
    pcall(function()
        LoopAsync(250, function()
            if not injected or not try(function() return injected:IsValid() end) then
                hover_watch_started = false
                return true
            end
            -- Gamepad menus use focus, not mouse hover — check both.
            local hovered = try(function() return injected:IsHovered() end)
                or try(function() return injected:HasKeyboardFocus() end)
                or try(function() return injected:HasFocusedDescendants() end)
            if hovered and not hover_was then
                hover_was = true
                Log.info("menuinject: ROGUELIKE entry hovered — activating")
                ExecuteInGameThread(function()
                    if on_activate then on_activate() end
                end)
            elseif not hovered then
                hover_was = false
            end
            return false
        end)
    end)
end

-- In-menu status rows: native rows under the menu list mirroring the run
-- state (seed, floor, skulls, next action) so the mode is visible in-game.
-- Rows are the same button widget class, made non-interactive.
function Menuinject.set_status_lines(lines)
    if not cached_parent or not cached_template or not cached_screen then
        return false
    end
    local blob = table.concat(lines, "\n")
    if blob == last_status then return true end
    local wbl = try(StaticFindObject, "/Script/UMG.Default__WidgetBlueprintLibrary")
    local owner = try(function() return cached_template:GetOwningPlayer() end)
    for i = 1, #lines do
        local row = status_rows[i]
        if not (row and try(function() return row:IsValid() end)) then
            row = wbl and try(function()
                return wbl:Create(cached_screen, cached_template:GetClass(), owner)
            end) or nil
            if not row then return false end
            try(function() cached_parent:AddChild(row) end)
            status_rows[i] = row
        end
        set_label(row, lines[i], true)
        -- 4 = SelfHitTestInvisible: rendered but not clickable/focusable.
        try(function() row:SetVisibility(4) end)
    end
    for i = #lines + 1, #status_rows do
        local row = status_rows[i]
        if row then try(function() row:SetVisibility(1) end) end -- 1 = Collapsed
    end
    last_status = blob
    return true
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
            log_state("menu screen found: %s (%s)", cls, full_name(screen))
            break
        end
    end
    if not screen then return false end

    -- Find an existing entry to use as the template. Preferred: the screen's
    -- own named row widgets (RemixButton etc., confirmed on-device); fallback:
    -- class-based lookup.
    local template, template_class_name
    for _, prop in ipairs(CANDIDATES.entry_props) do
        local t = try(function() return screen[prop] end)
        if t and try(function() return t:IsValid() end) then
            template = t
            Log.discover("menuinject: entry template from screen.%s", prop)
            break
        end
    end
    if not template then
        for _, cls in ipairs(CANDIDATES.menu_entry) do
            template = find_first_valid(cls)
            if template then break end
        end
    end
    if not template then
        log_state("screen present but no entry template found — press F7 for "
            .. "the TextBlock scan and extend CANDIDATES.entry_props")
        return false
    end
    template_class_name = full_name(template:GetClass())
        :gsub("^%S+%s", "") -- strip "WidgetBlueprintGeneratedClass " prefix
    Log.discover("menuinject: entry template class: %s", template_class_name)

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
            full_name(try(function() return parent:GetClass() end) or "?"))
        return false
    end

    -- Position directly after the template row (Campaign Remix). ShiftChild
    -- exists on some panels at runtime; harmless if absent (entry lands at
    -- the bottom of the list instead).
    local idx = try(function() return parent:GetChildIndex(template) end)
    if type(idx) == "number" and idx >= 0 then
        if not try(function() parent:ShiftChild(idx + 1, clone) return true end) then
            try(function() parent:ShiftChild(clone, idx + 1) return true end)
        end
    end

    hook_clicks(template_class_name)
    set_label(clone, "ROGUELIKE")
    try(function() clone:SetVisibility(0) end) -- 0 = ESlateVisibility::Visible
    cached_screen, cached_template, cached_parent = screen, template, parent
    start_hover_watcher()

    injected = clone
    Log.info("menuinject: ROGUELIKE entry injected into the main menu")
    return click_hooked -- keep retrying label/hook refinement until clicks work
end

-- Start polling for the menu. `activate_cb` opens the roguelike panel.
function Menuinject.start(activate_cb)
    on_activate = activate_cb
    local tries = 0
    local ok = pcall(function()
        LoopAsync(5000, function()
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
