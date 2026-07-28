-- saveguard.lua — Layer 3: campaign save protection.
--
-- Activating skulls requires Campaign -> New Game, which OVERWRITES the solo
-- campaign save. This module backs the save up before a run ever touches New
-- Game, and restores it when the run mode exits. Per the brief this is the
-- number one way testers lose progress, so:
--   * starting a run without a verified backup is a hard error, and
--   * restore is reachable at any time via the emergency hotkey (F9).
--
-- Backups are plain copies of <Saved>\SaveGames into
-- <Saved>\HaloRoguelike\SaveBackups\<timestamp>\, made with xcopy through
-- cmd.exe (available under Proton), then verified by recursive file count.

local Config = require("config")
local Log    = require("log")
local Paths  = require("paths")
local Json   = require("json")

local Saveguard = {}

local MARKER = "backup_manifest.json"

local function backup_root()
    local dir = Paths.backups_dir()
    if dir and not Paths.dir_exists(dir) then Paths.mkdir(dir) end
    return dir
end

local function write_manifest(dir, manifest)
    local f = io.open(Paths.join(dir, MARKER), "w")
    if not f then return false end
    f:write(Json.encode(manifest))
    f:close()
    return true
end

local function read_manifest(dir)
    local f = io.open(Paths.join(dir, MARKER), "r")
    if not f then return nil end
    local raw = f:read("a")
    f:close()
    return Json.decode(raw)
end

-- List existing backups, oldest first (timestamp dir names sort naturally).
function Saveguard.list_backups()
    local root = backup_root()
    if not root then return {} end
    local dirs = Paths.list_dirs(root)
    table.sort(dirs)
    return dirs
end

local function prune_old_backups()
    local backups = Saveguard.list_backups()
    local root = backup_root()
    while #backups > Config.max_save_backups do
        local victim = table.remove(backups, 1)
        Log.info("saveguard: pruning old backup %s", victim)
        Paths.cmd('rmdir /s /q ' .. Paths.q(Paths.join(root, victim)))
    end
end

-- Create a verified backup. Returns backup dir name on success, nil + reason
-- on failure. Callers MUST treat nil as "do not start the run".
function Saveguard.backup()
    local src = Paths.savegames_dir()
    local root = backup_root()
    if not src or not root then
        return nil, "could not resolve save paths (LOCALAPPDATA unset?)"
    end
    if not Paths.dir_exists(src) then
        -- No campaign save at all: nothing to protect, record that fact so
        -- restore knows to skip.
        Log.warn("saveguard: no SaveGames directory found at %s", src)
        return "NO_SAVE", nil
    end

    local stamp = os.date("%Y%m%d-%H%M%S")
    local dest = Paths.join(root, stamp)
    Paths.mkdir(dest)

    local src_count = Paths.count_files(src)
    Log.info("saveguard: backing up %d file(s) %s -> %s", src_count, src, dest)
    Paths.cmd('xcopy ' .. Paths.q(src) .. ' ' .. Paths.q(dest) .. ' /E /I /Y /Q')

    local dest_count = Paths.count_files(dest)
    if dest_count < src_count then
        Log.error("saveguard: backup INCOMPLETE (%d of %d files); refusing to proceed",
            dest_count, src_count)
        return nil, string.format("backup incomplete: %d of %d files copied",
            dest_count, src_count)
    end

    write_manifest(dest, {
        created    = os.date("%Y-%m-%dT%H:%M:%S"),
        source     = src,
        file_count = src_count,
    })
    prune_old_backups()
    Log.info("saveguard: backup verified (%d files) at %s", dest_count, dest)
    return stamp, nil
end

-- Restore the given backup (or the newest one) over SaveGames.
-- Safe to call at any time; used by the F9 emergency hotkey and on run exit.
function Saveguard.restore(which)
    local root = backup_root()
    local dst = Paths.savegames_dir()
    if not root or not dst then
        return false, "could not resolve save paths"
    end

    local backups = Saveguard.list_backups()
    if #backups == 0 then
        return false, "no backups exist"
    end
    local name = which or backups[#backups]
    local src = Paths.join(root, name)
    local manifest = read_manifest(src)
    if not manifest then
        Log.warn("saveguard: backup %s has no manifest; restoring anyway", name)
    end

    Log.info("saveguard: restoring backup %s -> %s", src, dst)
    Paths.cmd('xcopy ' .. Paths.q(src) .. ' ' .. Paths.q(dst) .. ' /E /I /Y /Q')
    -- The manifest file itself gets copied along; remove it from the live dir.
    Paths.cmd('del /q ' .. Paths.q(Paths.join(dst, MARKER)))

    local expected = manifest and manifest.file_count or nil
    local got = Paths.count_files(dst)
    if expected and got < expected then
        Log.error("saveguard: restore INCOMPLETE (%d of %d files)", got, expected)
        return false, string.format("restore incomplete: %d of %d files", got, expected)
    end
    Log.info("saveguard: restore complete (%d files)", got)
    return true, nil
end

return Saveguard
