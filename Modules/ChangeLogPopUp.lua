local AceGUI = LibStub("AceGUI-3.0")

-- Ensure SharedMedia is loaded
local LSM = LibStub("LibSharedMedia-3.0")

-- Function to show the change log
Critmatic.showChangeLog = function()
    -- Create a container frame
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("CritMatic - Change Log")
    frame:SetStatusText("Need Help? Copy the Discord Link in General Options. ")
    frame:SetLayout("Fill")
    frame:SetWidth(600)
    frame:SetHeight(500)

    local backgroundTexture = LSM:Fetch("background", Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture)
    frame.frame:SetBackdrop({
        bgFile = backgroundTexture,
        edgeFile = LSM:Fetch("border", Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderTexture),
        edgeSize = Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderSize,
    })

    -- Create a scroll container
    local scrollContainer = AceGUI:Create("SimpleGroup")
    scrollContainer:SetFullWidth(true)
    scrollContainer:SetFullHeight(true)
    scrollContainer:SetLayout("Fill")
    frame:AddChild(scrollContainer)

    -- Create a ScrollFrame
    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("List")
    scrollContainer:AddChild(scroll)

    -- Add the change log text
    local changelog = [[

[v0.3.8.5-release] - 11/27/2023

 Added:

 CritMatic was translated to traditional Chinese using Google Translate. So if it made a mistake, let me know on discord. I only speak English. Sorry for any connivence.





[v0.3.8.4-release] - 11/27/2023

 Added:

 CritMatic was translated to traditional Chinese using Google Translate. So if it made a mistake, let me know on discord. I only speak English. Sorry for any connivence.




]]

    local r, g, b = unpack(Critmatic.db.profile.changeLogPopUp.fontSettings.fontColor)
    -- Fetch the custom font from SharedMedia
    local customFont = LSM:Fetch("font", Critmatic.db.profile.changeLogPopUp.fontSettings.font)
    local logLabel = AceGUI:Create("Label")
    logLabel:SetText(changelog)
    logLabel:SetFullWidth(true)

    logLabel:SetFont(customFont, Critmatic.db.profile.changeLogPopUp.fontSettings.fontSize, Critmatic.db.profile.changeLogPopUp.fontSettings.fontOutline)
    logLabel:SetColor(r, g, b)

    scroll:AddChild(logLabel)

end

