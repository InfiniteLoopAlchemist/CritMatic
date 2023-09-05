local AceDB = LibStub("AceDB-3.0")

-- Default values for the database
local defaults = {
    profile = {
        soundSettings = {
            damageNormal = "CritMatic: Heroism Cast", -- Default sound for normal damage
            damageCrit = "CritMatic: Level Up",   -- Default sound for critical damage
            healNormal = "CritMatic: Heaven",   -- Default sound for normal heal
            healCrit = "CritMatic: Level Up"      -- Default sound for critical heal
        }
    }
}

-- Initialize the AceDB database
CritMaticDB = AceDB:New("CritMaticDB", defaults)
