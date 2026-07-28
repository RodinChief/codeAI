# Extras — ready-made files for manual installation

Only needed if you install by hand instead of running `tools/install.sh`
(the script creates these automatically).

## Game.ini — enables the in-game debug menu (`G` key)

Copy `Game.ini` from this folder to:

```
~/.local/share/Steam/steamapps/compatdata/2806050/pfx/drive_c/users/steamuser/AppData/Local/Meteorite/Saved/Config/Windows/Game.ini
```

One-liner from this folder (creates the directory if the game hasn't made it
yet, then makes the file read-only so the game can't overwrite it on exit):

```bash
DEST="$HOME/.local/share/Steam/steamapps/compatdata/2806050/pfx/drive_c/users/steamuser/AppData/Local/Meteorite/Saved/Config/Windows"
mkdir -p "$DEST" && cp Game.ini "$DEST/Game.ini" && chmod 444 "$DEST/Game.ini"
```

If a `Game.ini` already exists there with your own settings in it, merge the
`[/Script/Meteorite.DebugMenuSettings]` section into it instead of replacing
the file.
