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

[v0.3.2-release] - 10/26/2023

 Updated:

 Refined various functional and UI elements.

 Added:

 Introduced generalized configuration options.



[v0.3.1-release] - 10/26/2023

 Fixed:

 Purged residual debug messages inadvertently left in production build.

 Updated:

 Optimized Party Notifications to exclusively display Critical Hits and Heals, omitting standard events.

 Added:

 Included toggle for silencing party notifications.



[v0.3.0-release] - 10/25/2023

 Added:

 New Slash Commands to open the options menu /cm and /critmatic
 You can Change the Crit and Normal hit / heal sounds.



[v0.2.9.1-release] - 10/22/2023

 Updated:

 Hotfix deployed for urgent issues.

 Added:

 Configurable options for disabling chat and alert notifications introduced.



[v0.2.8-release] - 10/21/2023

 Added:

 Optionality added for tracking autoattacks.



[v0.2.5.7-release] - 9/27/2023

 Updated:

 General improvements and bug fixes.



[v0.2.5.6-release] - 9/27/2023

 Updated:

 Minor revisions and optimizations.



[v0.2.5.5-release] - 9/26/2023

 Fixed:

 Rectified various issues and bugs.



[v0.2.3-release] - 9/19/2023

 Fixed:

 Resolved issue with settings not persisting across sessions.

 Updated:

 Adjusted default font size to 22 and introduced a 0.45s delay for notification messages.



[v0.2.2-release] - 9/17/2023

 Updated:

 Modified default font size to 24 and added a 0.25s delay to notification messages.



[v0.2.1.5-release] - 9/12/2023

 Fixed:

 Addressed multiple bugs and issues.



[v0.2.1-release] - 9/10/2023

 Added:

 Incorporated settings for font customization.



[v0.2.0-release] - 9/05/2023

 Added:

 Slash Commands `/cm` and `/critmatic` introduced for options menu.
 Sound settings for Crit and Normal hits/heals are now customizable.



[v0.1.6.5-release] - 9/01/2023

 Updated:

 Enhanced notification animations.



[v0.1.6-release] - 8/29/2023

 Fixed:

 Addressed a bug causing the first notification for Crit/Normal/Heal events to not display upon game start.



[v0.1.5.6-release] - 8/28/2023

 Added:

 Introduced a distinct sound effect for Normal Heals.



[v0.1.5.5-release] - 8/27/2023

 Fixed:

 Resolved a bug causing the absence of sound for normal hit/heals.

 Added:

 Extended support for Classic Era / Hardcore.
 Updated Notification Animation.



[v0.1.4-alpha] - 8/23/2023

 Added:

 New Crit animations introduced.
 Tooltip information for CritMatic added to the spellbook.



[v0.1.3-alpha] - 8/20/2023

 Fixed:

 Addressed an issue causing premature disappearance of hit messages.



[v0.1.2-alpha] - 8/18/2023

 Added:

 Implemented a cap for extremely highvalue crits, heals, and hits.
 Added a validation check to prevent tracking of nonspellbook spells.
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

