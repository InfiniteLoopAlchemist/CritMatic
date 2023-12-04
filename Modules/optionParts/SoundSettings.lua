local LSM = LibStub("LibSharedMedia-3.0")
Critmatic = Critmatic or {}
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
function ResetSoundsToDefault()
    Critmatic.db.profile.soundSettings = defaults.profile.soundSettings
end

function Critmatic:SoundSettings_Initialize()
    local soundSettings = {
        name = L["options_sound_settings"],
        type = "group",
        order = 3,
        args = {
            damageCrit = {
                name = L["options_sound_crit"],
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
            damageNormal = {
                name = L["options_sound_hit"],
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
            healCrit = {
                name = L["options_sound_crit_heal"],
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
            healNormal = {
                name = L["options_sound_heal"],
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

            muteAllSounds = {
                name = L["options_sound_mute_all"],
                desc = L["options_sound_mute_all_desc"],
                type = "toggle",
                set = function(_, newVal)
                    Critmatic.db.profile.soundSettings.muteAllSounds = newVal
                end,
                get = function()
                    return Critmatic.db.profile.soundSettings.muteAllSounds
                end,
            },
            resetSounds = {
                name = L["options_sound_reset"],
                desc = L["options_sound_reset_desc"],
                width = "full",
                type = "execute",
                func = ResetSoundsToDefault,
                confirm = true,
                confirmText = L["options_sound_reset_confirm"],
                order = 6,
            },
        },
    }

    return soundSettings
end
