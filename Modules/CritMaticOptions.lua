local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
Critmatic = Critmatic or {}

function Critmatic:CreateOptionsTable()
    local general_tab = Critmatic:GeneralTab_Initialize()
    local alertFont_Tab = Critmatic:AlertFontSettings_Initialize()
    local sound_tab = Critmatic:SoundSettings_Initialize()
    local social_tab = Critmatic:SocialSettings_Initialize()
    local changeLog_tab = Critmatic:ChangeLogSettings_Initialize()

    return {
        name = "CritMatic Options",
        type = "group",

        args = {

            general_tab = general_tab,
            alertFont_Tab = alertFont_Tab,
            sound_tab = sound_tab,
            social_tab = social_tab,
            changeLog_tab = changeLog_tab

        },
    }

end
-- Register the options table
AceConfig:RegisterOptionsTable("CritMaticOptions", Critmatic:CreateOptionsTable())

-- Add to Blizzard's Interface Options
local blizzPanel = AceConfigDialog:AddToBlizOptions("CritMaticOptions", "CritMatic")

-- Hook into the Blizzard options panel.
hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)
    if frame == blizzPanel then
        --
    end
end)


