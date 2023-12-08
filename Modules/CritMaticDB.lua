-- Default values for the database
defaults = {
    profile = {
        generalSettings = {
            alertNotificationsEnabled = true,
            chatNotificationsEnabled = true,
            isChangeLogAutoPopUpEnabled = true

        },
        alertNotificationFormat = {
            global = {
                isUpper = true,
                maxMessages = 4,
                startDelay = 7.5,
                fadeTime = 0.5,
            },
            strings = {
                critAlertNotificationFormat = "New %s Crit: %d!",
                hitAlertNotificationFormat = "New %s Hit: %d!",
                critHealAlertNotificationFormat = "New %s Crit Heal: %d!",
                healAlertNotificationFormat = "New %s Heal: %d!",
            }

        },
        fontSettings = {
            font = "Anton",
            fontOutline = "OUTLINEMONOCHROME",
            fontSize = 22,
            fontColorCrit = { 1, 0.84, 0 }, -- Gold color
            fontColor = { 0.9, 0.9, 0.9 }, -- Almost pure White
            fontShadowSize = { 3, -3 },
            fontShadowColor = { 0.1, 0.1, 0.1 } -- Almost pure black
        },
        soundSettings = {
            damageNormal = "Heroism Cast",
            damageCrit = "Level Up",
            healNormal = "Heaven",
            healCrit = "Level Up",
            muteAllSounds = false
        },
        social = {
            canSendCritsToParty = true,
            canSendCritsToGuild = false,
            canSendCritsToRaid = true,
            canSendCritsToBattleGrounds = true
        },
        changeLogPopUp = {
            borderAndBackgroundSettings = {
                backgroundTexture = "Blizzard Parchment 2",
                borderTexture = "Blizzard Achievement Wood",
                borderSize = 15,
            },
            fontSettings = {
                font = "MoK",
                fontColor = { 0.2, 0.2, 0.2 },
                fontOutline = "OUTLINEMONOCHROME",
                fontSize = 15,
            }
        },
        isCritLogFrameShown = true,
        critLogWidgetPos = {
            anchor = "RIGHT",
            anchor2 = "RIGHT",
            pos_x = -90.8942287109375,
            pos_y = -114.91058349609,
            size_x = 255,
            size_y = 125,
            lock = false
        },
        oldVersion = "0.0.0",
        dataCleared = false,
    },

}



