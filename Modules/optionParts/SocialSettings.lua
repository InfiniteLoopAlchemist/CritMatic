Critmatic = Critmatic or {}
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
function Critmatic:SocialSettings_Initialize()
    local socialSettings = {
        name = L["options_social"],
        type = "group",
        order = 4,
        args = {
            canSendCritsToParty = {
                name = L["options_social_send_crits_toParty"],
                desc = L["options_social_send_crits_toParty_desc"],
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
                name = L["options_social_send_crits_toRaid"],
                desc = L["options_social_send_crits_toRaid_desc"],
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
                name = L["options_social_send_crits_toGuild"],
                desc = L["options_social_send_crits_toGuild_desc"],
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
                name = L["options_social_send_crits_toBattleGrounds"],
                desc = L["options_social_send_crits_toBattleGrounds_desc"],
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
