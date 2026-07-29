-- menuinject.lua — a native "ROGUELIKE" entry + submenu inside the main menu.
--
-- Approach (the only editor-free way to get a native-looking entry, since
-- building new UMG assets is ruled out by brief §9): find the shipped
-- front-end widget at runtime, locate the vertical list of menu entries
-- (RESUME SOLO GAME / CAMPAIGN / CAMPAIGN REMIX / ...), spawn more instances
-- of the SAME entry widget class the game uses and add them to the same
-- container. Because they are literally the game's own widget class,
-- font/spacing/hover come for free.
--
-- SUBMENU model: activating ROGUELIKE collapses the game's own menu rows and
-- shows the mod's rows in their place — visually a submenu, like CAMPAIGN's
-- own screen. The "◀ BACK" row restores the original menu. Row text prefixes
-- carry meaning (set by ui.compact_lines): "▶ " = selectable action,
-- "◀ " = back, anything else = informational.
--
-- Activation: cloned rows are NOT part of the menu's MainButtonContainer
-- button group (confirmed by the F7 UFunction dump — clicks route through
-- BndEvt__..MainButtonContainer.. delegates), so pressing A on them often
-- does nothing. Two paths, either works:
--   1. click hooks on /Script/CommonUI.CommonButtonBase:HandleButtonClicked
--      and :HandleButtonPressed (fire for mouse/touch clicks);
--   2. focus dwell: holding gamepad focus (or mouse hover) on an actionable
--      row for ~1s activates it. Focus detection is confirmed working
--      on-device, so the Steam Deck always has a pure-controller path.

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
    -- Native click handler paths (CONFIRMED via F7 scan: menu buttons are
    -- CommonUI CommonButtonBase). BOTH are hooked — Pressed covers input
    -- routes where Clicked never fires on out-of-group buttons.
    click_paths = {
        "/Script/CommonUI.CommonButtonBase:HandleButtonClicked",
        "/Script/CommonUI.CommonButtonBase:HandleButtonPressed",
    },
    -- Text-setting, in order: SetButtonLabelText is the button's own BP API
    -- (CONFIRMED in the F7 UFunction dump on WBP_MeteoriteStandaloneButton-
    -- Default_C); NameText child is the confirmed fallback.
    entry_label_widgets = { "NameText", "Label", "Text", "ButtonText" },
}

-- Dwell activation: ticks of the 250ms watcher that focus must stay on a row
-- before it fires. ROGUELIKE opens a submenu (cheap) so it opens faster.
local DWELL_OPEN_TICKS = 3   -- ~0.75s on the ROGUELIKE entry
local DWELL_ROW_TICKS  = 4   -- ~1s on a ▶/◀ row

local injected = nil       -- our injected ROGUELIKE entry widget, once created
local on_activate = nil    -- callback: roguelike submenu was opened
local on_row_click = nil   -- callback(text): a "▶"/"◀" row was activated
local on_row_focus = nil   -- callback(text): the highlighted row changed
local focused_text = nil   -- text of the row currently highlighted
local click_hooked = false
local last_log = nil       -- de-spam: repeat log lines are suppressed
local last_click_log = nil
local cached_screen, cached_template, cached_parent = nil, nil, nil
local watcher_started = false

local submenu_open = false
local status_rows = {}     -- our submenu row widgets
local row_texts = {}       -- text per row (prefix decides actionability)
local pending_lines = nil  -- latest lines from ui.compact_lines
local last_status = nil
local saved_vis = {}       -- { {widget=w, vis=n}, ... } of hidden game rows

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

local function is_valid(w)
    return w ~= nil and try(function() return w:IsValid() end) == true
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

local function addr(obj)
    return try(function() return obj:GetAddress() end)
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

-- Set the entry's label. SetButtonLabelText (the widget's own API) first,
-- then named TextBlock children.
local function set_label(entry, text, quiet)
    local ftext = make_ftext(text)
    if not ftext then
        if not quiet then
            Log.discover("menuinject: could not construct FText — no label possible")
        end
        return false
    end
    if try(function() entry:SetButtonLabelText(ftext) return true end) then
        if not quiet then Log.discover("menuinject: label set via SetButtonLabelText") end
        return true
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

-- ------------------------------------------------------------- submenu

-- Address set of the mod's own widgets (ROGUELIKE entry + rows).
local function ours_addr_set()
    local set = {}
    local a = addr(injected)
    if a then set[a] = true end
    for _, row in ipairs(status_rows) do
        local ra = addr(row)
        if ra then set[ra] = true end
    end
    return set
