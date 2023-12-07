local LSM = LibStub("LibSharedMedia-3.0")
Critmatic = Critmatic or {}
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")

LSM = LibStub("LibSharedMedia-3.0")
local soundCrit, soundHit, soundCritHeal, soundHeal

-- Coroutine to fetch sound settings
local co = coroutine.create(function()
    while true do
        if Critmatic and Critmatic.db then
            soundCrit = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.damageCrit)
            soundHit = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.damageNormal)
            soundCritHeal = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.healCrit)
            soundHeal = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.healNormal)
            break
        else
            coroutine.yield()
        end
    end
end)

-- Function to resume the coroutine
local function fetchSoundSettings()
    if coroutine.status(co) ~= 'dead' then
        coroutine.resume(co)
        -- If Critmatic or Critmatic.db is not ready, delay the execution
        C_Timer.After(1, fetchSoundSettings)
    end
end

-- Call the function to start fetching sound settings
fetchSoundSettings()
function ResetAlertSettingsToDefault()
    Critmatic.db.profile.alertNotificationFormat = defaults.profile.alertNotificationFormat
end
function ResetFontSettingsToDefault()
    Critmatic.db.profile.fontSettings = defaults.profile.fontSettings
end
local function alertNotificationConstructor(message, isDamage, isCrit, sound)
    -- Define a local table with 15 different spell names
    local spellNames = {}
    local r, g, b
    if isDamage then
        spellNames = {
            "Fireball",
            "Shadow Bolt",
            "Chain Lightning",
            "Death Coil",
            "Starfire",
            "Eviscerate",
            "Mind Blast",
            "Heroic Strike",
            "Arcane Shot",
            "Blade Flurry",
            "Judgment",
            "Shadowflame",
            "Stormstrike",
            "Mutilate",
            "Hammer of Wrath"
        }
    else
        spellNames = {
            "Circle of Healing",
            "Rejuvenation",
            "Lay on Hands",
            "Renew",
            "Riptide",
            "Holy Light",
            "Lifebloom",
            "Healing Rain",
            "Soothing Mist",
            "Penance",
            "Wild Growth",
            "Prayer of Healing"
        }
    end


    -- Select a random spell name
    local spellName = spellNames[math.random(#spellNames)]
    local string = ""
    -- Generate a random number between 3000 and 8000 for amount
    local amount = math.random(500, 8000)
    if Critmatic.db.profile.alertNotificationFormat.isUpper then
        -- If spellName does not end with 'Heal', use the format string as is
        string = string.upper(string.format(message, spellName, amount))
    else
        string = string.format(message, spellName,
                amount)

    end

    if isCrit then
        r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
    else
        r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
    end
    Critmatic.MessageFrame:CreateMessage(string, r, g, b)
    if not Critmatic.db.profile.soundSettings.muteAllSounds then
        PlaySoundFile(sound)
    end
end
function Critmatic:AlertFontSettings_Initialize()

    local alertFontSettings = {
        name = L["options_alert_font_settings"],
        type = "group",
        order = 2,
        childGroups = "tab",
        args = {
            messageTab = {
                name = L["options_alert_notification_format"],
                type = "group",
                order = 1,
                desc = L["options_alert_notification_format_desc"],
                args = {
                    isUpper = {
                        name = L["options_alert_notification_format_upper"],
                        desc = L["options_alert_notification_format_upper_desc"],
                        type = "toggle",
                        order = 1,
                        set = function(_, newVal)
                            Critmatic.db.profile.alertNotificationFormat.isUpper = newVal
                        end,
                        get = function()
                            return Critmatic.db.profile.alertNotificationFormat.isUpper
                        end,
                    },
                    critAlertNotificationFormat = {
                        type = "input",
                        name = L["options_alert_notification_format_crit"],
                        desc = L["options_alert_notification_format_crit_desc"],
                        multiline = false, -- Set to true to increase the height of the input box
                        width = "full",
                        get = function()
                            return Critmatic.db.profile.alertNotificationFormat.critAlertNotificationFormat
                        end,
                        set = function(_, val)
                            Critmatic.db.profile.alertNotificationFormat.critAlertNotificationFormat = val
                        end,
                        order = 2 -- Adjust the order as needed
                    },
                    runCritButton = {
                        name = "Preview Crit",
                        desc = " Preview Crit Alert Notification",
                        type = "execute",
                        func = function()
                            alertNotificationConstructor(Critmatic.db.profile.alertNotificationFormat
                                                                  .critAlertNotificationFormat, true, true, soundCrit)
                        end,
                        order = 3, -- Adjust the order as needed
                    },
                    hitAlertNotificationFormat = {
                        type = "input",
                        name = L["options_alert_notification_format_hit"],
                        desc = L["options_alert_notification_format_hit_desc"],
                        multiline = false, -- Set to true to increase the height of the input box
                        width = "full",
                        get = function()
                            return Critmatic.db.profile.alertNotificationFormat.hitAlertNotificationFormat
                        end,
                        set = function(_, val)
                            Critmatic.db.profile.alertNotificationFormat.hitAlertNotificationFormat = val
                        end,
                        order = 4 -- Adjust the order as needed
                    },
                    runHitButton = {
                        name = "Preview Hit",
                        desc = " Preview Hit Alert Notification",
                        type = "execute",
                        func = function()
                            alertNotificationConstructor(Critmatic.db.profile.alertNotificationFormat
                                                                  .hitAlertNotificationFormat, true, false, soundHit)
                        end,
                        order = 5, -- Adjust the order as needed
                    },
                    critHealAlertNotificationFormat = {
                        type = "input",
                        name = L["options_alert_notification_format_crit_heal"],
                        desc = L["options_alert_notification_format_crit_heal_desc"],
                        multiline = false, -- Set to true to increase the height of the input box
                        width = "full",
                        get = function()
                            return Critmatic.db.profile.alertNotificationFormat.critHealAlertNotificationFormat
                        end,
                        set = function(_, val)
                            Critmatic.db.profile.alertNotificationFormat.critHealAlertNotificationFormat = val
                        end,
                        order = 6 -- Adjust the order as needed
                    },
                    runCritHealButton = {
                        name = "Preview Crit Heal",
                        desc = " Preview Crit Heal Alert Notification",
                        type = "execute",
                        func = function()
                            alertNotificationConstructor(Critmatic.db.profile.alertNotificationFormat
                                                                  .critHealAlertNotificationFormat, false, true,
                                    soundCritHeal)
                        end,
                        order = 7, -- Adjust the order as needed
                    },
                    healAlertNotificationFormat = {
                        type = "input",
                        name = L["options_alert_notification_format_heal"],
                        desc = L["options_alert_notification_format_heal_desc"],
                        multiline = false, -- Set to true to increase the height of the input box
                        width = "full",
                        get = function()
                            return Critmatic.db.profile.alertNotificationFormat.healAlertNotificationFormat
                        end,
                        set = function(_, val)
                            Critmatic.db.profile.alertNotificationFormat.healAlertNotificationFormat = val
                        end,
                        order = 8
                    },
                    runHealButton = {
                        name = "Preview Heal",
                        desc = " Preview Heal Alert Notification",
                        type = "execute",
                        func = function()
                            alertNotificationConstructor(Critmatic.db.profile.alertNotificationFormat
                                                                  .healAlertNotificationFormat, false, false,
                                    soundHeal)
                        end,
                        order = 9, -- Adjust the order as needed
                    },
                    resetAlertSettings = {
                        name = L["options_alert_notification_format_reset"],
                        desc = L["options_alert_notification_format_reset_desc"],
                        width = "full",
                        type = "execute",
                        func = ResetAlertSettingsToDefault,
                        confirm = true,
                        confirmText = L["options_alert_notification_format_reset_confirm"],
                        order = 10,
                    },
                },
            },
            fontTab = {
                name = "Font Settings",
                type = "group",
                order = 2,
                args = {
                    font = {
                        name = L["options_alert_font"],
                        type = "select",
                        desc = L["options_alert_font_desc"],
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
                        name = L["options_alert_font_size"],
                        type = "range",
                        min = 8,
                        max = 32,
                        step = 1,
                        order = 2,
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
                        name = L["options_alert_font_color_crit"],
                        desc = L["options_alert_font_color_crit_desc"],
                        order = 3,
                        hasAlpha = false,
                        width = "normal",
                        get = function()
                            local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
                            return r, g, b
                        end,
                        set = function(_, r, g, b)
                            Critmatic.db.profile.fontSettings.fontColorCrit = { r, g, b }
                        end,
                    },
                    fontColor = {
                        type = "color",
                        name = L["options_alert_font_c_non_crit"],
                        desc = L["options_alert_font_c_non_crit_desc"],
                        order = 4,
                        width = "normal",
                        hasAlpha = false,
                        get = function()
                            local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
                            return r, g, b
                        end,
                        set = function(_, r, g, b)
                            Critmatic.db.profile.fontSettings.fontColor = { r, g, b }
                        end,
                    },
                    fontOutline = {
                        name = L["options_alert_font_outline"],
                        type = "select",
                        values = {
                            ["NONE"] = L["options_alert_font_none"],
                            ["OUTLINE"] = L["options_alert_font_outline"],
                            ["OUTLINEMONOCHROME"] = L["options_alert_font_outline_mono"],
                            ["THICKOUTLINE"] = L["options_alert_font_outline_thick"],
                            ["THICKOUTLINEMONOCHROME"] = L["options_alert_font_outline_thick_mono"],
                        },
                        width = "full",
                        order = 5,
                        get = function()
                            return Critmatic.db.profile.fontSettings.fontOutline
                        end,
                        set = function(_, newVal)
                            Critmatic.db.profile.fontSettings.fontOutline = newVal
                        end,
                    },
                    fontShadowSizeX = {
                        type = 'range',
                        name = L["options_alert_font_shadow_x"],
                        desc = L["options_alert_font_shadow_x_desc"],
                        min = -10,
                        max = 10,
                        step = 1,
                        order = 6,
                        width = "normal",
                        get = function()
                            return Critmatic.db.profile.fontSettings.fontShadowSize[1]
                        end,
                        set = function(_, value)
                            Critmatic.db.profile.fontSettings.fontShadowSize[1] = value
                        end,
                    },
                    fontShadowSizeY = {
                        type = 'range',
                        name = L["options_alert_font_shadow_y"],
                        desc = L["options_alert_font_shadow_y_desc"],
                        min = -10,
                        max = 10,
                        step = 1,
                        order = 7,
                        width = "normal",
                        get = function()
                            return Critmatic.db.profile.fontSettings.fontShadowSize[2]
                        end,
                        set = function(_, value)
                            Critmatic.db.profile.fontSettings.fontShadowSize[2] = value
                        end,
                    },
                    fontShadowColor = {
                        type = 'color',
                        name = L["options_alert_font_shadow_color"],
                        desc = L["options_alert_font_shadow_color_desc"],
                        hasAlpha = false,
                        order = 8,
                        get = function()
                            return unpack(Critmatic.db.profile.fontSettings.fontShadowColor)
                        end,
                        set = function(_, r, g, b)
                            Critmatic.db.profile.fontSettings.fontShadowColor = { r, g, b }
                        end,
                    },
                    resetFontSettings = {
                        name = L["options_alert_font_reset"],
                        desc = L["options_alert_font_reset_desc"],
                        width = "full",
                        type = "execute",
                        func = ResetFontSettingsToDefault,
                        confirm = true,
                        confirmText = L["options_alert_font_reset_confirm"],
                        order = 9,
                    },
                },
            },
        },
    }

    return alertFontSettings
end
