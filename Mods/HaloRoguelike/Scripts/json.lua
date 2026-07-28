-- json.lua — minimal pure-Lua JSON encode/decode for run-state persistence.
-- Supports the subset this mod writes: objects, arrays, strings, numbers,
-- booleans, null. No unicode escapes beyond \uXXXX pass-through on decode.

local Json = {}

-- ---------------------------------------------------------------- encode

local encode_value

local function encode_string(s)
    local map = {
        ['"'] = '\\"', ['\\'] = '\\\\', ['\b'] = '\\b', ['\f'] = '\\f',
        ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t',
    }
    return '"' .. s:gsub('[%z\1-\31"\\]', function(c)
        return map[c] or string.format('\\u%04x', c:byte())
    end) .. '"'
end

local function is_array(t)
    local n = 0
    for k in pairs(t) do
        if type(k) ~= "number" then return false end
        n = n + 1
    end
    return n == #t
end

local function encode_table(t, indent)
    local pad = string.rep("  ", indent + 1)
    local closepad = string.rep("  ", indent)
    if next(t) == nil then return is_array(t) and "[]" or "{}" end
    local parts = {}
    if is_array(t) then
        for _, v in ipairs(t) do
            parts[#parts + 1] = pad .. encode_value(v, indent + 1)
        end
        return "[\n" .. table.concat(parts, ",\n") .. "\n" .. closepad .. "]"
    end
    local keys = {}
    for k in pairs(t) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do
        parts[#parts + 1] = pad .. encode_string(tostring(k)) .. ": "
            .. encode_value(t[k], indent + 1)
    end
    return "{\n" .. table.concat(parts, ",\n") .. "\n" .. closepad .. "}"
end

encode_value = function(v, indent)
    local tv = type(v)
    if v == nil then return "null" end
    if tv == "boolean" then return tostring(v) end
    if tv == "number" then
        if v ~= v or v == math.huge or v == -math.huge then return "null" end
        if math.type and math.type(v) == "integer" then return string.format("%d", v) end
        return string.format("%.14g", v)
    end
    if tv == "string" then return encode_string(v) end
    if tv == "table" then return encode_table(v, indent or 0) end
    error("json: cannot encode type " .. tv)
end

function Json.encode(v)
    return encode_value(v, 0)
end

-- ---------------------------------------------------------------- decode

local function decode_error(str, pos, msg)
    error(string.format("json: %s at position %d (near %q)",
        msg, pos, str:sub(pos, pos + 10)))
end

local decode_value

local function skip_ws(str, pos)
    local _, e = str:find("^[ \t\r\n]*", pos)
    return e + 1
end

local function decode_string(str, pos)
    local out, i = {}, pos + 1
    while i <= #str do
        local c = str:sub(i, i)
        if c == '"' then return table.concat(out), i + 1 end
        if c == '\\' then
            local esc = str:sub(i + 1, i + 1)
            local map = { ['"'] = '"', ['\\'] = '\\', ['/'] = '/', b = '\b',
                          f = '\f', n = '\n', r = '\r', t = '\t' }
            if map[esc] then
                out[#out + 1] = map[esc]; i = i + 2
            elseif esc == 'u' then
                local hex = str:sub(i + 2, i + 5)
                local cp = tonumber(hex, 16)
                if not cp then decode_error(str, i, "bad unicode escape") end
                out[#out + 1] = utf8 and utf8.char(cp) or string.char(cp % 256)
                i = i + 6
            else
                decode_error(str, i, "bad escape")
            end
        else
            out[#out + 1] = c; i = i + 1
        end
    end
    decode_error(str, pos, "unterminated string")
end

local function decode_number(str, pos)
    local num = str:match("^-?%d+%.?%d*[eE]?[+%-]?%d*", pos)
    local v = tonumber(num)
    if not v then decode_error(str, pos, "bad number") end
    return v, pos + #num
end

decode_value = function(str, pos)
    pos = skip_ws(str, pos)
    local c = str:sub(pos, pos)
    if c == '"' then return decode_string(str, pos) end
    if c == '{' then
        local obj = {}
        pos = skip_ws(str, pos + 1)
        if str:sub(pos, pos) == '}' then return obj, pos + 1 end
        while true do
            pos = skip_ws(str, pos)
            if str:sub(pos, pos) ~= '"' then decode_error(str, pos, "expected key") end
            local key; key, pos = decode_string(str, pos)
            pos = skip_ws(str, pos)
            if str:sub(pos, pos) ~= ':' then decode_error(str, pos, "expected ':'") end
            local val; val, pos = decode_value(str, pos + 1)
            obj[key] = val
            pos = skip_ws(str, pos)
            local d = str:sub(pos, pos)
            if d == ',' then pos = pos + 1
            elseif d == '}' then return obj, pos + 1
            else decode_error(str, pos, "expected ',' or '}'") end
        end
    end
    if c == '[' then
        local arr = {}
        pos = skip_ws(str, pos + 1)
        if str:sub(pos, pos) == ']' then return arr, pos + 1 end
        while true do
            local val; val, pos = decode_value(str, pos)
            arr[#arr + 1] = val
            pos = skip_ws(str, pos)
            local d = str:sub(pos, pos)
            if d == ',' then pos = pos + 1
            elseif d == ']' then return arr, pos + 1
            else decode_error(str, pos, "expected ',' or ']'") end
        end
    end
    if str:sub(pos, pos + 3) == "true" then return true, pos + 4 end
    if str:sub(pos, pos + 4) == "false" then return false, pos + 5 end
    if str:sub(pos, pos + 3) == "null" then return nil, pos + 4 end
    if c:match("[%-%d]") then return decode_number(str, pos) end
    decode_error(str, pos, "unexpected character")
end

function Json.decode(str)
    local ok, result = pcall(function()
        local v = select(1, decode_value(str, 1))
        return v
    end)
    if not ok then return nil, result end
    return result
end

return Json
