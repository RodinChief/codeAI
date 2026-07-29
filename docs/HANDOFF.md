# Halo Campaign Evolved — Roguelike: handoff

Everything learned and built so far, written so another session can pick this
up cold. Branch: `claude/halo-campaign-evolved-mod-ber2my` on
`RodinChief/codeAI`.

Read §4 (Hard rules) before writing a single line of reflection code. Two of
the crashes below were caused by ignoring things that are now written down
there.

---

## 1. What this is

A UE4SS Lua mod adding a **5-floor roguelike run mode** to *Halo: Campaign
Evolved*, built on top of Campaign Remix.

Per run:

- 5 floors, each a **random mission + random rally point** from a seed.
- Difficulty ladder: floors 1–3 Normal → Heroic → Legendary, floors 4–5
  Legendary **+ nerf preset**.
- **Mandatory skulls, always on: Iron, Reload, Adaptation.**
  (Armistice was explicitly removed from this set by the user.)
- **1–2 extra skulls rolled per floor**, accumulating across the run, drawn
  from *every* skull the game can activate — goofy ones included.
- One **visibility modifier** per floor (default / SporeVisibility /
  NightVision / LightsOut).
- Fog of war: floors past the current one render as `FLOOR n — ???`.
- Death cap 8; run is lost on reaching it.
- Save is backed up before a run and restored on exit.

Everything is driven from a native **ROGUELIKE** entry in the main menu,
sitting directly under CAMPAIGN REMIX. No F-keys required (they still exist as
fallbacks).

## 2. Environment

| | |
|---|---|
| Device | Steam Deck, SteamOS, game under Proton |
| Game dir | `/run/media/deck/SN512/steamapps/common/Halo Campaign Evolved` |
| Game internals | "Meteorite" — 343's UE **5.5.4** fork |
| Build string | `2026.06.26.1097863.1-Rel-i343-Meteorite-2606-CU2` |
| Loader | **HCE-specific UE4SS 3.0.1 fork** (Nexus mod 9). Stock UE4SS does not start on this game. |
| Mod path | `Meteorite/Binaries/Win64/ue4ss/Mods/HaloRoguelike/` |
| Log | `Meteorite/Binaries/Win64/ue4ss/UE4SS.log` |
| Mod save dir | `<LOCALAPPDATA>/Meteorite/Saved/HaloRoguelike` |

Install with `tools/install.sh` from the repo root. Offline test suite:
`lua tests/run_tests.lua` (~12,400 checks, must stay green).

Also present and enabled in this install, which matters for the skull work:
`HCEConsoleCommandsMod` (logs *"Meteorite ULocalPlayer::Exec bridge active"*),
`HCEConsoleEnablerMod` (console on Tilde / F10), and `CheatManagerEnablerMod`
(*"Enabled CheatManager"*).

## 3. Current status

### Working, verified on device

- Native **ROGUELIKE** menu entry, positioned **directly under CAMPAIGN
  REMIX** (`menuinject: position under CAMPAIGN REMIX -> ok (moved)`).
- Submenu screens: root (START NEW RUN / CONTINUE PREVIOUS RUN) →
  confirm → floor select with a fixed-height detail panel → summary.
- **Press to activate** — A / Enter / mouse click, via the game's own button
  group. Hovering does nothing.
- **Mission launching** with the real campaign API.
- **Rally points** apply correctly.
- Difficulty applies correctly.
- Run generation, seeding, fog of war, death counting, save backup/restore,
  content versioning — all covered by the offline test suite.

### Not working

- **Skulls.** The run's skull set is not applied; the game runs its own
  default (the user consistently sees Iron + Black Eye). This is the single
  open feature and §6 is entirely about it.
- **Floor completion is manual** — no mission-complete hook has been found, so
  the player presses a `MARK FLOOR COMPLETE` row.
- **Save backup is a no-op on this install**: `saveguard: no SaveGames
  directory found at C:\users\steamuser\AppData\Local\Meteorite\Saved\SaveGames`,
  so runs start with backup id `NO_SAVE`. Either the game keeps saves
  elsewhere under Proton or the directory does not exist until first save.
  **Worth checking before anyone plays a run they care about.**

### Never started

- Floor artwork / images beside the floor list (the user asked for these).
- Turning cutscenes off (the user asked for this).

