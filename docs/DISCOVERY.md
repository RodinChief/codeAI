# Discovery playbook — resolving the game-API unknowns

The brief (§7) lists six things that cannot be determined statically and must
come from a running game. The mod is built so that **one instrumented
playtest** answers most of them: every hook attempt, resolved object and
launch attempt is logged to `UE4SS.log`, and the log is readable from outside
the game.

Milestone gate (brief §8.2): the go/no-go for the whole project is launching a
Remix mission at a chosen rally point, on a chosen difficulty, with Iron
active, **from Lua**. Steps 1–4 below get you to that attempt.

## Step 0 — static pass (Distrobox)

```bash
./tools/strings_discovery.sh
```

Writes greps of the exe/dll into `./discovery-out/`: skull names, trait
enums, launch-ish symbol names, the build string. Use these to extend the
candidate lists before ever starting the game. If FModel + the community
`.usmap` (Nexus) is available, also look at:

- `Meteorite/Content/UI/Shared/Settings/Widgets/WBP_DifficultyModifierMenu.uasset`
- `Meteorite/Content/UI/Shared/Settings/Data/DA_DifficultyModifierSettingsItems.uasset`
- `Meteorite/Content/Tags/multiplayer/game_variant_settings/player_traits_template/`

## Step 1 — dynamic pass (one playtest)

1. Launch the game with the mod installed. Reach the main menu.
2. Press `F7` — the mod logs a targeted discovery report (instances of every
   candidate class, plus the build version).
3. Open the UE4SS GUI and run its **object dumper** (Dump Objects) for the
   full UObject dump.
4. Manually deploy a Campaign Remix mission from the menu, play 30 seconds,
   die once, finish or quit the mission.
5. Collect `UE4SS.log` + the object dump.

## Step 2 — mine the dump

```bash
grep -iE 'InsertionPoint|RallyPoint|Skull|Campaign|Remix|StartMission|Deploy' ObjectDump.txt
grep -iE 'HaloUserSettings|ModifierPreset|PlayerTraits' ObjectDump.txt
grep -iE 'MissionComplete|MissionFinished|OnDeath|PlayerDeath' ObjectDump.txt
```

You're looking for, in priority order:

| # | Unknown | What to find | Where it goes |
|---|---|---|---|
| 1 | Mission launch call | a UFunction taking mission + insertion point + difficulty (+ skulls) | `gameapi.lua` → `CANDIDATES.mission_launcher_class` / `mission_launch_fn`, and the arg shape in `Gameapi.launch_floor` |
| 2 | Skull identifiers | enum values / names / gameplay tags for all 42 skulls | `const.lua` → `SKULL_POOL` ids (+ `MANDATORY_SKULLS`), mark `verified = true` |
| 3 | Remix deploy path | how the visibility roll fires; can it be forced? | `Gameapi.launch_floor`; if forceable, honor `floor.visibility`, else treat the roll as display-only |
| 4 | Mission-complete event | a hookable UFunction that fires exactly once on completion | `CANDIDATES.mission_complete_hooks` |
| 5 | Death event | ditto for player death / rally-point reload | `CANDIDATES.player_death_hooks` |
| 6 | Live `HaloUserSettings` | full object path; confirm property writes stick without restart | `CANDIDATES.user_settings_class`; verify with the modifier menu open |

The **HCEDebugMenu mod (Nexus 14)** drives missions, insertion points and
skulls from a shipping build — read its Lua before inventing anything: its
call sites likely answer #1 and #2 outright.

Also confirm on-device (cheap while you're there):

- real rally-point lists per mission (`const.lua` `MISSIONS[].rally` — which
  missions actually have a Delta?);
- the three prequel/bonus mission ids (then flip
  `config.include_bonus_missions`);
- whether `ModifierPreset ~= None` really blocks achievements
  (`BlamAchievementDefinition.bBlockedByDifficultyModifiers` — assumed true).

## Step 3 — update the code

All game knowledge is concentrated in two files by design:

- `Scripts/gameapi.lua` — the `CANDIDATES` table at the top, plus the call
  shape in `launch_floor` / `apply_nerf_preset`.
- `Scripts/const.lua` — missions, rally lists, skull pool, known builds.

Nothing else in the mod should need to change when names are corrected.

## Step 4 — verify the gate

With candidates filled in, from the main menu: `F6` → `F5` (new run) → `F5`
(confirm) → `F5` (start floor). Success = the Remix mission loads at the floor
card's rally point and difficulty with Iron active, and `UE4SS.log` shows
`gameapi: launch request` followed by no failure. Then verify:

- die once → `state: death 1/8` in the log, counter updates;
- finish the mission → `state: floor 1 complete`, floor 2 card revealed;
- restart the game mid-run → run resumes at the same floor (briefing state).

## Menu injection (native "ROGUELIKE" entry)

`Scripts/menuinject.lua` clones one of the game's own main-menu entry widgets
at runtime and relabels it ROGUELIKE — native look without building UMG
assets. It needs three names confirmed from a **widget dump taken while the
main menu is on screen**:

```bash
grep -iE 'WBP_.*(MainMenu|FrontEnd|Title)' ObjectDump.txt      # screen widget
grep -iE 'WBP_.*(Button|Entry|Nav)' ObjectDump.txt             # entry widget
```

| Needed | Where it goes in `menuinject.lua` |
|---|---|
| Menu screen widget class | `CANDIDATES.menu_screen` |
| Menu entry widget class (the buttons in the list) | `CANDIDATES.menu_entry` |
| The entry's click UFunction | `CANDIDATES.entry_click_fns` |
| The entry's TextBlock child name | `CANDIDATES.entry_label_widgets` |

The module logs each stage (`grep 'menuinject' UE4SS.log`): screen found →
template found → clone added → label set → click hooked. Whatever stage it
stops at tells you which candidate list to extend. Until everything resolves
it does nothing visible and F6 stays the entrance.

Known limits: the entry may land at the bottom of the list instead of after
CAMPAIGN REMIX if the panel class has no runtime `ShiftChild`; controller
focus/navigation order is owned by the game's own focus system and may skip
the injected entry (mouse/touch click still works) — fixing that needs the
focus-handling function, same discovery method.

## Hook-writing notes

- Register hooks with `RegisterHook("/Script/Module.Class:Function", fn)`;
  wrap game-thread work in `ExecuteInGameThread`.
- The death fallback hook (`PlayerController:ClientRestart`) also fires on the
  initial spawn — `main.lua` already swallows the first event per floor. If a
  real death event is found, that debounce becomes unnecessary but is harmless.
- Post-mission native screens still show (accepted for v1, brief §9).
- If the fork exposes Lua ImGui bindings, the overlay upgrades automatically
  (`ui.lua` checks for a global `ImGui`); adapt `imgui_render` to the binding's
  real shape. Until then the text backend renders the same panel to the UE4SS
  console.
