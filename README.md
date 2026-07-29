# Halo: Campaign Evolved — Roguelike Mod (HaloRoguelike)

A UE4SS Lua mod that adds a roguelike run mode to *Halo: Campaign Evolved*.
A run is **5 hidden floors** — each a random mission + rally point — with an
escalating difficulty ladder and an accumulating skull pool. Built on top of
**Campaign Remix**, which already supplies Adaptation/Reload/Armistice and the
visibility-modifier roll for free.

Full design brief: [`docs/BRIEF.md`](docs/BRIEF.md).

## The run

| Floor | Difficulty | Skulls |
|---|---|---|
| 1 | Normal | Iron + Adaptation + Reload + Armistice, +1–2 rolled |
| 2 | Heroic | everything so far, +1–2 rolled |
| 3 | Legendary | everything so far, +1–2 rolled |
| 4 | Legendary **+ nerf preset** | everything so far, +1–2 rolled |
| 5 | Legendary **+ nerf preset** | everything so far, +2 rolled |

- Exactly one floor uses Rally Point **Alpha**; the rest use Bravo/Charlie/Delta.
- 5 distinct missions per run, no skull duplicates, every skull sticks for the
  rest of the run.
- One visibility modifier per floor (Default / Spore / Nightvision), not cumulative.
- **Iron** restarts the rally point on death; the run is lost at the death cap
  (default 8, `config.lua`).
- Future floors show as `FLOOR n — ???` until the previous floor is complete.
- Runs are seeded and shareable: `HALO-7K2M-QX9` always generates the same run.
- The floor 4–5 nerf preset is shown as **literal numbers** on the floor card
  (damage resistance 50%, shield recharge −10%, weapon damage 75%) — not a
  mystery tier.

## ⚠ Before you play

- **Your solo campaign save gets overwritten** by run starts (skull activation
  requires New Game). The mod backs your save up first, verifies the copy, and
  **refuses to start a run if the backup fails**. The save is restored when you
  exit the mode. `F9` force-restores the newest backup at any time.
- **Achievements are very likely disabled** while difficulty modifiers are
  active. The mod warns at run start and sets `ModifierPreset=None` on exit.
- The mod refuses to load on an unrecognised game build (rather than crash on
  stale signatures). Known builds: `Scripts/const.lua`.

## Install (SteamOS / Steam Machine)

1. Install the **HCE-specific UE4SS fork** —
   [Nexus mod 9](https://www.nexusmods.com/halocampaignevolved/mods/9) — into
   `Meteorite/Binaries/Win64/ue4ss/`, letting its `UE4SS-settings.ini` and
   `UE4SS_Signatures/` overwrite stock files. **Stock UE4SS does not work.**
2. Set the Steam launch options for UE4SS-under-Proton exactly as documented
   by the [split-screen mod](https://www.nexusmods.com/halocampaignevolved/mods/53).
3. From this repo: `./tools/install.sh`
   (copies the mod, writes the debug-menu `Game.ini`, sanity-checks the above).

Details and troubleshooting: [`docs/INSTALL.md`](docs/INSTALL.md).

## Keys

| Key | Action |
|---|---|
| `F6` | Open/close the roguelike panel |
| `F5` | Presses the highlighted ROGUELIKE row; outside that menu, the primary action for the screen |
| `F7` | Write a discovery report to `UE4SS.log` |
| `F8` | Exit mode: abandon run, restore save, clear modifiers |
| `F9` | **Emergency save restore** (works even when the mod is disabled) |

## Project status

Milestones (brief §8): code for all layers is in place and the offline logic is
tested (`lua5.4 tests/run_tests.lua` — RNG determinism, run-generation
invariants, state machine, fog of war, summary). What remains is **on-device
discovery** — the game-facing calls marked unknown in brief §7 must be resolved
from a live UObject dump and filled into `gameapi.lua`'s `CANDIDATES` table:

| Unknown (§7) | Where it lands |
|---|---|
| Mission launch call | `gameapi.lua` `mission_launcher_class` / `mission_launch_fn` |
| Skull enum / identifiers | `const.lua` `SKULL_POOL` (+ launch call args) |
| Remix deploy path / visibility roll | `gameapi.launch_floor` |
| Mission-complete event | `gameapi.lua` `mission_complete_hooks` |
| Player death event | `gameapi.lua` `player_death_hooks` |
| Live `HaloUserSettings` object | `gameapi.lua` `user_settings_class` |

Until a capability resolves, the mod degrades gracefully: the floor card tells
you what to launch manually (mission/rally/difficulty; skulls via the debug
menu on `G`), `F5` marks a floor complete by hand, and everything is logged.
The discovery playbook is [`docs/DISCOVERY.md`](docs/DISCOVERY.md).

## Repo layout

```
Mods/HaloRoguelike/          the UE4SS mod (copy to ue4ss/Mods/)
  Scripts/main.lua           entry point, keybinds, floor flow
  Scripts/gameapi.lua        ALL game-object access; candidate-based resolution
  Scripts/state.lua          run state machine + JSON persistence (resume-safe)
  Scripts/saveguard.lua      campaign save backup/restore (verified copies)
  Scripts/rungen.lua         seeded run generator
  Scripts/rng.lua            deterministic PRNG + shareable seed strings
  Scripts/ui.lua             overlay (ImGui when available, text fallback)
  Scripts/presets.lua        the "Legendary+" nerf preset (live, never via ini)
  Scripts/const.lua          missions/skulls/ladder + known-build allowlist
  Scripts/config.lua         user settings (death cap, keys, ...)
tests/run_tests.lua          offline test suite (lua5.4)
tools/install.sh             SteamOS installer
tools/strings_discovery.sh   static binary greps (run in Distrobox)
docs/                        brief, install guide, discovery playbook
```

## Legal

Halo Studios and Microsoft do not approve, endorse or accept liability for
modded content. This repo contains only original code that hooks the shipped
game: no game code or assets are redistributed, no entitlement checks are
touched, and nothing here unlocks premium or unreleased content.