## 4. Hard rules — read before touching reflection

These came from crashing the user's game. Both were native access violations:
no Lua error, no `pcall` return, the process simply ends and the log stops
mid-line.

> ### Never build a struct from a Lua table if it has custom `CppStructOps`.
>
> `lib:MakeLiteralGameplayTag({ TagName = "Skull.Iron" })` **killed the game
> instantly.** `FGameplayTag` and `FGameplayTagContainer` carry custom struct
> ops and UE4SS's generic table-to-struct path writes through them wrongly.
>
> This is *not* a blanket rule about structs — `FBlamScenarioGameOptions`
> marshals from a plain Lua table fine, which is why difficulty and insertion
> point work. Plain-data structs are OK; ones with custom ops are not.

> ### Never index a container whose length you could not read.
>
> `describe_container` fell through to `ipairs(v)` on
> `DA_FirstPlayableCampaign.ScenarioList`, which comes back as an opaque
> `TrivialObject`. **Killed the game.** If neither `#v` nor `v:GetArrayNum()`
> answers, stop — do not guess the element type.

> ### Read, then hand back. Never construct.
>
> A struct value read from a game object can be passed to another engine call
> safely (it is a pointer copy). Anything you assemble in Lua is a risk.

> ### Scalars are safe.
>
> numbers, bools, `FName`, `FString` all marshal cleanly in both directions.
> Every remaining skull attempt is built on this.

> ### `pcall` does not protect you.
>
> It catches Lua errors, not access violations. A wrapped call is not a safe
> call.

Two smaller traps, both real:

- **`scan_multi` skips `Function ` objects.** It filters out any object whose
  full name starts with `Class `, `Function ` or
  `WidgetBlueprintGeneratedClass `. This is why no skull-setting UFunction
  ever appeared in six rounds of dumps. `Gameapi.dump_skull_api` exists
  specifically to scan for those.
- **A UFunction's bool return is not `pcall`'s ok flag.**
  `SetAndBeginCampaign` returns `bool`; for a long time the code treated
  "pcall succeeded" as "launch succeeded" and logged `-> OK` for launches the
  engine had refused.

## 5. Confirmed game API

Everything here was read off a live game, not guessed.

### Launching a mission

```
UBlamCampaignFlowGameSubsystem::SetAndBeginCampaign(
    const UBlamCampaignDataAsset* Campaign,
    const FName StartingScenarioName,
    const FBlamScenarioGameOptions& Options) -> bool
```

```cpp
struct FBlamScenarioGameOptions {
    bool  bLoadFromCoreSave;                            // 0x00
    uint8 SaveSlot;                                     // 0x02
    FString SavedFilmName;                              // 0x08
    EBlamCampaignDifficultyLevel CampaignDifficultyLevel; // 0x18  ✅ applies
    int32 InsertionPoint;                               // 0x1C  ✅ applies
    TSet<EBlamGameSkulls> ActiveSkulls;                 // 0x20  ❌ never lands
    bool  bFriendlyFireEnabled;                         // 0x70
    bool  bIsLASO;                                      // 0x71  (untried)
    UBlamGameEngineBaseVariant* GameVariant;            // 0x78
};
```

- Campaign asset: **`/Game/Blueprints/Campaign/DA_FirstPlayableCampaign.DA_FirstPlayableCampaign`**.
  Not `DA_TestMapsCampaign` — an early scan picked that one, the launch
  returned OK and loaded nothing.
- Its properties: `CampaignGuid:StructProperty`, `ScenarioList:ArrayProperty`,
  `CampaignType:EnumProperty`. **Do not walk `ScenarioList`** (see §4).
- `ActiveSkulls` is a `TSet` and UE4SS does not marshal one from a Lua table.
  The call still returns `true`; the skulls are simply dropped.

### Scenario ids

`pillar_of_autumn=a10, halo=a30, truth_and_rec=a50, silent_cartographer=b30,
assault_ctrl_room=b40, guilty_spark=c10, library=c20, two_betrayals=c40,
keyes=d20, maw=d40`

Mission maps live at `/Game/Levels/Halo1/Solo/<ID>/<ID>`. Launching travels
through `/Game/Levels/Test/SeamlessTravelTEst` on the way in and out — do not
mistake that for "back in the menus".

