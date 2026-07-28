-- presets.lua — the "Legendary+" nerf preset for floors 4-5.
--
-- There is no Legendary+ tier in the game; escalation past Legendary is done
-- through the difficulty-modifier player traits (brief §6.2). The traits are
-- applied LIVE on the HaloUserSettings object via gameapi.lua — never by
-- writing HaloGlobalGameUserSettings.ini, which the game rewrites on exit.
--
-- The preset is surfaced to the player as literal numbers (see `describe`),
-- not as a mystery tier, so it doesn't read as the game cheating.

local Presets = {}

-- Property names/values follow the enum reference in the brief. gameapi.lua
-- writes these onto PlayerTraits3 and sets ModifierPreset=Preset03, keeping
-- slots 1/2/4 untouched for the player's own presets.
Presets.SLOT = 3
Presets.MODIFIER_PRESET_VALUE = "Preset03"

Presets.NERF = {
    VitalityTraits = {
        DamageResistancePercentageSetting    = "Percent50",
        ShieldRechargeRatePercentageSetting  = "PercentNegative10",
    },
    WeaponTraits = {
        DamageModifierPercentageSetting      = "Percent75",
    },
}

-- Human-readable lines for the UI (floor cards for floors 4-5).
function Presets.describe()
    return {
        "Player damage resistance: 50% (half as tough)",
        "Shield recharge rate: -10%",
        "Player weapon damage: 75%",
    }
end

return Presets
