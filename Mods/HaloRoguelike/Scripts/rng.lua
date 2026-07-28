-- rng.lua — deterministic, seedable PRNG plus shareable seed strings.
--
-- Runs are reproducible: the same seed string always yields the same run.
-- UE4SS embeds Lua 5.4, so 64-bit integers and bitwise operators are available.

local Rng = {}
Rng.__index = Rng

-- Seed string alphabet: no 0/O/1/I/L to keep seeds readable off a screenshot.
local ALPHABET = "23456789ABCDEFGHJKMNPQRSTUVWXYZ"

local MASK64 = 0xFFFFFFFFFFFFFFFF

-- FNV-1a over the seed string -> 64-bit PRNG state.
local function fnv1a(str)
    local hash = 0xcbf29ce484222325
    for i = 1, #str do
        hash = hash ~ str:byte(i)
        hash = (hash * 0x100000001b3) & MASK64
    end
    return hash
end

-- xorshift64* — small, fast, plenty good for shuffling 5 missions.
local function next_u64(state)
    local x = state
    x = x ~ (x >> 12)
    x = x ~ ((x << 25) & MASK64)
    x = x ~ (x >> 27)
    x = x & MASK64
    return x, (x * 0x2545F4914F6CDD1D) & MASK64
end

function Rng.new(seed_string)
    local self = setmetatable({}, Rng)
    self.seed_string = seed_string
    self.state = fnv1a(seed_string)
    if self.state == 0 then self.state = 0x9E3779B97F4A7C15 end
    return self
end

-- Integer in [lo, hi] inclusive.
function Rng:int(lo, hi)
    local out
    self.state, out = next_u64(self.state)
    -- Use the high bits; low bits of xorshift* are weaker.
    return lo + ((out >> 16) % (hi - lo + 1))
end

-- Pick and remove a random element from a list.
function Rng:draw(list)
    if #list == 0 then return nil end
    return table.remove(list, self:int(1, #list))
end

-- Fisher-Yates in place.
function Rng:shuffle(list)
    for i = #list, 2, -1 do
        local j = self:int(1, i)
        list[i], list[j] = list[j], list[i]
    end
    return list
end

-- Fresh shareable seed like "HALO-7K2M-QX9". Entropy source is os.time/clock
-- only — this seeds the *string*; the run itself derives purely from the string.
function Rng.generate_seed_string()
    local entropy = math.floor((os.time() * 1000 + (os.clock() * 100000)) % MASK64)
    local salt = fnv1a(tostring(entropy) .. tostring({}))
    local chars = {}
    for i = 1, 7 do
        salt, entropy = next_u64(salt)
        chars[i] = ALPHABET:sub((entropy >> 16) % #ALPHABET + 1,
                                (entropy >> 16) % #ALPHABET + 1)
    end
    return string.format("HALO-%s-%s",
        table.concat(chars, "", 1, 4), table.concat(chars, "", 5, 7))
end

-- Validate/normalise a user-entered seed. Accepts lowercase and missing dashes.
function Rng.normalize_seed_string(s)
    if type(s) ~= "string" then return nil end
    s = s:upper():gsub("[^%w]", "")
    s = s:gsub("^HALO", "")
    if #s ~= 7 then return nil end
    for i = 1, #s do
        if not ALPHABET:find(s:sub(i, i), 1, true) then return nil end
    end
    return string.format("HALO-%s-%s", s:sub(1, 4), s:sub(5, 7))
end

return Rng