### Rally points / insertion points

`InsertionPoint` is a 0-based int: Alpha=0, Bravo=1, Charlie=2, Delta=3.

They are **per-scenario and gated by campaign progress**, so a valid-looking
index can be refused — and a roguelike run starts from a fresh save. Insertion
point data assets exist per mission and were seen at runtime:

```
/Game/Levels/Halo1/Solo/<ID>/DA_<ID>_InsertionPoints   (ScenarioInsertionPointAsset)
  → property: InsertionPoints:ArrayProperty
```
Seen for A15, A30, A50, B30, B40, C10, C20, C45, D20, D40, E10, E20, E30.
**Reading that array has not been attempted and must follow the §4 rules.**

`launch_floor` handles refusal by walking the rally point down (Charlie →
Bravo → Alpha) until one is accepted, and records what actually ran.

Also relevant, untried:
`UMeteoriteUIStatics::IsInsertionPointLocked(APlayerController*, const FBlamScenarioDataTableRow&, int32)`.

### Enums

- **`/Script/BlamGlue.EBlamGameSkulls`** — 59 members (56 real + `None=255`,
  `Num=56`, `_MAX=256`). NOT under `/Script/BlamEngine`.
  Iron=0, BlackEye=1, ToughLuck=2, Catch=3, Fog=4, Famine=5, Thunderstorm=6,
  Tilt=7, Mythic=8, Assassin=9, Blind=10, Cowbell=11, GruntBirthdayParty=12,
  IWHBYD=13, CustomRed=14, CustomYellow=15, CustomBlue=16, Angry=17,
  Bandana=18, BondedPair=19, Boom=20, Envy=21, EyePatch=22, Foreign=23,
  Ghost=24, GruntFuneral=25, Jacked=26, Malfunction=27, Masterblaster=28,
  Pinata=29, Recession=30, Scarab=31, SoAngry=32, Swarm=33, ThatsJustWrong=34,
  TheyComeBack=35, BootsOffTheGround=36, Adaptation=37, Reload=38,
  SporeVisibility=39, NightVision=40, LightsOut=41, Riskrun=42, Pop=43,
  Armistice=44, EnduranceSpec=45, GiveAndTake=46, StowAndGrow=47, HipFire=48,
  Temperamental=49, FloorIsLava=50, Magnified=51, JohnnyAmmoTree=52,
  Leadhead=53, Efficient=54, ThirdPerson=55
- **`/Script/BlamGlue.EBlamCampaignDifficultyLevel`** — Easy=0, Normal=1,
  Heroic=2, Legendary=3.
- Members come back **fully qualified**: `EBlamGameSkulls::Iron`. Strip the
  `EnumName::` prefix before matching, or nothing matches.

### Skulls in a live mission

```
BlamSkullsGameStateComponent
  (at /Game/Levels/Halo1/Solo/<ID>/<ID>:PersistentLevel
      .BP_MeteoriteGameState_C_*.BlamSkullsGameStateComponent)

  ActiveSkulls : StructProperty  →  FGameplayTagContainer   (NOT a TSet)
  OnSkullsAdded   : MulticastInlineDelegateProperty
  OnSkullsRemoved : MulticastInlineDelegateProperty
  callable functions: NONE (only the two delegate signatures)
```

So in-mission skulls are **gameplay tags**, while the launch options take
**enum values**. Something converts between them and that converter has not
been found.

`BlamSkullGlobalsTagDataAsset` (`/Script/BlamSynchronization.Default__…`) was
the obvious candidate for the enum→tag map. **It is a dead end:** its property
list is empty and it exposes no functions.

`UBlueprintGameplayTagLibrary` exposes:
`AddGameplayTag, AppendGameplayTagContainers, BreakGameplayTagContainer,
Conv_ObjectToGameplayTagAssetInterface, DoesContainerMatchTagQuery,
DoesTagAssetInterfaceHaveTag, EqualEqual_GameplayTag,
EqualEqual_GameplayTagContainer, GetAllActorsOfClassMatchingTagQuery,
GetDebugStringFromGameplayTag, GetDebugStringFromGameplayTagContainer,
GetNumGameplayTagsInContainer, GetOwnedGameplayTags, GetTagName, HasAllTags,
HasAllMatchingGameplayTags, HasAnyTags, HasTag, IsGameplayTagValid,
IsTagQueryEmpty, MakeGameplayTagContainerFromArray,
MakeGameplayTagContainerFromTag, MakeGameplayTagQuery*,
MakeLiteralGameplayTag, MakeLiteralGameplayTagContainer, MatchesAnyTags,
MatchesTag, NotEqual_*, RemoveGameplayTag`

