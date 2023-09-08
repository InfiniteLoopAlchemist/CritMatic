local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

function ResetSoundsToDefault()
  CritMaticDB.profile.soundSettings = defaults.profile.soundSettings
end

function ResetFontSettingsToDefault()
  CritMaticDB.profile.fontSettings = defaults.profile.fontSettings
end

local options = {
  name = "CritMatic Options",
  type = "group",

  args = {
    font = {
      name = "Font Settings",
      type = "group",
      args = {
        font = {
          name = "Font",
          type = "select",
          dialogControl = "LSM30_Font",
          values = LSM:HashTable("font"),
          width = "full",
          order = 1,
          get = function()
            return CritMaticDB.profile.fontSettings.font
          end,
          set = function(_, newVal)
            CritMaticDB.profile.fontSettings.font = newVal
          end,
        },
        fontSize = {
          name = "Font Size",
          type = "range",
          min = 8,
          max = 32,
          step = 1,
          order = 4,
          width = "full",
          get = function()
            return CritMaticDB.profile.fontSettings.fontSize
          end,
          set = function(_, newVal)
            CritMaticDB.profile.fontSettings.fontSize = newVal
          end,
        },
        fontColorCrit = {
          type = "color",
          name = "Crit Font Color",
          desc = "Choose a Crit color for your font",
          order = 2,
          hasAlpha = false,
          width = "normal",
          get = function(info)
            local r, g, b = unpack(CritMaticDB.profile.fontSettings.fontColorCrit)
            return r, g, b
          end,
          set = function(info, r, g, b)
            CritMaticDB.profile.fontSettings.fontColorCrit = { r, g, b }
          end,
        },
        fontColor = {
          type = "color",
          name = "Font Color (Non-Crit)",
          desc = "Choose a (Non-Crit) color for your font",
          order = 3,
          width = "200",
          hasAlpha = false, -- set to true if you want an alpha slider (for transparency)
          get = function(info)
            local r, g, b = unpack(CritMaticDB.profile.fontSettings.fontColor)
            return r, g, b
          end,
          set = function(info, r, g, b)
            CritMaticDB.profile.fontSettings.fontColor = { r, g, b }
          end,
        },
        fontOutline = {
          name = "Font Outline",
          type = "select",
          values = {
            ["NONE"] = "None",
            ["OUTLINE"] = "Outline",
            ["THICKOUTLINE"] = "Thick Outline",
          },
          width = "full",
          order = 4,
          get = function()
            return CritMaticDB.profile.fontSettings.fontOutline
          end,
          set = function(_, newVal)
            CritMaticDB.profile.fontSettings.fontOutline = newVal
            frame:SetStatusText("test")
          end,
        },
        resetFontSettings = {
          name = "Reset Font Settings to Default",
          desc = "Reset all Font settings to their default values",
          width = "full",
          type = "execute",
          func = ResetFontSettingsToDefault,
          confirm = true,
          confirmText = "Are you sure you want to reset font settings to their default values?",
          order = 5,
        },

      },

    },
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
          order = 2,
          get = function()
            return CritMaticDB.profile.soundSettings.damageNormal
          end,
          set = function(_, newVal)
            CritMaticDB.profile.soundSettings.damageNormal = newVal
          end,
        },
        damageCrit = {
          name = "Critical Damage Sound",
          type = "select",
          dialogControl = "LSM30_Sound",
          values = LSM:HashTable("sound"),
          width = "full",
          order = 1,
          get = function()
            return CritMaticDB.profile.soundSettings.damageCrit
          end,
          set = function(_, newVal)
            CritMaticDB.profile.soundSettings.damageCrit = newVal
          end,
        },
        healNormal = {
          name = "Normal Heal Sound",
          type = "select",
          dialogControl = "LSM30_Sound",
          values = LSM:HashTable("sound"),
          width = "full",
          order = 4,
          get = function()
            return CritMaticDB.profile.soundSettings.healNormal
          end,
          set = function(_, newVal)
            CritMaticDB.profile.soundSettings.healNormal = newVal
          end,
        },
        healCrit = {
          name = "Critical Heal Sound",
          type = "select",
          dialogControl = "LSM30_Sound",
          values = LSM:HashTable("sound"),
          width = "full",
          order = 3,
          get = function()
            return CritMaticDB.profile.soundSettings.healCrit
          end,
          set = function(_, newVal)
            CritMaticDB.profile.soundSettings.healCrit = newVal
          end,
        },
        resetSounds = {
          name = "Reset Sounds to Default",
          desc = "Reset all sounds to their default values",
          width = "full",
          type = "execute",
          func = ResetSoundsToDefault,
          confirm = true,
          confirmText = "Are you sure you want to reset sound settings to their default values?",
          order = 5,
        },
      },
    },
  },
}

-- Register the options table
AceConfig:RegisterOptionsTable("CritMaticOptions", options)

-- Add to Blizzard's Interface Options
local blizzPanel = AceConfigDialog:AddToBlizOptions("CritMaticOptions", "CritMatic")

-- Hook into the Blizzard options panel.
hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)
  if frame == blizzPanel then
    --
  end
end)


