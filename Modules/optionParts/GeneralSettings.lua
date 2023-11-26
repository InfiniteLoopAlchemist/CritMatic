Critmatic = Critmatic or {}
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
function Critmatic:GeneralTab_Initialize()
    -- Define your general tab options here
    return {
        name = L["options_general"],
        type = "group",
        order = 1,
        args = {
            autoAttacksEnabled = {
                name = L["options_auto_attacks"],
                desc = L["options_auto_attacks_desc"],
                type = "toggle",
                order = 1,
                set = function(_, newVal)
                    Critmatic.db.profile.generalSettings.autoAttacksEnabled = newVal
                end,
                get = function()
                    return Critmatic.db.profile.generalSettings.autoAttacksEnabled
                end,
            },

            alertNotificationsEnabled = {
                name = L["options_show_alert_notifications"],
                desc = L["options_show_alert_notifications_desc"],
                type = "toggle",
                order = 2,
                set = function(_, newVal)
                    Critmatic.db.profile.generalSettings.alertNotificationsEnabled = newVal
                end,
                get = function()
                    return Critmatic.db.profile.generalSettings.alertNotificationsEnabled
                end,
            },
            chatNotificationsEnabled = {
                name = L["options_show_chat_notifications"],
                desc = L["options_show_chat_notifications_desc"],
                type = "toggle",
                order = 3,
                set = function(_, newVal)
                    Critmatic.db.profile.generalSettings.chatNotificationsEnabled = newVal
                end,
                get = function()
                    return Critmatic.db.profile.generalSettings.chatNotificationsEnabled
                end,
            },
            isChangeLogAutoPopUpEnabled = {
                name = L["options_show_change_log"],
                desc = L["options_show_change_log_desc"],
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
                name = L["options_discord_link"],
                desc = L["options_discord_link_desc"],
                type = "input",
                order = 5,
                width = 'full',
                get = function()
                    return "https://discord.gg/34JJyrnGGC" -- Replace with your actual Discord link
                end,
                set = function(_, _)
                    -- Do nothing when the user tries to modify it
                end,
            },
        }
    }
end