Of these:
- `MakeLiteralGameplayTag({TagName=…})` — **crashes the game.**
- `MakeGameplayTagContainerFromArray(luaTable)` — fails with
  `UFunction expected 2 parameters, received 2`; cannot marshal
  `TArray<FGameplayTag>` from Lua.
- `BreakGameplayTagContainer` — out-param array comes back `nil` under every
  convention tried.
- `GetDebugStringFromGameplayTagContainer` / `GetNumGameplayTagsInContainer`
  — scalar returns, **these are the safe way to read a container.**

### Other confirmed bits

- `UHudGlobalDataSubsystem.GameInfo` is `FGameInfo { bValid,
  CampaignDifficultyLevel, ModifierPreset, TSet<EBlamGameSkulls> ActiveSkulls }`
  — the HUD's mirror of the skull set. A read here would confirm whether the
  launch TSet landed, but reading a `TSet` is exactly the §4 risk.
- `UMeteoriteUIStatics::Debug_IsSkullLocked(EBlamGameSkulls)` exists — proof a
  debug skull API exists somewhere.
- `WBP_MainMenu_C` contains debug widgets named **`LockAllSkulls`**,
  **`UnlockAllSkulls`**, **`LockAllInsertionPoints`**.
- Menu container is `/Script/HaloUI.HaloUIButtonContainer`, functions:
  `AddChildToButtonContainer, ReplaceButtonContainerChildAt, SetInitialFocus,
  SelectInitialChild, SelectPreviousButton, SelectNextButton,
  HandleButtonGroupSelectionChanged, GetSelectedButton, GetFirstChild,
  GetLastChild, GetFocusableWidget, OnFocusChanged__DelegateSignature`.
  No reorder call, and `UPanelWidget::ShiftChild` is not BlueprintCallable.
- Menu row widget class:
  `/Game/UI/Shared/Widgets/Buttons/WBP_MeteoriteStandaloneButtonDefault_C`.
  Label via `SetButtonLabelText(FText)`.
- Clicks route through `/Script/CommonUI.CommonButtonBase:HandleButtonClicked`
  and `:HandleButtonPressed`. **One physical press fires both** — debounce.
- No mission-complete hook found. Tried and absent:
  `CampaignMissionState:OnMissionComplete`,
  `HaloCampaignSubsystem:MissionCompleted`,
  `BlamGameMode:HandleMissionComplete`.
- Death is detected via `/Script/Engine.PlayerController:ClientRestart`, which
  also fires on the initial spawn and on world transitions — both are filtered.
- `RegisterLoadMapPostHook` only fired for the **first** world. World changes
  are detected by polling once a second instead.

## 6. The skull problem — full state

**Symptom:** the run asks for e.g. `[Iron, Reload, Adaptation, Pop,
JohnnyAmmoTree, NightVision]`, the launch logs
`SetAndBeginCampaign("c20", {diff=1, rally=1, with skulls}) -> returned true`,
and in-game the player has Iron + Black Eye.

**Routes tried and their outcomes:**

| Route | Outcome |
|---|---|
| `ActiveSkulls` TSet in the launch options | Silently dropped; UE4SS cannot marshal a `TSet` from a Lua table |
| Write enum values onto `BlamSkullsGameStateComponent.ActiveSkulls` | `Can't copy struct of type None into GameplayTagContainer` — it is a tag container, not a TSet |
| `MakeGameplayTagContainerFromArray` from a Lua table | `UFunction expected 2 parameters, received 2`, 0/6 tags |
| `MakeLiteralGameplayTag` per tag, then `AddGameplayTag` | **Crashed the game** |
| Prefix probe via `IsGameplayTagValid` | Never ran — needs `MakeLiteralGameplayTag`, which crashes |
| `BlamSkullGlobalsTagDataAsset` as an enum→tag source | Empty; no properties, no functions |

