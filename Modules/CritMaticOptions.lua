local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function ResetSoundsToDefault()
    CritMaticDB.profile.soundSettings.damageNormal = defaults.profile.soundSettings.damageNormal
    CritMaticDB.profile.soundSettings.damageCrit = defaults.profile.soundSettings.damageCrit
    CritMaticDB.profile.soundSettings.healNormal = defaults.profile.soundSettings.healNormal
    CritMaticDB.profile.soundSettings.healCrit = defaults.profile.soundSettings.healCrit
end

local options = {
    name = "CritMatic Options",
    type = "group",
    args = {
        sounds = {
            name = "Sound Settings",
            type = "group",
            args = {
                damageNormal = {
                    name = "Normal Damage Sound",
                    type = "select",
                    dialogControl = "LSM30_Sound",
                    values = LSM:HashTable("sound"),
                    width = "full",
                    get = function() return CritMaticDB.profile.soundSettings.damageNormal end,
                    set = function(_, newVal) CritMaticDB.profile.soundSettings.damageNormal = newVal end,
                },
                damageCrit = {
                                    name = "Critical Damage Sound",
                                    type = "select",
                                    dialogControl = "LSM30_Sound",
                                    values = LSM:HashTable("sound"),
                                    width = "full",
                                    get = function() return CritMaticDB.profile.soundSettings.damageCrit end,
                                    set = function(_, newVal) CritMaticDB.profile.soundSettings.damageCrit = newVal end,
                                },
               healNormal = {
                                   name = "Normal Heal Sound",
                                   type = "select",
                                   dialogControl = "LSM30_Sound",
                                   values = LSM:HashTable("sound"),
                                   width = "full",
                                   get = function() return CritMaticDB.profile.soundSettings.healNormal end,
                                   set = function(_, newVal) CritMaticDB.profile.soundSettings.healNormal = newVal end,
                               },
                healCrit = {
                                    name = "Critical Heal Sound",
                                    type = "select",
                                    dialogControl = "LSM30_Sound",
                                    values = LSM:HashTable("sound"),
                                    width = "full",
                                    get = function() return CritMaticDB.profile.soundSettings.healCrit end,
                                    set = function(_, newVal) CritMaticDB.profile.soundSettings.healCrit = newVal end,
                                },
            },
        },
    },
}

-- Register the options table with AceConfig
AceConfig:RegisterOptionsTable("CritMaticOptions", options)

-- Add to Blizzard's Interface Options
local blizzPanel = AceConfigDialog:AddToBlizOptions("CritMaticOptions", "CritMatic")

-- Hook into the Blizzard options panel to embed your custom control
hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)
    if frame == blizzPanel then
        -- You can initialize or reset any specific UI components here if necessary
    end
end)

-- If you still want the OpenConfigWindow function, define it separately
function OpenConfigWindow(container)
    -- Any custom code for the configuration window goes here
end
