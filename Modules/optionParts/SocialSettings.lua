Critmatic = Critmatic or {}
function Critmatic:SocialSettings_Initialize()
    local socialSettings = {
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
                name = "Send Crits to Raid",
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
        },
    }

    return socialSettings
end