end

local function apply_pending_rows()
    if not (submenu_open and pending_lines) then return end
    if not (is_valid(cached_parent) and is_valid(cached_template)
        and is_valid(cached_screen)) then return end
    local lines = pending_lines
    local blob = table.concat(lines, "\n")
    if blob == last_status then return end
    local wbl = try(StaticFindObject, "/Script/UMG.Default__WidgetBlueprintLibrary")
    local owner = try(function() return cached_template:GetOwningPlayer() end)
    for i = 1, #lines do
        local row = status_rows[i]
        if not is_valid(row) then
            row = wbl and try(function()
                return wbl:Create(cached_screen, cached_template:GetClass(), owner)
            end) or nil
            if not row then return end
            try(function() cached_parent:AddChild(row) end)
            try(function() row:SetIsFocusable(true) end)
            status_rows[i] = row
        end
        set_label(row, lines[i], true)
        row_texts[i] = lines[i]
        try(function() row:SetVisibility(0) end) -- 0 = Visible
    end
    for i = #lines + 1, #status_rows do
        local row = status_rows[i]
        if row then try(function() row:SetVisibility(1) end) end -- 1 = Collapsed
        row_texts[i] = nil
    end
    last_status = blob
end

-- Open the submenu: collapse every game-owned row in the menu list (saving
-- its visibility), keep ROGUELIKE as the header, show the mod's rows.
local function open_submenu()
    if submenu_open then return end
    if not (is_valid(cached_parent) and is_valid(injected)) then return end
    submenu_open = true
    saved_vis = {}
    local ours = ours_addr_set()
    local n = try(function() return cached_parent:GetChildrenCount() end) or 0
    for i = 0, n - 1 do
        local ch = try(function() return cached_parent:GetChildAt(i) end)
        if is_valid(ch) and not ours[addr(ch)] then
            local vis = try(function() return ch:GetVisibility() end)
            saved_vis[#saved_vis + 1] = { widget = ch, vis = vis or 0 }
            try(function() ch:SetVisibility(1) end) -- Collapsed
        end
    end
    last_status = nil -- force row refresh
    apply_pending_rows()
    Log.info("menuinject: submenu OPENED (%d game rows hidden, %d mod rows)",
        #saved_vis, pending_lines and #pending_lines or 0)
end

local function close_submenu()
    if not submenu_open then return end
    submenu_open = false
    for _, e in ipairs(saved_vis) do
        if is_valid(e.widget) then
            try(function() e.widget:SetVisibility(e.vis) end)
        end
    end
    saved_vis = {}
    for _, row in ipairs(status_rows) do
        if is_valid(row) then try(function() row:SetVisibility(1) end) end
    end
    last_status = nil
    Log.info("menuinject: submenu CLOSED (main menu restored)")
end

-- Full reset when the menu widget got destroyed (e.g. a mission loaded).
local function reset_all()
    injected = nil
    cached_screen, cached_template, cached_parent = nil, nil, nil
    status_rows, row_texts = {}, {}
    saved_vis = {}
    submenu_open = false
    last_status = nil
end

-- ------------------------------------------------------------- activation

local function activate_open()
    ExecuteInGameThread(function()
        open_submenu()
        if on_activate then on_activate() end
    end)
end

local function activate_row(i)
    local text = row_texts[i]
    if not text then return end
    local first = text:sub(1, #"▶")
    if first ~= "▶" and first ~= "◀" then return end -- informational row
    Log.info("menuinject: row activated: %s", text)
    ExecuteInGameThread(function()
        if first == "◀" then close_submenu() end
        if on_row_click then on_row_click(text) end
    end)
end

-- widget -> which of ours it is: "entry" | row index | nil.
local function classify(this_name)
    local function matches(widget)
        if not is_valid(widget) then return false end
        local path = full_name(widget):gsub("^%S+%s+", "")
        return this_name == path or this_name:find(path, 1, true) ~= nil
    end
    if matches(injected) then return "entry" end
    for i, row in ipairs(status_rows) do
        if row_texts[i] and matches(row) then return i end
    end
    return nil
end

-- Hook the click functions once. Every observed click is logged (de-duped)
-- so on-device logs show whether clicks reach cloned widgets at all.
local function hook_clicks()
    if click_hooked then return end
    local any = false
    for _, hook_path in ipairs(CANDIDATES.click_paths) do
        local ok = pcall(function()
            RegisterHook(hook_path, function(Context)
                local this = Context:get()
                if not this:IsValid() then return end
                local this_name = full_name(this)
                if this_name ~= last_click_log then
                    Log.discover("menuinject: click seen on %s", this_name)
                    last_click_log = this_name
                end
                local what = classify(this_name)
                if what == "entry" then
                    Log.info("menuinject: ROGUELIKE entry clicked")
                    activate_open()
                elseif type(what) == "number" then
                    activate_row(what)
                end
            end)
        end)
        if ok then
            any = true
            Log.discover("menuinject: click hook on %s", hook_path)
        end
    end
    click_hooked = any
    if not any then
        Log.discover("menuinject: no click hook resolved — focus dwell is the "
            .. "only activation path")
    end
end

-- Focus/hover watcher: the activation path that is CONFIRMED working on the
-- Steam Deck. Holding focus (gamepad) or hover (mouse) on the ROGUELIKE entry
-- or on a ▶/◀ row for the dwell time activates it.
local function focused(widget)
    return try(function() return widget:IsHovered() end)
        or try(function() return widget:HasKeyboardFocus() end)
        or try(function() return widget:HasFocusedDescendants() end)
end

local dwell_target, dwell_ticks, dwell_fired = nil, 0, false
local function start_watcher()
    if watcher_started then return end
    watcher_started = true
    pcall(function()
        LoopAsync(250, function()
            if not is_valid(injected) then
                watcher_started = false
                reset_all()
                return true -- attempt loop re-injects on the next pass
            end
            -- Which of our widgets has focus right now?
            local target = nil
            if focused(injected) then
                target = "entry"
            elseif submenu_open then
                for i, row in ipairs(status_rows) do
                    if row_texts[i] and is_valid(row) and focused(row) then
                        target = i
                        break
                    end
                end
            end
            if target ~= dwell_target then
                dwell_target, dwell_ticks, dwell_fired = target, 0, false
                -- Report the highlighted row so the UI can fill its detail
                -- panel, the way the game's own Mission Select describes the
                -- mission you are pointing at.
                local text = (type(target) == "number") and row_texts[target] or nil
                if text ~= focused_text then
                    focused_text = text
                    if on_row_focus then
                        ExecuteInGameThread(function() on_row_focus(text) end)
                    end
                end
            elseif target ~= nil and not dwell_fired then
                dwell_ticks = dwell_ticks + 1
                local need = (target == "entry") and DWELL_OPEN_TICKS
                    or DWELL_ROW_TICKS
                if dwell_ticks >= need then
                    dwell_fired = true
                    if target == "entry" then
                        if not submenu_open then
                            Log.info("menuinject: ROGUELIKE focused — opening submenu")
                            activate_open()
                        end
                    else
                        activate_row(target)
                    end
                end
            end
            return false
        end)
    end)
end

-- ------------------------------------------------------------- API

-- Called every second by main.lua with ui.compact_lines(). Rows only render
-- while the submenu is open; otherwise the lines are stored for later.
function Menuinject.set_status_lines(lines)
    pending_lines = lines
    apply_pending_rows()
    return submenu_open
end

-- Register the ▶/◀ row activation handler: cb(row_text).
function Menuinject.set_row_callback(cb)
    on_row_click = cb
end

-- Register the highlight handler: cb(row_text) whenever focus moves.
function Menuinject.set_focus_callback(cb)
    on_row_focus = cb
end

function Menuinject.is_open()
    return submenu_open
end

-- Stay in the submenu but re-render its rows, used when BACK steps from the
-- floor list up to the start/continue screen rather than closing outright.
function Menuinject.reopen()
    if not submenu_open then
        open_submenu()
    else
        last_status = nil
        apply_pending_rows()
    end
end

function Menuinject.close()
    close_submenu()
end

-- Is the entry both alive AND still hanging in the menu list? A widget can
-- stay valid after being detached, which is exactly how the entry once went
-- missing while the mod believed it was fine.
local function injected_is_attached()
    if not is_valid(injected) then return false end
    if not is_valid(cached_parent) then return false end
    local idx = try(function() return cached_parent:GetChildIndex(injected) end)
    return type(idx) == "number" and idx >= 0
end

-- One injection attempt. Returns true when done (stops the retry loop).
local function attempt()
    if injected_is_attached() then return true end
    if is_valid(injected) then
        Log.warn("menuinject: ROGUELIKE entry lost its place in the menu — "
            .. "rebuilding it")
    end
    reset_all()

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
    local template
    for _, prop in ipairs(CANDIDATES.entry_props) do
        local t = try(function() return screen[prop] end)
        if is_valid(t) then
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
    Log.discover("menuinject: entry template class: %s",
        full_name(template:GetClass()):gsub("^%S+%s", ""))

    -- Parent container of the entries (VerticalBox or similar panel).
    local parent = try(function() return template:GetParent() end)
    if not is_valid(parent) then
        Log.discover("menuinject: template has no reachable parent panel")
        return false
    end

    -- Spawn a sibling of the same class.
    local wbl = try(StaticFindObject, "/Script/UMG.Default__WidgetBlueprintLibrary")
    local owner = try(function() return template:GetOwningPlayer() end)
    local clone = wbl and try(function()
        return wbl:Create(screen, template:GetClass(), owner)
    end) or nil
    if not is_valid(clone) then
        Log.discover("menuinject: WidgetBlueprintLibrary.Create failed")
        return false
    end

    local added = try(function() return parent:AddChild(clone) end)
    if not added then
        Log.discover("menuinject: parent:AddChild failed (panel class: %s)",
            full_name(try(function() return parent:GetClass() end) or "?"))
        return false
    end

    -- Try to sit directly below CAMPAIGN REMIX. AddChild appends to the end,
    -- so the entry would have to be moved up — but the container here is
    -- HaloUIButtonContainer, whose ordering API is unknown.
    --
    -- Reordering is therefore attempted ONLY with non-destructive calls. An
    -- earlier version fell back to RemoveChild + InsertChildAt; the insert
    -- failed, the remove had already happened, and the ROGUELIKE entry
    -- vanished from the menu entirely (on-device 2026-07-29, "got -1").
    -- Being one row lower is a cosmetic flaw; losing the entry is not.
    local want = try(function() return parent:GetChildIndex(template) end)
    if type(want) == "number" and want >= 0 then
        want = want + 1
        local moved = try(function()
            parent:ShiftChild(want, clone) return true
        end) or try(function()
            parent:ShiftChild(clone, want) return true
        end)
        local now = try(function() return parent:GetChildIndex(clone) end)
        -- Whatever happened above, the entry MUST still be in the list.
        if type(now) ~= "number" or now < 0 then
            try(function() parent:AddChild(clone) return true end)
            now = try(function() return parent:GetChildIndex(clone) end)
            Log.discover("menuinject: re-attached entry after a failed move")
        end
        Log.discover("menuinject: position -> wanted %d, at %s (move=%s, panel=%s)",
            want, tostring(now), moved and "ok" or "unavailable",
            full_name(try(function() return parent:GetClass() end) or "?")
                :gsub("^%S+%s", ""))
        -- Log the container's own API once, so the right ordering call can be
        -- found instead of guessed: HaloUI is not in the reflection dumps.
        if not moved then
            local cls = try(function() return parent:GetClass() end)
            local fns = {}
            if cls then
                pcall(function()
                    cls:ForEachFunction(function(fn) fns[#fns + 1] = fstr(fn:GetFName()) end)
                end)
            end
            Log.discover("menuinject: container functions: %s",
                #fns > 0 and table.concat(fns, ", ") or "(none exposed)")
        end
    end

    hook_clicks()
    set_label(clone, "ROGUELIKE")
    try(function() clone:SetIsFocusable(true) end)
    try(function() clone:SetVisibility(0) end) -- 0 = ESlateVisibility::Visible
    cached_screen, cached_template, cached_parent = screen, template, parent

    injected = clone
    start_watcher()
    Log.info("menuinject: ROGUELIKE entry injected into the main menu")
    return true
end

-- Start polling for the menu. `activate_cb` fires when the submenu opens.
function Menuinject.start(activate_cb)
    on_activate = activate_cb
    local tries = 0
    local ok = pcall(function()
        LoopAsync(5000, function()
            tries = tries + 1
            try(attempt)
            -- Menus get recreated (e.g. returning from a mission), so never
            -- fully stop; the attempt() guard makes re-checks cheap.
            if tries > 720 then return true end -- give up after ~1h
            return false
        end)
    end)
    if not ok then
        Log.warn("menuinject: LoopAsync unavailable; native menu entry disabled")
    end
end

return Menuinject
