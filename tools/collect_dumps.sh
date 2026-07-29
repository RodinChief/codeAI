#!/usr/bin/env bash
# collect_dumps.sh — collect UE4SS's own reflection dumps into the repo.
#
# WHY: this mod calls the game purely through UE4SS reflection. Every wrong
# guess about a class name, a function's parameter count or an enum value
# costs a playtest. UE4SS can dump the game's ENTIRE reflected API to disk;
# this script picks the parts this mod needs, shrinks them, and drops them in
# discovery/dumps/ so they can be committed and read during development.
#
# HOW TO PRODUCE THE DUMPS (once, on the Steam Deck):
#   1. Launch the game with UE4SS active and sit on the MAIN MENU.
#   2. Open the UE4SS GUI console window (this repo's installer enables it).
#   3. Open the "Dumpers" tab and press, in this order:
#        - "Generate Lua Types"                (-> Mods/shared/types/)
#        - "Generate C++ Headers" / .hpp       (-> CXXHeaderDump/)
#        - "Dump Objects & Properties"         (-> UE4SS_ObjectDump.txt)
#      Each takes a while and the game will freeze meanwhile — that's normal.
#   4. Quit the game, then run this script.
#
# Anything not found is reported, not fatal: partial dumps are still useful.
set -euo pipefail

APPID=2806050
STEAM_ROOT="${STEAM_ROOT:-$HOME/.local/share/Steam}"
GAMEDIR="${GAMEDIR:-$STEAM_ROOT/steamapps/common/Halo Campaign Evolved}"
UE4SS_DIR="${UE4SS_DIR:-$GAMEDIR/Meteorite/Binaries/Win64/ue4ss}"

here="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$here/discovery/dumps"

# Everything this mod still has open questions about. Used to slice the big
# dumps down to something committable.
KEYWORDS='Campaign|Scenario|InsertionPoint|Skull|Difficulty|Modifier|Remix|Cinematic|Cutscene|Lobby|MapInfo|PlayerTraits|Insertion|Rally|MissionComplete|BlamGame|Meteorite'

echo "== HaloRoguelike dump collector =="
[ -d "$UE4SS_DIR" ] || { echo "ERROR: ue4ss dir not found: $UE4SS_DIR" >&2
    echo "Set GAMEDIR=... or UE4SS_DIR=... and retry." >&2; exit 1; }
echo "-- ue4ss dir: $UE4SS_DIR"

mkdir -p "$OUT"
found_any=0

# --- 1. Lua type annotations -------------------------------------------------
# The single most valuable artefact: one .lua per package with every class,
# every method and its full parameter list. Compact enough to commit as-is.
TYPES_DIR="$UE4SS_DIR/Mods/shared/types"
if [ -d "$TYPES_DIR" ]; then
    mkdir -p "$OUT/luatypes"
    n=0
    for f in "$TYPES_DIR"/*.lua; do
        [ -e "$f" ] || continue
        base="$(basename "$f")"
        # Game-specific packages in full; engine packages only where relevant.
        case "$base" in
            Meteorite.lua|Blam*.lua|HaloOnlineUtils.lua|CommonUI.lua|UMG.lua)
                cp "$f" "$OUT/luatypes/$base" ;;
            *)
                # Keep only declarations touching this mod's unknowns.
                if grep -qE "$KEYWORDS" "$f" 2>/dev/null; then
                    grep -E "^---|^function|^local|$KEYWORDS" "$f" \
                        > "$OUT/luatypes/$base" 2>/dev/null || true
                fi ;;
        esac
        n=$((n + 1))
    done
    echo "-- lua types: scanned $n file(s) -> $OUT/luatypes"
    found_any=1
else
    echo "MISSING: $TYPES_DIR (run \"Generate Lua Types\" in the Dumpers tab)"
fi

# --- 2. C++ header dump ------------------------------------------------------
# Full struct/class layouts incl. enums (the 42 skull names live here).
CXX_DIR=""
for cand in "$UE4SS_DIR/CXXHeaderDump" "$UE4SS_DIR/CppHeaderDump" \
            "$UE4SS_DIR/Dumps/CXXHeaderDump"; do
    [ -d "$cand" ] && { CXX_DIR="$cand"; break; }
done
if [ -n "$CXX_DIR" ]; then
    mkdir -p "$OUT/cxx"
    n=0
    while IFS= read -r -d '' f; do
        base="$(basename "$f")"
        case "$base" in
            Meteorite*|Blam*|HaloOnline*|CommonUI*)
                cp "$f" "$OUT/cxx/$base"; n=$((n + 1)) ;;
            *)
                if grep -qE "$KEYWORDS" "$f" 2>/dev/null; then
                    # Keep matching lines plus surrounding context only.
                    grep -nE -A4 -B4 "$KEYWORDS" "$f" > "$OUT/cxx/$base.slice" \
                        2>/dev/null || true
                    n=$((n + 1))
                fi ;;
        esac
    done < <(find "$CXX_DIR" -type f \( -name '*.hpp' -o -name '*.h' \) -print0)
    echo "-- cxx headers: kept $n file(s) from $CXX_DIR -> $OUT/cxx"
    found_any=1
else
    echo "MISSING: CXXHeaderDump (run \"Generate C++ Headers\" in Dumpers tab)"
fi

# --- 3. Object dump ----------------------------------------------------------
# Every live UObject. Huge (can be >100 MB), so only matching lines are kept.
OBJDUMP=""
for cand in "$UE4SS_DIR/UE4SS_ObjectDump.txt" "$UE4SS_DIR/ObjectDump.txt"; do
    [ -f "$cand" ] && { OBJDUMP="$cand"; break; }
done
if [ -n "$OBJDUMP" ]; then
    grep -E "$KEYWORDS" "$OBJDUMP" > "$OUT/objectdump.filtered.txt" 2>/dev/null || true
    lines=$(wc -l < "$OUT/objectdump.filtered.txt" 2>/dev/null || echo 0)
    echo "-- object dump: $lines matching line(s) -> $OUT/objectdump.filtered.txt"
    found_any=1
else
    echo "MISSING: UE4SS_ObjectDump.txt (run \"Dump Objects & Properties\")"
fi

# --- 4. The mod's own log ----------------------------------------------------
if [ -f "$UE4SS_DIR/UE4SS.log" ]; then
    grep -E 'HRLK|RegisterHook|Registered native hook' "$UE4SS_DIR/UE4SS.log" \
        > "$OUT/ue4ss.hrlk.log" 2>/dev/null || true
    echo "-- mod log slice -> $OUT/ue4ss.hrlk.log"
fi

# --- summary -----------------------------------------------------------------
if [ "$found_any" = 0 ]; then
    echo
    echo "No dumps found. Produce them first (see the header of this script),"
    echo "then run this again."
    exit 1
fi

# Compress anything oversized so the repo stays sane.
total=$(du -sm "$OUT" 2>/dev/null | cut -f1)
echo "-- collected size: ${total} MB"
if [ "${total:-0}" -gt 40 ]; then
    echo "-- over 40 MB: gzipping the large files"
    find "$OUT" -type f -size +2M -not -name '*.gz' -exec gzip -f {} \;
    echo "-- new size: $(du -sm "$OUT" | cut -f1) MB"
fi

cat <<EOF

== Done ==
Collected into: $OUT

Send it to the dev branch:
    cd "$here"
    git add discovery/dumps
    git commit -m "Add UE4SS reflection dumps from the Steam Deck"
    git push -u origin claude/halo-campaign-evolved-mod-ber2my
EOF