**What is in the current build (61fbe60), untested on device:**

`Gameapi.dump_skull_api()` scans `ForEachUObject` for every object whose full
name starts with `Function ` and mentions skull/LASO, and logs each with its
full parameter list as `SKULLAPI` lines. Pure reflection. **This is the dump
that has never existed** — `scan_multi` was filtering these out all along.

`Gameapi.set_skulls_via_functions(values, ids)` then calls the ones that are
safe: name reads like a setter (`Get`/`Is`/`Has`/`Can`/`Debug_Is` excluded by
prefix), all parameters scalar, `ReturnValue` not counted as an input, 1–2
inputs, live instance preferred over CDO. Falls back to
`APlayerController::ConsoleCommand(FString, bool)` — strings only.

Runs at init (menu) and again ~10s into a mission, since most skull classes
are not loaded while the menu is up.

**Next step: get the log from one floor and read the `SKULLAPI` lines.** They
list every skull function the build exposes, with signatures. Either it
already worked (`skulls: VERIFIED — every skull the run asked for is active`)
or those lines say exactly which call to make.

**If `SKULLAPI` comes back empty**, remaining ideas in rough order of promise:

1. **Drive the game's own skull picker.** Campaign Remix has skull selection
   in its menu; `LockAllSkulls` / `UnlockAllSkulls` widgets are already in
   `WBP_MainMenu_C`. Setting skulls through the game's own UI uses the game's
   own code and constructs nothing. Needs a widget dump of that screen (F7
   while it is open).
2. **Hook `SetAndBeginCampaign` and mutate the params.** A `RegisterHook` pre
   callback gets the real, game-built options struct — including a properly
   constructed `ActiveSkulls`. Whether UE4SS lets you add to a `TSet` through
   a param wrapper is unknown but it is at least the right object.
3. **Get a dump of the `BlamSynchronization` module.** Only `BlamEngine` and
   `Meteorite` were ever dumped (`discovery/dumps/cxx/`), and the skull
   component lives in `BlamSynchronization`. Use `tools/collect_dumps.sh` /
   the UE4SS CXX dumper.
4. **`bIsLASO = true`** — a plain bool in a struct that already marshals, so it
   will work. Turns on *all* skulls, which breaks the per-floor progression.
   A blunt last resort, not a fix.

## 7. Architecture

```
Mods/HaloRoguelike/Scripts/
  main.lua        555  entry point, keybinds, world watcher, floor flow, wiring
  gameapi.lua    1547  THE ONLY MODULE THAT TOUCHES GAME OBJECTS
  menuinject.lua  789  the native ROGUELIKE entry + submenu
  ui.lua          450  view model: panel lines + in-menu row lines
  state.lua       220  run state machine, save/load, content versioning
  const.lua       157  missions, skulls, difficulty ladder, known builds
  saveguard.lua   140  campaign save backup/restore
  rungen.lua      121  deterministic run generation from a seed
  paths.lua       100  LOCALAPPDATA path resolution
  json.lua        170  vendored
  rng.lua          92  seeded RNG
  presets.lua      38  nerf preset description
  config.lua       67  user-tweakable settings
tests/run_tests.lua  402  ~12,400 offline checks
docs/     BRIEF.md DISCOVERY.md DUMPS.md INSTALL.md HANDOFF.md
tools/    install.sh collect_dumps.sh strings_discovery.sh
discovery/dumps/  cxx/{BlamEngine,Meteorite}.hpp, luatypes/, enums.md
```

**All game-object access goes through `gameapi.lua`.** Keep it that way — it
is what made the crash post-mortems tractable.

### `menuinject.lua`

Clones `WBP_MeteoriteStandaloneButtonDefault_C` (template taken from
`screen.RemixButton`) and adds it via `AddChildToButtonContainer`, which makes
it a real member of the menu's button group — that is what makes presses work.

Ordering: the container has no reorder call and `ShiftChild` is unreachable,
so `place_under()` rotates the rows *after* Campaign Remix to the back using
remove-then-add (adding appends). The child list is snapshotted first and
anything that drops out is re-appended — an earlier destructive version made
the ROGUELIKE entry vanish entirely.

