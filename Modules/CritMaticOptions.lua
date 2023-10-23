local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

function ResetSoundsToDefault()
  db.profile.soundSettings = defaults.profile.soundSettings
end

function ResetFontSettingsToDefault()
  db.profile.fontSettings = defaults.profile.fontSettings
end

local options = {
  name = "CritMatic Options",
  type = "group",

  args = {
    generalSettings = {
      name = "General Settings",
      type = "group",
      args = {
        discordLink = {
          name = "Help/Suggestions Discord Link",
          desc = "Get help or make a suggestion, Just Copy this link to join our Discord server.",
          type = "input",
          width='full',
          get = function() return "https://discord.gg/34JJyrnGGC" end,  -- Replace with your actual Discord link
          set = function(_, val)  -- Do nothing when the user tries to modify it

          end,
        },

      }
    },
    alertNotificationSettings = {
      name = "Alert Notification Settings",
      type = "group",
      args = {

        alertPositionX = {
          name = "Position X Horizontal",
          desc = "Adjust the horizontal (X) coordinate for alert messages. Enter a positive number to move the messages to the right, and a negative number to move them to the left. The default value is 0, which centers the messages.",
          type = "input",
          order = 1,
          set = function(_, val) db.profile.alertNotificationSettings.alertPositionX = tonumber(val) end,
          get = function() return tostring(db.profile.alertNotificationSettings.alertPositionX) end,
        },
        alertPositionY = {
          name = "Position Y Vertical",
          desc = "Adjust the vertical (Y) coordinate for alert messages. Enter a positive number to move the messages upward, and a negative number to move them downward. The default value is 350, positioning the messages near the top of the screen.",
          type = "input",
          order = 2,
          set = function(_, val) db.profile.alertNotificationSettings.alertPositionY = tonumber(val) end,
          get = function() return tostring(db.profile.alertNotificationSettings.alertPositionY) end,
        },
       maxAlerts = {
          type = 'range',
          name = 'Max Alert Notifications - Requires Reload',
          desc = 'Set the max alert notifications you want displayed at a time. Requires Reload',
          min = 2,
          max = 6,
          step = 1,
          order = 3,
          width = '600',
          get = function()
            return db.profile.alertNotificationSettings.maxAlerts
          end,
          set = function(_, value)
            db.profile.alertNotificationSettings.maxAlerts = tonumber(value)
          end,
        },

      }
    },
    font = {
      name = "Font Settings",
      type = "group",
      args = {
        font = {
          name = "Font",
          type = "select",
          desc = "You might have to select the font twice to see all the fonts.",
          dialogControl = "LSM30_Font",
          values = LSM:HashTable("font"),
          width = "full",
          order = 2,
          get = function()
            return db.profile.fontSettings.font
          end,
          set = function(_, newVal)
            db.profile.fontSettings.font = newVal
          end,
        },
        fontSize = {
          name = "Font Size",
          type = "range",
          min = 8,
          max = 32,
          step = 1,
          order = 5,
          width = "full",
          get = function()
            return db.profile.fontSettings.fontSize
          end,
          set = function(_, newVal)
            db.profile.fontSettings.fontSize = newVal
          end,
        },
        fontColorCrit = {
          type = "color",
          name = "Crit Color",
          desc = "Choose a Crit color for your font",
          order = 3,
          hasAlpha = false,
          width = "normal",
          get = function(info)
            local r, g, b = unpack(db.profile.fontSettings.fontColorCrit)
            return r, g, b
          end,
          set = function(info, r, g, b)
            db.profile.fontSettings.fontColorCrit = { r, g, b }
          end,
        },
        fontColor = {
          type = "color",
          name = "Color (Non-Crit)",
          desc = "Choose a (Non-Crit) color for your font",
          order = 4,
          width = "200",
          hasAlpha = false, -- set to true if you want an alpha slider (for transparency)
          get = function(info)
            local r, g, b = unpack(db.profile.fontSettings.fontColor)
            return r, g, b
          end,
          set = function(info, r, g, b)
            db.profile.fontSettings.fontColor = { r, g, b }
          end,
        },
        fontOutline = {
          name = "Outline",
          type = "select",
          values = {
            ["NONE"] = "None",
            ["OUTLINE"] = "Outline",
            ["THICKOUTLINE"] = "Thick Outline",
          },
          width = "full",
          order = 5,
          get = function()
            return db.profile.fontSettings.fontOutline
          end,
          set = function(_, newVal)
            db.profile.fontSettings.fontOutline = newVal
          end,
        },
        fontShadowSizeX = {
          type = 'range',
          name = 'Shadow Size X',
          desc = 'Set the shadow size for the font in the horizontal direction.',
          min = -10,
          max = 10,
          width = "normal",
          step = 1,
          order = 6,
          get = function()
            return db.profile.fontSettings.fontShadowSize[1]
          end,
          set = function(_, value)
            db.profile.fontSettings.fontShadowSize[1] = value
          end,
        },

        fontShadowSizeY = {
          type = 'range',
          name = 'Shadow Size Y',
          desc = 'Set the shadow size for the font in the vertical direction.',
          min = -10,
          max = 10,
          step = 1,
          order = 7,
          width = "3",
          get = function()
            return db.profile.fontSettings.fontShadowSize[2]
          end,
          set = function(_, value)
            db.profile.fontSettings.fontShadowSize[2] = value
          end,
        },
        fontShadowColor = {
          type = 'color',
          name = 'Shadow Color',
          desc = 'Set the shadow color for the font.',
          hasAlpha = false,
          order = 8,
          get = function()
            return unpack(db.profile.fontSettings.fontShadowColor)
          end,
          set = function(_, r, g, b)
            db.profile.fontSettings.fontShadowColor = { r, g, b }
          end,
        },
        resetFontSettings = {
          name = "Reset Font Settings",
          desc = "Reset all Font settings to their default values",
          width = "full",
          type = "execute",
          func = ResetFontSettingsToDefault,
          confirm = true,
          confirmText = "Are you sure you want to reset font settings to their default values?",
          order = 9,
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
            return db.profile.soundSettings.damageNormal
          end,
          set = function(_, newVal)
            db.profile.soundSettings.damageNormal = newVal
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
            return db.profile.soundSettings.damageCrit
          end,
          set = function(_, newVal)
            db.profile.soundSettings.damageCrit = newVal
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
            return db.profile.soundSettings.healNormal
          end,
          set = function(_, newVal)
            db.profile.soundSettings.healNormal = newVal
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
            return db.profile.soundSettings.healCrit
          end,
          set = function(_, newVal)
            db.profile.soundSettings.healCrit = newVal
          end,
        },
        muteAllSounds = {
          name = "Mute All Sounds",
          desc = "Do you want to mute all sounds regardless of settings?",
          type = "toggle",
          set = function(_, newVal) db.profile.soundSettings.muteAllSounds = newVal
          end,
          get = function() return db.profile.soundSettings.muteAllSounds end,
        },
        resetSounds = {
          name = "Reset Sounds to Default",
          desc = "Reset all sounds",
          width = "full",
          type = "execute",
          func = ResetSoundsToDefault,
          confirm = true,
          confirmText = "Are you sure you want to reset sound settings to their default values?",
          order = 6,
        },
      },
    },
    miscellaneous = {
      name = "Miscellaneous Settings",
      type = "group",
      order= 100,
      args = {
        autoAttacksEnabled = {
          name = "Track Auto Attacks",
          desc = "Track Auto Attacks?",
          type = "toggle",
          set = function(_, newVal) db.profile.miscellaneous.autoAttacksEnabled = newVal
          end,
          get = function() return db.profile.miscellaneous.autoAttacksEnabled end,
        }
      }
    },
    social ={
      name = "Social Settings",
      type = "group",
      args = {
        chatNotificationsEnabled = {
          name = "Show Chat Notifications",
          desc = "Do you want damage / heal chat messages for when you get a higher crit/normal hit/heal?",
          type = "toggle",
          set = function(_, newVal) db.profile.social.chatNotificationsEnabled = newVal
          end,
          get = function() return db.profile.social.chatNotificationsEnabled end,
        },
        alertNotificationsEnabled = {
          name = "Show Alert Notifications",
          desc = "Do you want damage / heal alerts messages for when you get a higher crit/normal hit/heal?",
          type = "toggle",
          set = function(_, newVal) db.profile.social.alertNotificationsEnabled = newVal
          end,
          get = function() return db.profile.social.alertNotificationsEnabled end,
        },
      }
    }
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


