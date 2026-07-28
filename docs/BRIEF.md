# Halo: Campaign Evolved — Roguelike Mod

**Project brief for Claude Code**
Last updated: 2026-07-28

---

## 1. Goal

Build a UE4SS mod for *Halo: Campaign Evolved* that adds a roguelike run mode, selectable from the game's front-end. A run is 5 hidden "floors", each floor being a randomly chosen mission + rally point, with escalating difficulty and an accumulating skull pool.

**Scope for v1: ImGui overlay only.** Do NOT attempt a native UMG main-menu widget — see §9.

---

## 2. Target environment

| | |
|---|---|
| Hardware | Valve Steam Machine (Zen 4 6c/12t, RDNA 3, 16 GB DDR5, 8 GB VRAM) |
| OS | SteamOS 3 (Arch-based, **immutable root**) |
| Game runs via | Proton (Steam Deck Verified / SteamOS Compatible) |
| Steam AppID | `2806050` |
| Dev environment | Distrobox Ubuntu container with gamedir bind-mounted |

### Paths (Linux/Proton)

```
# Game install
~/.local/share/Steam/steamapps/common/Halo Campaign Evolved/
├── Engine/
├── DigitalExtras/
└── Meteorite/
    ├── Binaries/Win64/HaloCampaignEvolved.exe
    ├── Binaries/Win64/HaloSimulation_tag_release.dll
    ├── Binaries/Win64/ue4ss/            <- UE4SS install target
    │   ├── Mods/
    │   ├── UE4SS-settings.ini
    │   └── UE4SS_Signatures/
    └── Content/Paks/                    <- .pak / .utoc / .ucas, plus LogicMods/

# Wine prefix (this is where %LOCALAPPDATA% maps to)
~/.local/share/Steam/steamapps/compatdata/2806050/pfx/drive_c/users/steamuser/AppData/Local/Meteorite/Saved/Config/
├── Windows/
│   ├── GameUserSettings.ini
│   └── Game.ini                         <- create this; see §6.1
└── <SteamID64>/
    └── HaloGlobalGameUserSettings.ini   <- difficulty modifiers; see §6.2
```

### SteamOS gotchas

- Root FS is read-only. Do **not** rely on `steamos-readonly disable` — it reverts on OS update. Keep everything under `$HOME`.
- `strings`, `repak`, `retoc` are not present. Run them inside the Distrobox container.
- `repak` / `retoc` require an Oodle decompressor to do anything useful.
- UE4SS under Proton needs a DLL override passed as a Steam launch option. The Nexus split-screen mod (mod 53) documents the working Proton launch options — follow that page rather than guessing.

---

## 3. Game facts (verified)

- Engine: **custom 343 fork of Unreal Engine 5.5.4**. Build string: `5.5.4-2026.06.26.1097863.1-Rel-i343-Meteorite-2606-CU2`
- Project codename: **Meteorite** (`mtr` in the REST APIs)
- Blam ships as an Unreal plugin: `Engine/Plugins/i343/BlamEngine`
- 13 campaign missions (10 original CE + 3 prequel/bonus)
- **42 skulls total**: 39 collectible (3 per mission), plus Adaptation, Reload and Armistice which unlock automatically with Campaign Remix after finding any 3 skulls
- Difficulties: Easy / Normal / Heroic / Legendary. **There is no "Legendary+" tier** — LASO is a separate mode. See §6.2 for how to emulate escalation past Legendary.
- Skulls cannot be toggled mid-mission. Activating them requires Campaign → New Game, **which overwrites the current solo campaign save**. New Game still allows jumping to any unlocked mission and rally point.
- Modding posture: Halo Studios ships no official tools or Workshop support, but deliberately left no blockers in place.

### Critical: UE4SS requires the HCE-specific fork

Stock UE4SS does **not** work. The 343 fork changes the memory layout; stock pattern scans fail to locate `GUObjectArray` and UE4SS never starts. Use the fork from Nexus mod 9, which ships replacement `UE4SS-settings.ini` and `UE4SS_Signatures/*.lua`. Both must be overwritten — this is not optional.

---

## 4. Design spec

### Run structure
- 5 floors per run
- Each floor = one mission + one rally point
- 5 distinct missions, no repeats within a run
- Exactly **one** floor uses Rally Point Alpha; the other four use a later rally point (Bravo / Charlie / Delta)
- Future floors are hidden until the current floor is completed ("fog of war")

### Difficulty ladder
| Floor | Difficulty |
|---|---|
| 1 | Normal |
| 2 | Heroic |
| 3 | Legendary |
| 4 | Legendary + nerf preset |
| 5 | Legendary + nerf preset + extra skulls |

