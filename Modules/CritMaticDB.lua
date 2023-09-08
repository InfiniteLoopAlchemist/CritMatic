local AceDB = LibStub("AceDB-3.0")

-- Default values for the database
defaults = {
  profile = {
    soundSettings = {
      damageNormal = "CritMatic: Heroism Cast",
      damageCrit = "CritMatic: Level Up",
      healNormal = "CritMatic: Heaven",
      healCrit = "CritMatic: Level Up"
    },
    fontSettings = {
      font = "CritMatic: Hideout 8-Bit-AA",
      fontOutline = "THICKOUTLINE",
      fontSize = 20,
      fontColorCrit = { 1, 0.84, 0 }, -- Gold color
      fontColor = { 0.9, 0.9, 0.9 }, -- White color
      fontShadowSize = { 3, -3 },
      fontShadowColor = { 0.1, 0.1, 0.1 } -- Almost pure black

    },
    dbResetDone = false, -- Set to false to show the popup.

  }
}

-- Initialize the AceDB database
CritMaticDB = AceDB:New("CritMaticDB", defaults)
