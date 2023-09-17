local AceDB = LibStub("AceDB-3.0")

-- Default values for the database
defaults = {
  profile = {
    soundSettings = {
      damageNormal = "Heroism Cast",
      damageCrit = "Level Up",
      healNormal = "Heaven",
      healCrit = "Level Up"
    },
    fontSettings = {
      font = "Hideout 8-Bit-AA",
      fontOutline = "THICKOUTLINE",
      fontSize = 24,
      fontColorCrit = { 1, 0.84, 0 }, -- Gold color
      fontColor = { 0.9, 0.9, 0.9 }, -- Almost pure White
      fontShadowSize = { 3, -3 },
      fontShadowColor = { 0.1, 0.1, 0.1 } -- Almost pure black

    },

  }
}

-- Initialize the AceDB database
CritMaticDB2 = AceDB:New("CritMaticDB2", defaults)