### Skulls
Permanently active for the whole run:
- **Iron** — death restarts the rally point
- **Adaptation** — randomises enemy factions
- **Reload** — randomises pre-placed weapons
- **Armistice** — enemy factions never fight each other

Per floor: **1–2 additional random skulls**, no duplicates across the run, and every skull gained stays active for all subsequent floors. Floor 1 therefore starts with the four mandatory skulls plus the first roll; floor 5 carries everything accumulated.

### Visibility modifier
One per floor, rolled independently, **not cumulative**:
- Default
- Spore Visibility
- Nightvision

### Loss / win
- Death → Iron restarts the rally point; increment death counter
- Run ends on quit, or when the configured death cap is hit (hardcore rule)
- Run is won by completing all 5 floors consecutively

### Fog of war
Player sees only: current mission, current rally point, current difficulty, newly gained skulls, current visibility modifier. Next floor is revealed on "Floor complete".

---

## 5. Architecture decision: build on Campaign Remix

**This is the single most important design choice. Do not build on the standard campaign.**

Campaign Remix already provides, for free:
- Adaptation, Reload and Armistice enabled by default in every Remix mission
- An automatic roll for one of two visibility modifiers (Spore Visibility or Nightvision) when deploying a Remix mission
- Randomised enemies and remixed weapon pickups

That covers 3 of the 4 mandatory skulls and the entire visibility modifier feature. The mod only needs to add Iron, add the rolled extra skulls, set difficulty, and manage floor state.

### Layers

**Layer 1 — UE4SS Lua runtime**
RNG, run state machine, hooks, ImGui UI. This is where essentially all the code lives.

**Layer 2 — Run state persistence**
JSON file next to the mod. All 5 floors are generated from a single seed at run start; the UI renders only floors `<= currentFloor`. Fog of war is presentation-only. Seeds must be displayable and shareable so runs are reproducible.

**Layer 3 — Save protection**
Because activating skulls requires New Game, the mod **must** back up and restore the player's campaign save, or use a dedicated run slot. Implement this before anything else that touches saves. This is the number one way testers lose progress.

---

## 6. Known config surfaces

### 6.1 Debug menu (needed for discovery, and possibly for launch)

The shipped `Meteorite/Config/DefaultGame.ini` inside `pakchunk0-Windows.pak` contains:

```ini
[/Script/Meteorite.DebugMenuSettings]
bEnableDebugMenuBetaNonShipping=True
bEnableDebugMenuReleaseNonShipping=True
```

Retail is a Shipping build, so neither applies. The executable also exposes `bEnableDebugMenuDefaultShipping`, `bEnableDebugMenuBetaShipping` and `bEnableDebugMenuReleaseShipping`, which are absent from shipped config and default to `False`.

Override via a user-layer `Game.ini` (Unreal config is layered; the user directory wins):

```ini
[/Script/Meteorite.DebugMenuSettings]
bEnableDebugMenuDefaultShipping=True
bEnableDebugMenuBetaShipping=True
bEnableDebugMenuReleaseShipping=True
bEnableDebugMenuDefaultNonShipping=True
bEnableDebugMenuBetaNonShipping=True
bEnableDebugMenuReleaseNonShipping=True
```

Mark the file read-only so the game doesn't stomp it. In-game: `G` toggles debug options. The debug front-end contains progression controls for **missions, insertion points, skulls, DLC and terminals** — i.e. it drives exactly the systems this mod needs. There is also a prebuilt `HCEDebugMenu` UE4SS mod on Nexus (mod 14) that proves this path works from a shipping build; study it.

**Unreal config rule:** a config class reads from the `.ini` matching its `config=` specifier, and its section header must be `[/Script/<Module>.<Class>]` — unless the class overrides the section name (see `[HaloUserSettings]` below, which does).

### 6.2 Difficulty modifiers — how to build "Legendary+"

File: `HaloGlobalGameUserSettings.ini`, single section `[HaloUserSettings]`. Four preset slots.

```ini
ModifierPreset=None
PlayerTraits1=(VitalityTraits=(),WeaponTraits=(),MovementTraits=(),AppearanceTraits=())
PlayerTraits2=(...)
PlayerTraits3=(...)
PlayerTraits4=(...)
```

`ModifierPreset` accepts `None`, `Preset01`–`Preset04`, selecting `PlayerTraits1`–`PlayerTraits4` respectively.

**Do not write this file at runtime — the game rewrites it on exit and will discard your changes.** Set the properties live on the `HaloUserSettings` object through UE4SS instead.

Example nerf preset for floors 4–5:

