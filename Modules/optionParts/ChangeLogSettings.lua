local LSM = LibStub("LibSharedMedia-3.0")
Critmatic = Critmatic or {}
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
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
        name = L["options_change_log"],
        type = "group",
        childGroups = "tab",
        order = 5,
        args = {
            fontTab = {
                name = L["options_change_log_font"],
                type = "group",
                order = 1,
                args = {
                    font = {
                        name = L["options_change_log_font"],
                        type = "select",
                        desc = L["options_change_log_font_desc"],
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
                        name = L["options_change_log_font_size"],
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
                        name = L["options_change_log_font_color"],
                        desc = L["options_change_log_font_color_desc"],
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
                        name = L["options_change_log_font_outline"],
                        type = "select",
                        values = {
                            [""] = L["options_change_log_font_none"],
                            ["OUTLINE"] = L["options_change_log_font_outline"],
                            ["OUTLINEMONOCHROME"] = L["options_change_log_font_outline_mono"],
                            ["THICKOUTLINE"] = L["options_change_log_font_outline_thick"],
                            ["THICKOUTLINEMONOCHROME"] = L["options_change_log_font_outline_thick_mono"],
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
                        name = L["options_change_log_reset"],
                        desc = L["options_change_log_reset_desc"],
                        width = "full",
                        type = "execute",
                        func = ResetChangeLogFontSettingsToDefault,
                        confirm = true,
                        confirmText = L["options_change_log_reset_confirm"],
                        order = 5,
                    },
                },
            },
            borderAndBackgroundTab = {
                name = L["options_change_log_border_and_background"],
                type = "group",
                order = 2,
                args = {
                    borderTexture = {
                        type = 'select',
                        width = 'full',
                        dialogControl = 'LSM30_Border',
                        name = L["options_change_log_border_and_background_border"],
                        order = 1,
                        desc = L["options_change_log_border_and_background_border_desc"],
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
                        name = L["options_change_log_border_and_background_border_size"],
                        desc = L["options_change_log_border_and_background_border_size_desc"],
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
                        name = L["options_change_log_border_and_background_texture"],
                        width = 'full',
                        order = 3,
                        desc = L["options_change_log_border_and_background_texture_desc"],
                        values = filteredBackgrounds,
                        get = function()
                            return Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture

                        end,
                        set = function(_, values)
                            Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture = values
                        end,
                    },
                    resetBorderBackgroundSettings = {
                        name = L["options_change_log_border_and_background_reset"],
                        desc = L["options_change_log_border_and_background_reset_desc"],
                        width = "full",
                        type = "execute",
                        func = ResetChangeLogBorderAndBackgroundSettingsToDefault,
                        confirm = true,
                        confirmText = L["options_change_log_border_and_background_reset_confirm"],
                        order = 4,
                    },
                },
            },
        },
    }
    return changeLogPopUp
end
