Critmatic = Critmatic or {}
function Critmatic:GeneralTab_Initialize()
    -- Define your general tab options here
    return {
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
                name = "Show Change Log",
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
                    return "https://discord.gg/34JJyrnGGC" -- Replace with your actual Discord link
                end,
                set = function(_, _)
                    -- Do nothing when the user tries to modify it
                end,
            },
        }
    }
end
