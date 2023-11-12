-- Default values for the database
defaults = {
  profile = {
    generalSettings = {
      alertNotificationsEnabled = true,
      autoAttacksEnabled = true,
      chatNotificationsEnabled = true,
      isChangeLogAutoPopUpEnabled = true

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
critLogWidgetPos = {
  pos_x = 470,
  pos_y = -100,
  size_x = 255,
  size_y = 125,
  lock = false
},
    oldVersion = "0.0.0"
  },

}