```ini
ModifierPreset=Preset03
PlayerTraits3=(VitalityTraits=(DamageResistancePercentageSetting=Percent50,ShieldRechargeRatePercentageSetting=PercentNegative10),WeaponTraits=(DamageModifierPercentageSetting=Percent75))
```

Surface this to the player as literal numbers, not as a mystery tier. Otherwise it reads as the game cheating.

#### Full enum reference

**VitalityTraits**

| Field | In menu | Values |
|---|---|---|
| `DamageResistancePercentageSetting` | Yes | `Unchanged`, `Percent10`, `Percent50`, `Percent90`, `Percent100`, `Percent110`, `Percent150`, `Percent200`, `Percent300`, `Percent500`, `Percent1000`, `Percent2000`, `Invulnerable` |
| `ShieldRechargeRatePercentageSetting` | Yes | `Unchanged`, `PercentNegative25`, `PercentNegative10`, `PercentNegative5`, `Percent0`, `Percent10`, `Percent25`, `Percent50`, `Percent75`, `Percent90`, `Percent100`, `Percent110`, `Percent125`, `Percent150`, `Percent200` |
| `BodyRechargeRatePercentageSetting` | No | same ladder as shield recharge |
| `DeathlessSetting` | No | `Unchanged`, `Off`, `On` |

Resistance is *resistance*, so higher = tougher. Below `Percent100` = squishier. `Invulnerable` sits one rung above the menu maximum.

**WeaponTraits**

| Field | In menu | Values |
|---|---|---|
| `DamageModifierPercentageSetting` | Yes | `Unchanged`, `Percent0`, `Percent25`, `Percent50`, `Percent75`, `Percent90`, `Percent100`, `Percent110`, `Percent125`, `Percent150`, `Percent200`, `Percent300`, `Fatality` |
| `MeleeDamageModifierPercentageSetting` | Yes | same as above |
| `InfiniteAmmoSetting` | Yes | `Unchanged`, `Off`, `On`, `BottomlessClip` |
| `WeaponPickupSetting` | No | `Unchanged`, `Off`, `On` |
| `RechargingGrenadesSetting` | No | `Unchanged`, `Off`, `On` |

**MovementTraits**

| Field | In menu | Values |
|---|---|---|
| `SpeedSetting` | No | `Unchanged`, `Percent0`, `Percent25`, `Percent50`, `Percent75`, `Percent90`, `Percent100`, `Percent110`…`Percent200` (steps of 10), `Percent300` |
| `GravitySetting` | No | `Unchanged`, `Percent50`, `Percent75`, `Percent100`, `Percent110`…`Percent200` (steps of 10) |

`Percent300` is max speed; `Percent50` is the lowest gravity. Jump height is a separate Blam trait and is **not** wired to anything settable.

**AppearanceTraits**

| Field | In menu | Values |
|---|---|---|
| `ActiveCamoSetting` | No | `Unchanged`, `Off`, `Poor`, `Good`, `Excellent`, `Invisible` |

### 6.3 Achievements

`BlamAchievementDefinition` in the executable carries a `bBlockedByDifficultyModifiers` flag alongside `RequiredActiveSkulls` and `BlockerActiveSkulls`, and the binary exposes a `HasModifiedPlayerTraits` check. Setting `ModifierPreset` to anything other than `None` very likely disables achievements. **Unconfirmed but assume true.** Warn the user at run start.

---

## 7. Unknowns — resolve these first

These cannot be determined statically. They require a UObject dump from a running game.

1. **The mission launch call.** The function that takes mission + insertion point + difficulty + skull set. Dump UObjects with UE4SS and grep for `InsertionPoint`, `RallyPoint`, `Skull`, `Campaign`, `Remix`, `StartMission`, `Deploy`.
2. **The skull enum / identifier scheme.** Names vs. indices vs. gameplay tags.
3. **The Remix deploy path specifically** — how the visibility-modifier roll is triggered, and whether it can be forced to a chosen value or only rolled.
4. **Mission-complete event** to hook for floor advancement.
5. **Player death / mission restart event** for the death counter.
6. **The live `HaloUserSettings` object** — locate it, confirm property writes apply without a restart.

### Discovery method

Instrument heavily and read `UE4SS.log`. Every hook, every resolved UObject, every launch attempt should log. The log file is readable from outside the game, so a single manual playtest yields a large amount of information without the user having to describe anything.

Static starting points (run in the Distrobox container):

