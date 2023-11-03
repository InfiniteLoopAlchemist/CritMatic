local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

function ResetSoundsToDefault()
  Critmatic.db.profile.soundSettings = defaults.profile.soundSettings
end

function ResetFontSettingsToDefault()
  Critmatic.db.profile.fontSettings = defaults.profile.fontSettings
end
function ResetChangeLogFontSettingsToDefault()
  Critmatic.db.profile.changeLogPopUp.fontSettings = defaults.profile.changeLogPopUp.fontSettings
end
function ResetChangeLogBorderAndBackgroundSettingsToDefault()
  Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings = defaults.profile.changeLogPopUp.borderAndBackgroundSettings
end

local allowedBorderTextures = {
  "Blizzard Achievement Wood",
  "Blizzard Tooltip",
  "Blizzard Dialog",
  "Blizzard Dialog Gold",
  "None",

}

-- Fetch the full list of border textures from SharedMedia
local allBorderTextures = LSM:HashTable("border")

-- Create a filtered list of allowed border textures
local allowedBorderTexturesForConfig = {}
for _, textureName in ipairs(allowedBorderTextures) do
  if allBorderTextures[textureName] then
    allowedBorderTexturesForConfig[textureName] = allBorderTextures[textureName]
  end
end
-- Fetch the full list of border textures from SharedMedia
local allBackgrounds = LSM:HashTable("background")

-- Define a list of borders to exclude
local excludeList = {
  ["None"] = true
}

-- Create a filtered list of borders
local filteredBackgrounds = {}
for name, _ in pairs(allBackgrounds) do
  if not excludeList[name] then
    filteredBackgrounds[name] = allBackgrounds[name]
  end
end



