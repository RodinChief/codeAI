# Install guide — SteamOS / Valve Steam Machine

Target: SteamOS 3 (immutable root), game running under Proton, dev work in a
Distrobox Ubuntu container with the game dir bind-mounted. Everything lives
under `$HOME`; nothing here touches the root filesystem.

## Paths

```
Game:        ~/.local/share/Steam/steamapps/common/Halo Campaign Evolved/
UE4SS:       .../Halo Campaign Evolved/Meteorite/Binaries/Win64/ue4ss/
Wine prefix: ~/.local/share/Steam/steamapps/compatdata/2806050/pfx/
User config: <prefix>/drive_c/users/steamuser/AppData/Local/Meteorite/Saved/Config/Windows/
```

## Step 1 — UE4SS (HCE fork, mandatory)

Stock UE4SS does **not** work: the 343 fork of UE 5.5.4 changes the memory
layout and stock pattern scans never find `GUObjectArray`. Install the
HCE-specific build from <https://www.nexusmods.com/halocampaignevolved/mods/9>
into `Meteorite/Binaries/Win64/ue4ss/`, and let its **`UE4SS-settings.ini`**
and **`UE4SS_Signatures/*.lua`** overwrite anything already there. Both
overwrites are required.

## Step 2 — Proton launch options

UE4SS needs a DLL override passed as a Steam launch option to load under
Proton. Use the exact options documented by the split-screen mod — it is the
known-working reference for this game:
<https://www.nexusmods.com/halocampaignevolved/mods/53>

Steam → Halo: Campaign Evolved → Properties → Launch Options.

## Step 3 — this mod

From the repo root (SteamOS host or Distrobox, either works as long as
`$HOME` is the real home):

```bash
./tools/install.sh
```

The script:

1. verifies the game and the UE4SS fork install (fails loudly if the fork's
   signatures are missing);
2. copies `Mods/HaloRoguelike/` into `ue4ss/Mods/` (with `enabled.txt`, and a
   `mods.txt` entry when that file exists);
3. writes the debug-menu `Game.ini` into the Wine prefix's user config layer
   and marks it read-only so the game can't stomp it (in-game `G` opens the
   debug menu — used for skull activation while the launch call is
   unresolved, see `docs/DISCOVERY.md`).

Override paths via env vars if the layout differs:
`GAMEDIR=... PFX=... ./tools/install.sh`

## Step 4 — first launch checklist

Start the game, then check `Meteorite/Binaries/Win64/ue4ss/UE4SS.log`:

1. UE4SS banner present, `GUObjectArray` found → fork working. If the log is
   missing entirely, the launch options (step 2) aren't taking effect.
2. `grep HRLK UE4SS.log` → the mod's own output. Expect the loading banner,
   the build-version line, key bindings, and the `gameapi: resolving...`
   discovery lines.
3. `main: ready — F6 opens the roguelike panel` → the build check passed.
   If instead you see `UNKNOWN BUILD ... refusing to enable`, the game
   updated: re-verify the UE4SS fork still works on the new build, then add
   the new build string to `Scripts/const.lua` (`KNOWN_BUILDS`) or set
   `allow_unknown_build = true` in `Scripts/config.lua` at your own risk.

## Updating the mod

Re-run `./tools/install.sh` — it replaces `ue4ss/Mods/HaloRoguelike` wholesale.
Run state and save backups live in the Wine prefix under
`.../AppData/Local/Meteorite/Saved/HaloRoguelike/` and survive mod updates.

## Uninstall

```bash
rm -rf "$HOME/.local/share/Steam/steamapps/common/Halo Campaign Evolved/Meteorite/Binaries/Win64/ue4ss/Mods/HaloRoguelike"
```

If you want the debug menu gone too, delete the read-only `Game.ini` written
in step 3 (restore `Game.ini.bak` if one was created). Save backups under
`Saved/HaloRoguelike/SaveBackups/` are plain copies — keep or delete freely,
but only after confirming your campaign save is the one you want.
