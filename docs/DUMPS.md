# Getting the game's full structure to the developer

This mod talks to the game purely through UE4SS reflection: it looks up
classes by name and calls their functions at runtime. Every name and every
parameter list has, so far, been *guessed* and then verified by a playtest.
That is slow and it is why some rounds fail on something as small as a
function wanting two parameters instead of one.

UE4SS can dump the game's **entire reflected API** to disk. With those dumps
committed to the repo, the guessing stops: class names, function signatures,
struct layouts and enum values (including all 42 skull names) can be read
directly.

## Step 1 — produce the dumps (on the Steam Deck, once)

1. Launch the game with UE4SS active and stay on the **main menu**.
   Dumping from the main menu is deliberate: the front-end objects this mod
   drives are loaded there.
2. Bring up the **UE4SS GUI console** window (`tools/install.sh` enables it).
3. Go to the **Dumpers** tab and press, in this order:

   | Button | Produces | Why it matters |
   |---|---|---|
   | Generate Lua Types | `ue4ss/Mods/shared/types/*.lua` | every class + **full function signatures** — kills the parameter guessing |
   | Generate C++ Headers | `ue4ss/CXXHeaderDump/` | struct layouts and **enums** (skull ids, difficulty, insertion points) |
   | Dump Objects & Properties | `ue4ss/UE4SS_ObjectDump.txt` | every live object with its real path name |

   The game freezes for a while during each dump — that is normal. Wait for
   the GUI to respond again before pressing the next one.
4. Quit the game.

If the button labels differ slightly in this UE4SS fork, use whatever is in
the Dumpers tab; the collector script searches for the output files rather
than assuming exact names.

## Step 2 — collect and send

```bash
cd ~/path/to/this/repo
GAMEDIR="/run/media/deck/SN512/steamapps/common/Halo Campaign Evolved" \
    ./tools/collect_dumps.sh
```

The script filters the dumps down to what this mod needs (campaign, scenario,
insertion point, skull, difficulty, modifier, cinematic, lobby …), gzips
anything large, and writes everything to `discovery/dumps/`.

Then commit and push:

```bash
git add discovery/dumps
git commit -m "Add UE4SS reflection dumps from the Steam Deck"
git push -u origin claude/halo-campaign-evolved-mod-ber2my
```

## What this unlocks

Concretely, the open problems these dumps are expected to close:

- **Rally points** — the real insertion-point API and the `MapInfo` /
  `BlamScenarioGameOptions` layout, instead of probing two candidate launch
  functions per playtest.
- **Skulls** — the actual skull enum (all 42 values with their internal
  names), so `const.lua`'s guessed skull pool can be replaced with real ids,
  and the set type that `SetClientLobbySkulls` expects.
- **Cutscenes** — the cinematic subsystem's real skip/disable entry point.
- **Mission complete / death** — the campaign state class that fires on
  mission end, replacing the current manual "mark floor complete" fallback
  and the `ClientRestart` death heuristic.

## Alternative: no dumps, still useful

If the Dumpers tab is unavailable, the in-game **F7** discovery pass already
logs a filtered slice of the same information to `UE4SS.log`. It is far less
complete — it only sees objects that happen to be loaded at that moment — but
pasting that log has been the working method so far.