local options = {
  name = "CritMatic Options",
  type = "group",

  args = {
    generalSettings = {
      name = "General",
      type = "group",
      order = 1,
      args = {
        autoAttacksEnabled = {
          name = "Track Auto Attacks",
          desc = "Do you want to track auto attacks?",
          type = "toggle",
          order = 1,
          set = function(_, newVal)
            Critmatic.db.profile.generalSettings.autoAttacksEnabled = newVal
          end,
          get = function()
            return Critmatic.db.profile.generalSettings.autoAttacksEnabled
          end,
        },
        chatNotificationsEnabled = {
          name = "Show Chat Notifications",
          desc = "Do you want damage / heal chat messages for when you get a higher crit/normal hit/heal?",
          type = "toggle",
          order = 2,
          set = function(_, newVal)
            Critmatic.db.profile.generalSettings.chatNotificationsEnabled = newVal
          end,
          get = function()
            return Critmatic.db.profile.generalSettings.chatNotificationsEnabled
          end,
        },
        alertNotificationsEnabled = {
          name = "Show Alert Notifications",
          desc = "Do you want damage / heal alerts messages for when you get a higher crit/normal hit/heal?",
          type = "toggle",
          order = 3,
          set = function(_, newVal)
            Critmatic.db.profile.generalSettings.alertNotificationsEnabled = newVal
          end,
          get = function()
            return Critmatic.db.profile.generalSettings.alertNotificationsEnabled
          end,
        },
        isChangeLogAutoPopUpEnabled = {
          name = "Show Change Log ",
          desc = "Do you want the change log to auto show when a new version comes out?",
          type = "toggle",
          order = 4,
          set = function(_, newVal)
            Critmatic.db.profile.generalSettings.isChangeLogAutoPopUpEnabled = newVal
          end,
          get = function()
            return Critmatic.db.profile.generalSettings.isChangeLogAutoPopUpEnabled
          end,
        },
        discordLink = {
          name = "Help/Suggestions: Copy the CritMatic Discord Link",
          desc = "Get help or make a suggestion, Just Copy this link to join our Discord server.",
          type = "input",
          order = 5,
          width = 'full',
          get = function()
            return "https://discord.gg/34JJyrnGGC"
          end, -- Replace with your actual Discord link
          set = function(_, _)
            -- Do nothing when the user tries to modify it

          end,
        },

      }
    },
    font = {
      name = "Alert Font Settings",
      type = "group",
      order = 2,
      args = {
        font = {
          name = "Font",
          type = "select",
          desc = "You might have to select the font twice to see all the fonts.",
          dialogControl = "LSM30_Font",
          values = LSM:HashTable("font"),
          width = "full",
          order = 1,
          get = function()
            return Critmatic.db.profile.fontSettings.font
          end,
          set = function(_, newVal)
            Critmatic.db.profile.fontSettings.font = newVal
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
            return Critmatic.db.profile.fontSettings.fontSize
          end,
          set = function(_, newVal)
            Critmatic.db.profile.fontSettings.fontSize = newVal
          end,
        },
        fontColorCrit = {
          type = "color",
          name = "Crit Color",
          desc = "Choose a Crit color for your font",
          order = 2,
          hasAlpha = false,
          width = "normal",
          get = function(_)
            local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
            return r, g, b
          end,
          set = function(_, r, g, b)
            Critmatic.db.profile.fontSettings.fontColorCrit = { r, g, b }
          end,
        },
        fontColor = {
          type = "color",
          name = "Color (Non-Crit)",
          desc = "Choose a (Non-Crit) color for your font",
          order = 3,
          width = "200",
          hasAlpha = false, -- set to true if you want an alpha slider (for transparency)
          get = function(_)
            local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
            return r, g, b
          end,
          set = function(_, r, g, b)
            Critmatic.db.profile.fontSettings.fontColor = { r, g, b }
          end,
        },
        fontOutline = {
          name = "Outline",
          type = "select",
          values = {
            ["NONE"] = "None",
            ["OUTLINE"] = "Outline",
            ["OUTLINEMONOCHROME"] = "Outline Monochrome",
            ["THICKOUTLINE"] = "Thick Outline",
            ["THICKOUTLINEMONOCHROME"] = "Thick Outline Monochrome",
          },
          width = "full",
          order = 4,
          get = function()
            return Critmatic.db.profile.fontSettings.fontOutline
          end,
          set = function(_, newVal)
            Critmatic.db.profile.fontSettings.fontOutline = newVal
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
          order = 5,
          get = function()
            return Critmatic.db.profile.fontSettings.fontShadowSize[1]
          end,
          set = function(_, value)
            Critmatic.db.profile.fontSettings.fontShadowSize[1] = value
          end,
        },

        fontShadowSizeY = {
          type = 'range',
          name = 'Shadow Size Y',
          desc = 'Set the shadow size for the font in the vertical direction.',
          min = -10,
          max = 10,
          step = 1,
          order = 6,
          width = "3",
          get = function()
            return Critmatic.db.profile.fontSettings.fontShadowSize[2]
          end,
          set = function(_, value)
            Critmatic.db.profile.fontSettings.fontShadowSize[2] = value
          end,
        },
        fontShadowColor = {
          type = 'color',
          name = 'Shadow Color',
          desc = 'Set the shadow color for the font.',
          hasAlpha = false,
          order = 7,
          get = function()
            return unpack(Critmatic.db.profile.fontSettings.fontShadowColor)
          end,
          set = function(_, r, g, b)
            Critmatic.db.profile.fontSettings.fontShadowColor = { r, g, b }
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
          order = 8,
        },

      },

    },
    sounds = {
      name = "Sound Settings",
      type = "group",
      order = 3,
      args = {
        damageNormal = {
          name = "Normal Damage Sound",
          type = "select",
          dialogControl = "LSM30_Sound",
          values = LSM:HashTable("sound"),
          width = "full",
          order = 2,
          get = function()
            return Critmatic.db.profile.soundSettings.damageNormal
          end,
          set = function(_, newVal)
            Critmatic.db.profile.soundSettings.damageNormal = newVal
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
            return Critmatic.db.profile.soundSettings.damageCrit
          end,
          set = function(_, newVal)
            Critmatic.db.profile.soundSettings.damageCrit = newVal
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
            return Critmatic.db.profile.soundSettings.healNormal
          end,
          set = function(_, newVal)
            Critmatic.db.profile.soundSettings.healNormal = newVal
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
            return Critmatic.db.profile.soundSettings.healCrit
          end,
          set = function(_, newVal)
            Critmatic.db.profile.soundSettings.healCrit = newVal
          end,
        },
        muteAllSounds = {
          name = "Mute All Sounds",
          desc = "Do you want to mute all sounds regardless of settings?",
          type = "toggle",
          set = function(_, newVal)
            Critmatic.db.profile.soundSettings.muteAllSounds = newVal
          end,
          get = function()
            return Critmatic.db.profile.soundSettings.muteAllSounds
          end,
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
    social = {
      name = "Social Settings",
      type = "group",
      order = 4,
      args = {
        canSendCritsToParty = {
          name = "Send Crits to Party",
          desc = "Do you want to send party chat messages when you Crit? default: Checked ",
          type = "toggle",
          order = 1,
          set = function(_, newVal)
            Critmatic.db.profile.social.canSendCritsToParty = newVal
          end,
          get = function()
            return Critmatic.db.profile.social.canSendCritsToParty
          end,
        },
        canSendCritsToRaid = {
          name = " Send Crits to Raid",
          desc = "Do you want to send raid chat messages when you Crit? Default: Checked",
          type = "toggle",
          order = 2,
          set = function(_, newVal)
            Critmatic.db.profile.social.canSendCritsToRaid = newVal
          end,
          get = function()
            return Critmatic.db.profile.social.canSendCritsToRaid
          end,
        },
        canSendCritsToGuild = {
          name = "Send Crits to Guild",
          desc = "Do you want to send guild chat messages when you Crit? Default: Un-Checked",
          type = "toggle",
          order = 3,
          set = function(_, newVal)
            Critmatic.db.profile.social.canSendCritsToGuild = newVal
          end,
          get = function()
            return Critmatic.db.profile.social.canSendCritsToGuild
          end,
        },
        canSendCritsToBattleGrounds = {
          name = "Send Crits to Battlegrounds",
          desc = "Do you want to send Battleground chat messages when you Crit? Default: Checked",
          type = "toggle",
          order = 4,
          set = function(_, newVal)
            Critmatic.db.profile.social.canSendCritsToBattleGrounds = newVal
          end,
          get = function()
            return Critmatic.db.profile.social.canSendCritsToBattleGrounds
          end,
        },
      }
    },
    changeLogPopUp = {
      name = "Change Log Settings",
      type = "group",
      childGroups = "tab",
      order = 5,
      args = {
        fontTab = {
          name = "Font Settings",
          type = "group",
          order = 1,
          args = {
            font = {
              name = "Font",
              type = "select",
              desc = "You might have to select the font twice to see all the fonts.",
              dialogControl = "LSM30_Font",
              values = LSM:HashTable("font"),
              width = "full",
              order = 1,
              get = function()
                return Critmatic.db.profile.changeLogPopUp.fontSettings.font
              end,
              set = function(_, newVal)
                Critmatic.db.profile.changeLogPopUp.fontSettings.font = newVal
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
                return Critmatic.db.profile.changeLogPopUp.fontSettings.fontSize
              end,
              set = function(_, newVal)
                Critmatic.db.profile.changeLogPopUp.fontSettings.fontSize = newVal
              end,
            },
            fontColor = {
              type = "color",
              name = "Color",
              desc = "Choose a color for your Change Log font",
              order = 3,
              width = "200",
              hasAlpha = false,
              get = function(_)
                local r, g, b = unpack(Critmatic.db.profile.changeLogPopUp.fontSettings.fontColor)
                return r, g, b
              end,
              set = function(_, r, g, b)
                Critmatic.db.profile.changeLogPopUp.fontSettings.fontColor = { r, g, b }
              end,
            },
            fontOutline = {
              name = "Outline",
              type = "select",
              values = {
                [""] = "None",
                ["OUTLINE"] = "Outline",
                ["OUTLINEMONOCHROME"] = "Outline Monochrome",
                ["THICKOUTLINE"] = "Thick Outline",
                ["THICKOUTLINEMONOCHROME"] = "Thick Outline Monochrome",

              },
              width = "full",
              order = 4,
              get = function()
                return Critmatic.db.profile.changeLogPopUp.fontSettings.fontOutline
              end,
              set = function(_, newVal)
                Critmatic.db.profile.changeLogPopUp.fontSettings.fontOutline = newVal
              end,
            },

            resetFontSettings = {
              name = "Reset Change Log Font Settings",
              desc = "Reset all Change Log Font settings to their default values?",
              width = "full",
              type = "execute",
              func = ResetChangeLogFontSettingsToDefault,
              confirm = true,
              confirmText = "Are you sure you want to reset change log font settings to their default values?",
              order = 5,
            },

          },
        },
        borderAndBackgroundTab = {
          name = "Border and Background Options",
          type = "group",
          order = 2,
          args = {
            borderTexture = {
              type = 'select',
              width = 'full',
              dialogControl = 'LSM30_Border',
              name = "Border Texture",
              order = 1,
              desc = "Choose a border texture from the list. Requires Reload",
              values = allowedBorderTexturesForConfig,
              get = function(_)

                return Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderTexture
              end,
              set = function(_, values)

                Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderTexture = values

              end,
            },
            borderSize = {
              type = 'range',
              name = "Border Size",
              desc = "Set the border size for the border frame. Requires Reload",
              width = 'full',
              order = 2,
              min = 1,
              max = 35,
              step = 1,
              get = function(_)
                return Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderSize
              end,
              set = function(_, value)
                Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderSize = value

              end,
            },
            backgroundTexture = {
              type = 'select',
              dialogControl = 'LSM30_Background',
              name = "Background Texture",
              width = 'full',
              order = 3,
              desc = "Choose a background texture from the list. Requires Reload",
              values = filteredBackgrounds,
              get = function(_)
                return Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture
              end,
              set = function(_, values)
                Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture = values

              end,
            },
            resetBorderBackgroundSettings = {
              name = "Reset Change Log Font Settings",
              desc = "Reset all Change Log Border and Background settings to their default values?",
              width = "full",
              type = "execute",
              func = ResetChangeLogBorderAndBackgroundSettingsToDefault,
              confirm = true,
              confirmText = "Are you sure you want to reset change log border and background settings to their default values?",
              order = 4,
            },

          }, },
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


