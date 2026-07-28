-- paths.lua — filesystem locations, resolved once.
--
-- The game runs under Proton, so from Lua's point of view this is Windows:
-- %LOCALAPPDATA% maps into the Wine prefix
-- (compatdata/2806050/pfx/drive_c/users/steamuser/AppData/Local).

local Config = require("config")
local Log    = require("log")

local Paths = {}

local function join(...)
    return table.concat({ ... }, "\\")
end

Paths.join = join

function Paths.local_appdata()
    local la = os.getenv("LOCALAPPDATA")
    if not la or la == "" then
        Log.error("LOCALAPPDATA is not set; cannot resolve save paths")
        return nil
    end
    return la
end

-- Game's saved-data root: <LOCALAPPDATA>\Meteorite\Saved
function Paths.saved_root()
    local la = Paths.local_appdata()
    return la and join(la, "Meteorite", "Saved") or nil
end

-- Campaign save games live here (this is what New Game overwrites).
function Paths.savegames_dir()
    local root = Paths.saved_root()
    return root and join(root, "SaveGames") or nil
end

-- The mod's own data dir: <LOCALAPPDATA>\Meteorite\Saved\HaloRoguelike
function Paths.mod_dir()
    local root = Paths.saved_root()
    return root and join(root, Config.state_dir_name) or nil
end

function Paths.run_state_file()
    local dir = Paths.mod_dir()
    return dir and join(dir, "run.json") or nil
end

function Paths.backups_dir()
    local dir = Paths.mod_dir()
    return dir and join(dir, "SaveBackups") or nil
end

-- Quote a path for cmd.exe.
function Paths.q(p)
    return '"' .. p .. '"'
end

-- Run a cmd.exe command line, capture stdout lines. Returns lines, ok.
function Paths.cmd(command)
    local f = io.popen('cmd /c ' .. command .. ' 2>nul')
    if not f then return {}, false end
    local lines = {}
    for line in f:lines() do
        line = line:gsub("\r$", "")
        if line ~= "" then lines[#lines + 1] = line end
    end
    local ok = f:close()
    return lines, ok == true
end

function Paths.dir_exists(p)
    local lines = Paths.cmd('if exist ' .. Paths.q(p .. "\\") .. ' echo YES')
    return lines[1] == "YES"
end

function Paths.file_exists(p)
    local f = io.open(p, "rb")
    if f then f:close() return true end
    return false
end

function Paths.mkdir(p)
    Paths.cmd('mkdir ' .. Paths.q(p))
    return Paths.dir_exists(p)
end

-- Recursive file count, for backup verification.
function Paths.count_files(p)
    local lines = Paths.cmd('dir /b /s /a-d ' .. Paths.q(p))
    return #lines
end

-- List immediate subdirectory names.
function Paths.list_dirs(p)
    return Paths.cmd('dir /b /ad ' .. Paths.q(p))
end

return Paths
