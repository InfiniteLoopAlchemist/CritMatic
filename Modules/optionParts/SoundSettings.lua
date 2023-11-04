local LSM = LibStub("LibSharedMedia-3.0")
Critmatic = Critmatic or {}
function ResetSoundsToDefault()
    Critmatic.db.profile.soundSettings = defaults.profile.soundSettings
end

function Critmatic:SoundSettings_Initialize()
    local soundSettings = {
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
                desc = "Reset all sounds to their default configuration",
                width = "full",
                type = "execute",
                func = ResetSoundsToDefault,
                confirm = true,
                confirmText = "Are you sure you want to reset sound settings to their default values?",
                order = 6,
            },
        },
    }

    return soundSettings
end
