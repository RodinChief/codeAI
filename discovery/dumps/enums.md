# Runtime enum dumps

Read from the live UEnum objects on-device (2026-07-29). The C++ header dump
names these enums but does not contain their members, so these values come
from `Gameapi.dump_enums()` (`ENUM` lines in UE4SS.log).

## EBlamGameSkulls — `/Script/BlamGlue.EBlamGameSkulls`

56 real members (plus `Num`, `None=255`, `_MAX=256`).

Every real member is used: 3 mandatory, 47 rollable, 3 visibility modifiers.
Only the three `Custom*` slots — the game's empty custom-skull placeholders —
are left out.

| Value | Member | Used by this mod |
|---:|---|---|
| 0 | Iron | mandatory |
| 1 | BlackEye | pool |
| 2 | ToughLuck | pool |
| 3 | Catch | pool |
| 4 | Fog | pool |
| 5 | Famine | pool |
| 6 | Thunderstorm | pool |
| 7 | Tilt | pool |
| 8 | Mythic | pool |
| 9 | Assassin | pool |
| 10 | Blind | pool |
| 11 | Cowbell | pool |
| 12 | GruntBirthdayParty | pool |
| 13 | IWHBYD | pool |
| 14 | CustomRed | excluded (placeholder) |
| 15 | CustomYellow | excluded (placeholder) |
| 16 | CustomBlue | excluded (placeholder) |
| 17 | Angry | pool |
| 18 | Bandana | pool |
| 19 | BondedPair | pool |
| 20 | Boom | pool |
| 21 | Envy | pool |
| 22 | EyePatch | pool |
| 23 | Foreign | pool |
| 24 | Ghost | pool |
| 25 | GruntFuneral | pool |
| 26 | Jacked | pool |
| 27 | Malfunction | pool |
| 28 | Masterblaster | pool |
| 29 | Pinata | pool |
| 30 | Recession | pool |
| 31 | Scarab | pool |
| 32 | SoAngry | pool |
| 33 | Swarm | pool |
| 34 | ThatsJustWrong | pool |
| 35 | TheyComeBack | pool |
| 36 | BootsOffTheGround | pool |
| 37 | Adaptation | mandatory |
| 38 | Reload | mandatory |
| 39 | SporeVisibility | visibility modifier |
| 40 | NightVision | visibility modifier |
| 41 | LightsOut | visibility modifier |
| 42 | Riskrun | pool |
| 43 | Pop | pool |
| 44 | Armistice | pool |
| 45 | EnduranceSpec | pool |
| 46 | GiveAndTake | pool |
| 47 | StowAndGrow | pool |
| 48 | HipFire | pool |
| 49 | Temperamental | pool |
| 50 | FloorIsLava | pool |
| 51 | Magnified | pool |
| 52 | JohnnyAmmoTree | pool |
| 53 | Leadhead | pool |
| 54 | Efficient | pool |
| 55 | ThirdPerson | pool |

Members are returned fully qualified — `EBlamGameSkulls::Iron`, not `Iron`.
`Gameapi.skull_enum_values` strips the `EnumName::` prefix before matching;
skipping that step made every lookup miss.

## EBlamCampaignDifficultyLevel — `/Script/BlamGlue.EBlamCampaignDifficultyLevel`

| Value | Member |
|---:|---|
| 0 | Easy |
| 1 | Normal |
| 2 | Heroic |
| 3 | Legendary |

Matches the mapping `launch_floor` already used.

## Insertion-point assets

One `ScenarioInsertionPointAsset` per mission, discovered in the same pass:

```
/Game/Levels/Halo1/Solo/<ID>/DA_<ID>_InsertionPoints
```

Seen for A15, A30, A50, B30, B40, C10, C20, C45, D20, D40, E10, E20, E30.
Each holds `InsertionPoints: TArray<FScenarioInsertionPoint>` — the source for
real per-mission rally-point names and counts, which `const.lua` currently
approximates with a fixed Alpha/Bravo/Charlie list.