Submenu = collapse the game's own rows (saving visibility), show the mod's
rows in their place, restore on BACK. Row prefixes are the contract:
`▶ ` selectable, `◀ ` back, anything else informational (not focusable, not
interactive).

Guards worth keeping:
- `PRESS_GUARD_TICKS` — one press fires both hooked handlers.
- `rows_generation` — dwell/focus state resets when the row set is re-rendered.
- `locked_target` — a row that fired cannot fire again until focus leaves it.
- `Menuinject.suspend(ms)` — no activation while a launch is in flight.

### `ui.lua`

Modes are one shared set across both renderers: `menu`, `confirm_new_run`,
`floors`, `summary`, normalised through `effective_mode()`. A mode only one
renderer knew about produced an empty panel *and* a row list that changed
length under the player's focus.

## 8. Bug history

Worth skimming — several of these are the kind that recur.

| Bug | Cause | Fix |
|---|---|---|
| Launch "OK" but nothing loads | Wrong campaign asset (`DA_TestMapsCampaign`) | Pin `DA_FirstPlayableCampaign` |
| Launch "OK" but nothing loads, again | `SetAndBeginCampaign`'s bool return never checked | Check it; walk the rally point down on refusal |
| Watchdog false positives (×2) | (a) LoadMap hook only fires for the first world (b) checked "is a mission loaded *now*" 45s later, after the player had finished | Poll the world; track `mission_seen_since_launch` |
| 0 of 5 skulls matched | Enum members come back as `EBlamGameSkulls::Iron` | Strip the `EnumName::` prefix |
| Enum not found | Guessed `/Script/BlamEngine` | It is `/Script/BlamGlue`; found by GUObjectArray scan |
| Stale run had a phantom skull id | Run saved before the id change | `Const.CONTENT_VERSION` guard in `State.load` |
| False death on quit to menu | `ClientRestart` fires on world transitions | Require a mission world |
| Pause menu dead in-mission | Mod rows left visible/focusable stole controller focus | Force-close the submenu on launch and every map change |
| ROGUELIKE entry vanished | `RemoveChild` + failed `InsertChildAt` | Non-destructive reorder + re-attach guard |
| Menu "glitched", activated rows by itself | `Ui.mode = "run"` — a screen neither renderer implemented, so the row list collapsed 15→3 under the focus | One shared mode set; dwell resets on re-render; press-only |
| Hovering a row activated it | Rows added with plain `AddChild` were outside the button group, so no press ever reached them; dwell was the workaround | `AddChildToButtonContainer` |
| **Game crash** | `ipairs` on an unreadable container (`ScenarioList`) | Never index without a length |
| **Game crash** | `MakeLiteralGameplayTag({TagName=…})` | Never build a custom-ops struct from Lua |
| `install.sh` Permission denied | `chmod 444` on Game.ini, no `chmod u+w` before rewrite | Fixed; step made non-fatal |

## 9. Reading a log

Useful greps in `UE4SS.log`:

| Pattern | Tells you |
|---|---|
| `SKULLAPI` | every skull UFunction and its signature |
| `skulls:` | what was set, what the mission actually has, VERIFIED or not |
| `launch: SetAndBeginCampaign` | scenario, difficulty, rally, and the real return value |
| `menuinject: position under CAMPAIGN REMIX` | whether the entry got moved |
| `menuinject: row activated` | which row the player pressed |
| `main: world changed ->` | world transitions |
| `ENUM skulls` | the live enum, in case it shifts after a game update |
| `PROPS` / `SKOBJ` / `SKFNS` | discovery dumps |

**A log that stops mid-line with no error is a native crash**, not a hang.
Whatever call is logged immediately before it is the culprit.

`F7` writes a full discovery dump. `F9` restores the save backup and works
even when the mod has refused to initialise.

## 10. Open items

1. **Skulls** (§6) — the one blocking feature.
2. **Verify save backup works.** `NO_SAVE` means there is no safety net.
3. **Floor artwork** beside the floor list — asked for, never started.
4. **Turn cutscenes off** — asked for, never started.
5. **Automatic floor completion** — needs a mission-complete signal; quitting
   and finishing currently look identical.
6. **Per-mission rally point counts.** All missions are listed as
   Alpha/Bravo/Charlie in `const.lua`; the real data is in the
   `DA_<ID>_InsertionPoints` assets.