```bash
strings -a HaloCampaignEvolved.exe | grep -oE 'EBlam[A-Za-z]*Setting' | sort -u
strings -a HaloCampaignEvolved.exe | grep -oE 'BlamPlayerTrait\w+' | sort -u
strings -a HaloCampaignEvolved.exe | grep -oiE '\w*(skull|insertion|rallypoint|remix)\w*' | sort -u
strings -a HaloSimulation_tag_release.dll | grep -i 'multiplier'
```

Asset extraction, if needed:

```bash
repak list pakchunk0-Windows.pak
repak get pakchunk0-Windows.pak "Meteorite/Config/DefaultGame.ini" > DefaultGame.ini
retoc unpack pakchunk0-Windows.utoc ./extracted
```

Relevant assets live under `Meteorite/Content/UI/Shared/Settings/`:
- `Widgets/WBP_DifficultyModifierMenu.uasset`
- `Data/DA_DifficultyModifierSettingsItems.uasset`

Player trait tags: `Meteorite/Content/Tags/multiplayer/game_variant_settings/player_traits_template/`

A community `.usmap` for FModel exists on Nexus — grab it, it makes `.uasset` reading far less painful than raw `strings`.

---

## 8. Build order

Strictly sequential. Milestone 1 is go/no-go for the whole project.

1. **Toolchain + UE4SS running under Proton.** Get the HCE fork loading, confirm it finds `GUObjectArray`, get a log.
2. **Manual proof.** Launch a Remix mission at a chosen rally point, on a chosen difficulty, with Iron active — driven from Lua, not from the in-game menu. **If this fails, the project stops here.**
3. **Save backup/restore.** Before anything else touches New Game.
4. **Run generator + JSON state**, driven by hotkeys. No UI.
5. **Difficulty escalation** via modifier presets.
6. **ImGui overlay** — floor cards, seed display, skull list, death counter, run summary screen.
7. Polish: run summary is the screen people screenshot; give it disproportionate attention.

---

## 9. Constraints and non-goals

| Constraint | Consequence |
|---|---|
| No native UMG main-menu widget | Would need Unreal Editor 5.5 — 100 GB+, GPU, cook step. Not viable on a 16 GB / 8 GB VRAM Steam Machine. Use ImGui. |
| Solo only | Co-op is cross-platform with cross-progression and server-side validation. Out of scope. |
| Achievements disabled in-mode | Communicate up front; restore `ModifierPreset=None` on exit. |
| Patch fragility | Signatures break on game updates. Add a build-string version check that refuses to load on an unknown build rather than crashing. |
| Return-to-menu between floors | Unavoidable — skulls and difficulty cannot change mid-mission. |
| Native post-mission screens still show | Hiding them needs significant extra hook work. Accept for v1. |

---

## 10. UX walkthrough (target)

1. Title screen shows an extra prompt: `F6 — ROGUELIKE`
2. Panel opens: New run / Resume run / Settings
3. New run → unskippable save-backup + achievements warning, confirmed once
4. Seed displayed (e.g. `HALO-7K2M-QX9`), then five cards — four collapsed as `FLOOR n — ???`
5. Floor 1 card shows mission, rally point, difficulty, skull list, visibility modifier, `[ START FLOOR ]`
6. In mission: only a small corner counter — `FLOOR 1/5 · DEATHS 2/8`
7. On completion: result, then the next card flips open with the escalated difficulty and grown skull list
8. Floors 4–5 show `LEGENDARY +` with the literal modifier values printed underneath
9. Run end: full summary — 5 missions, all skulls accumulated, total deaths, elapsed time, seed
10. Exit mode → campaign save restored, achievements re-enabled

---

## 11. References

- UE4SS (HCE fork) — https://www.nexusmods.com/halocampaignevolved/mods/9
- HCE Debug Menu — https://www.nexusmods.com/halocampaignevolved/mods/14
- Split-screen co-op (Proton launch options + signature handling) — https://www.nexusmods.com/halocampaignevolved/mods/53
- Debug menu writeup — https://den.dev/blog/halo-campaign-evolved-secret-menu/
- Difficulty modifier writeup — https://den.dev/blog/halo-campaign-evolved-secret-modifiers/
- Skulls & Campaign Remix (official) — https://www.halowaypoint.com/news/skulls-campaign-remix-halo-campaign-evolved
- Modding policy (official) — https://www.halowaypoint.com/news/early-access-primer
- repak — https://github.com/trumank/repak
- retoc — https://github.com/trumank/retoc

---

## 12. Legal note

Halo Studios and Microsoft do not approve, endorse or accept liability for modded content. Do not redistribute game code or assets, do not ship a modified build of the game, and do not circumvent entitlement checks, account authentication, or access to locked/unreleased/premium content. Keep the mod to original code that hooks the shipped game.
