-- log.lua — logging helper.
-- Everything goes through here so a single playtest yields a readable UE4SS.log.
-- Prefix makes `grep HRLK UE4SS.log` pull out only this mod's output.

local Log = {}

local PREFIX = "[HRLK] "

local function stamp()
    return os.date("%H:%M:%S")
end

function Log.info(fmt, ...)
    print(string.format(PREFIX .. "%s " .. fmt .. "\n", stamp(), ...))
end

function Log.warn(fmt, ...)
    print(string.format(PREFIX .. "%s WARN " .. fmt .. "\n", stamp(), ...))
end

function Log.error(fmt, ...)
    print(string.format(PREFIX .. "%s ERROR " .. fmt .. "\n", stamp(), ...))
end

-- Discovery output: always tagged so it can be grepped separately.
function Log.discover(fmt, ...)
    print(string.format(PREFIX .. "%s DISCOVER " .. fmt .. "\n", stamp(), ...))
end

return Log
