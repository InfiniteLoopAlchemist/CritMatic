local LSM = LibStub("LibSharedMedia-3.0")
Critmatic = Critmatic or {}
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

function Critmatic:ChangeLogSettings_Initialize()
    local changeLogPopUp = {
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
                        order = 2,
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
                        width = "full",
                        hasAlpha = false,
                        get = function()
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
                        get = function()
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
                        get = function()
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
                        get = function()
                            return Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture

                        end,
                        set = function(_, values)
                            Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture = values
                        end,
                    },
                    resetBorderBackgroundSettings = {
                        name = "Reset Change Log Border and Background Settings",
                        desc = "Reset all Change Log Border and Background settings to their default values?",
                        width = "full",
                        type = "execute",
                        func = ResetChangeLogBorderAndBackgroundSettingsToDefault,
                        confirm = true,
                        confirmText = "Are you sure you want to reset change log border and background settings to their default values?",
                        order = 4,
                    },
                },
            },
        },
    }
    return changeLogPopUp
end
