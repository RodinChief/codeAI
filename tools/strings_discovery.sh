#!/usr/bin/env bash
# strings_discovery.sh — static discovery pass over the game binaries.
#
# Run inside the Distrobox Ubuntu container (SteamOS lacks `strings`) with
# the game dir bind-mounted. Writes greps into ./discovery-out/ for updating
# Mods/HaloRoguelike/Scripts/const.lua and gameapi.lua candidate tables.
set -euo pipefail

STEAM_ROOT="${STEAM_ROOT:-$HOME/.local/share/Steam}"
GAMEDIR="${GAMEDIR:-$STEAM_ROOT/steamapps/common/Halo Campaign Evolved}"
BIN="$GAMEDIR/Meteorite/Binaries/Win64"
OUT="${OUT:-./discovery-out}"

EXE="$BIN/HaloCampaignEvolved.exe"
SIM="$BIN/HaloSimulation_tag_release.dll"
[ -f "$EXE" ] || { echo "ERROR: $EXE not found (set GAMEDIR=...)" >&2; exit 1; }

command -v strings >/dev/null || {
    echo "ERROR: 'strings' missing — run inside the Distrobox container" >&2; exit 1; }

mkdir -p "$OUT"
echo "== extracting strings (once, ~a minute) =="
strings -a "$EXE" > "$OUT/exe.strings"
[ -f "$SIM" ] && strings -a "$SIM" > "$OUT/sim.strings" || true

grep_out() { # name pattern file
    grep -oiE "$2" "$3" | sort -u > "$OUT/$1.txt" || true
    printf '%-28s %s\n' "$1" "$(wc -l < "$OUT/$1.txt") hits"
}

echo "== greps from the brief (§7) =="
grep_out blam_settings_enums   'EBlam[A-Za-z]*Setting'                     "$OUT/exe.strings"
grep_out player_traits         'BlamPlayerTrait\w+'                        "$OUT/exe.strings"
grep_out skull_insertion_remix '\w*(skull|insertion|rallypoint|remix)\w*'  "$OUT/exe.strings"
[ -f "$OUT/sim.strings" ] && grep_out sim_multipliers 'multiplier' "$OUT/sim.strings"

echo "== extra greps for the mod's unknowns =="
grep_out launch_candidates  '\w*(StartMission|LaunchMission|DeployMission|StartCampaign|MissionComplete|MissionFinished)\w*' "$OUT/exe.strings"
grep_out death_candidates   '\w*(PlayerDeath|OnDeath|PlayerKilled|Respawn)\w*' "$OUT/exe.strings"
grep_out user_settings      '\w*HaloUserSettings\w*|\w*ModifierPreset\w*|\w*PlayerTraits[0-9]\w*' "$OUT/exe.strings"
grep_out difficulty         '\w*(Difficulty|Legendary|Heroic)\w*' "$OUT/exe.strings"
grep_out achievements       '\w*(Achievement|HasModifiedPlayerTraits)\w*' "$OUT/exe.strings"
grep_out debug_menu         'bEnableDebugMenu\w+' "$OUT/exe.strings"
grep_out build_string       '5\.5\.4-[0-9.]+[A-Za-z0-9.-]*' "$OUT/exe.strings"

echo
echo "Results in $OUT/. Feed the interesting names into:"
echo "  Mods/HaloRoguelike/Scripts/gameapi.lua  (CANDIDATES table)"
echo "  Mods/HaloRoguelike/Scripts/const.lua    (skulls/missions/builds)"
echo "Then do the dynamic pass: docs/DISCOVERY.md"
