#!/usr/bin/env bash
# install.sh — install the HaloRoguelike mod onto a SteamOS machine.
#
# Run from the repo root, either directly on SteamOS or inside the Distrobox
# container with $HOME bind-mounted. Everything stays under $HOME (SteamOS
# root FS is immutable — never touch it).
#
# Prerequisite: the HCE-specific UE4SS fork (Nexus mod 9) must already be
# installed into Meteorite/Binaries/Win64/ue4ss/ WITH its replacement
# UE4SS-settings.ini and UE4SS_Signatures/. Stock UE4SS does not work on
# this game; this script checks for the install but cannot download it
# (Nexus requires a logged-in browser).
set -euo pipefail

APPID=2806050
STEAM_ROOT="${STEAM_ROOT:-$HOME/.local/share/Steam}"
GAMEDIR="${GAMEDIR:-$STEAM_ROOT/steamapps/common/Halo Campaign Evolved}"
PFX="${PFX:-$STEAM_ROOT/steamapps/compatdata/$APPID/pfx}"
UE4SS_DIR="$GAMEDIR/Meteorite/Binaries/Win64/ue4ss"
WINCFG="$PFX/drive_c/users/steamuser/AppData/Local/Meteorite/Saved/Config/Windows"

here="$(cd "$(dirname "$0")/.." && pwd)"

fail() { echo "ERROR: $*" >&2; exit 1; }

echo "== HaloRoguelike installer =="

# --- sanity checks -----------------------------------------------------------
[ -d "$GAMEDIR" ] || fail "game dir not found: $GAMEDIR (set GAMEDIR=...)"
[ -f "$GAMEDIR/Meteorite/Binaries/Win64/HaloCampaignEvolved.exe" ] \
    || fail "HaloCampaignEvolved.exe missing under $GAMEDIR"

if [ ! -f "$UE4SS_DIR/UE4SS-settings.ini" ]; then
    fail "UE4SS not installed at $UE4SS_DIR.
Install the HCE fork first: https://www.nexusmods.com/halocampaignevolved/mods/9
(the fork's UE4SS-settings.ini and UE4SS_Signatures/ MUST overwrite stock files)"
fi
if [ ! -d "$UE4SS_DIR/UE4SS_Signatures" ]; then
    echo "WARNING: $UE4SS_DIR/UE4SS_Signatures is missing." >&2
    echo "Stock UE4SS will NOT find GUObjectArray on this game." >&2
    echo "Re-install the HCE fork from Nexus mod 9 before launching." >&2
fi

# --- mod files ---------------------------------------------------------------
echo "-- copying mod to $UE4SS_DIR/Mods/HaloRoguelike"
mkdir -p "$UE4SS_DIR/Mods"
rm -rf "$UE4SS_DIR/Mods/HaloRoguelike"
cp -r "$here/Mods/HaloRoguelike" "$UE4SS_DIR/Mods/"

# Make sure the mod is listed/enabled. enabled.txt in the mod dir is enough
# for UE4SS, but add a mods.txt line too when the file exists.
if [ -f "$UE4SS_DIR/Mods/mods.txt" ] \
    && ! grep -q '^HaloRoguelike' "$UE4SS_DIR/Mods/mods.txt"; then
    echo "HaloRoguelike : 1" >> "$UE4SS_DIR/Mods/mods.txt"
    echo "-- added HaloRoguelike to mods.txt"
fi

# --- UE4SS GUI console (the mod's text UI renders here until the in-game ----
# --- overlay path is resolved; harmless to leave on) -------------------------
SETTINGS="$UE4SS_DIR/UE4SS-settings.ini"
if [ -f "$SETTINGS" ]; then
    sed -i -E \
        -e 's/^([[:space:]]*ConsoleEnabled[[:space:]]*=[[:space:]]*).*/\11/' \
        -e 's/^([[:space:]]*GuiConsoleEnabled[[:space:]]*=[[:space:]]*).*/\11/' \
        -e 's/^([[:space:]]*GuiConsoleVisible[[:space:]]*=[[:space:]]*).*/\11/' \
        "$SETTINGS"
    echo "-- enabled UE4SS GUI console in UE4SS-settings.ini"
fi

# --- debug menu Game.ini (user config layer wins over the pak'd defaults) ----
if [ -d "$(dirname "$WINCFG")" ] || [ -d "$PFX" ]; then
    mkdir -p "$WINCFG"
    GAME_INI="$WINCFG/Game.ini"
    if [ -f "$GAME_INI" ] \
        && ! grep -q 'bEnableDebugMenuDefaultShipping' "$GAME_INI"; then
        chmod u+w "$GAME_INI" 2>/dev/null || true
        cp "$GAME_INI" "$GAME_INI.bak"
        echo "-- existing Game.ini backed up to Game.ini.bak"
    fi
    cat > "$GAME_INI" <<'EOF'
[/Script/Meteorite.DebugMenuSettings]
bEnableDebugMenuDefaultShipping=True
bEnableDebugMenuBetaShipping=True
bEnableDebugMenuReleaseShipping=True
bEnableDebugMenuDefaultNonShipping=True
bEnableDebugMenuBetaNonShipping=True
bEnableDebugMenuReleaseNonShipping=True
EOF
    # Read-only so the game can't stomp it on exit.
    chmod 444 "$GAME_INI"
    echo "-- wrote $GAME_INI (read-only; in-game 'G' toggles the debug menu)"
else
    echo "WARNING: Wine prefix not found at $PFX — run the game once first," >&2
    echo "then re-run this script to install the debug-menu Game.ini." >&2
fi

# --- launch options reminder -------------------------------------------------
cat <<'EOF'

== Install done ==

Remaining manual step — Steam launch options:
  UE4SS under Proton needs a WINEDLLOVERRIDES launch option. Use the exact
  options documented by the split-screen mod (they are the known-working set
  for this game under Proton):
      https://www.nexusmods.com/halocampaignevolved/mods/53
  Steam > Halo: Campaign Evolved > Properties > Launch Options.

Then launch the game and check:
  Meteorite/Binaries/Win64/ue4ss/UE4SS.log
  - UE4SS found GUObjectArray            -> fork working
  - grep HRLK UE4SS.log                  -> this mod's output
  In-game keys: F6 panel · F5 confirm/start · F7 discovery dump
                F8 exit mode · F9 EMERGENCY SAVE RESTORE
EOF
