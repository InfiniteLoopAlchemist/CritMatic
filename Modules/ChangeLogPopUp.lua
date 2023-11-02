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

 Various changes.

 Added:

 General options.




[v0.3.1-release] - 10/26/2023

 Fixed:

 After Working on the addon all day I left some debug messages.

 Updated:

 Party Notifications updated: Now only displays Critical Hits and Critical Heals. Removed notifications for Normal Hits and Heals.

 Added:

 Option to shut up CritMatic party notifications




[v0.3.0-release] - 10/25/2023




[v0.2.9.1-release] - 10/22/2023

 Updated:

 Quick hot fix

 Changed the color of the crit heal and normal crits chat notifications to gold.

 Added:

 Options to turn off chat and alert notifications.




[v0.2.8-release] - 10/21/2023

 Added:

 Option to track auto attacks or not.  




[v0.2.5.7-release] - 9/27/2023

 Updated:

 Various Fixes. 




[v0.2.5.6-release] - 9/27/2023

 Updated:

 Various Changes.  




[v0.2.5.5-release] - 9/26/2023

 Fixed:

 Various Fixes. 




[v0.2.3-release] - 9/19/2023

 Fixed

 Fixed the problem for setting not saving on exit or reload.

 Updated

 Changed the default font size to 22
 Delayed the notification message by 0.45



[v0.2.2-release] - 9/17/2023

 Updated

 Changed the default font size to 24
 Delayed the notification message, by adding 0.25 seconds to it. So you have more time to notice the animation.



[v0.2.1.5-release] - 9/12/2023

 Fixed

 Fixed Various Bugs.



[v0.2.1-release] - 9/10/2023

 Added

 Added Font Settings

 More options coming soon



[v0.2.0-release] - 9/05/2023

 Added

 New Slash Commands to open the options menu /cm and /critmatic
 You can Change the Crit and Normal hit / heal sounds.
  More options coming soon



[v0.1.6.5-release] - 9/01/2023

 Updated

 Updated the notification animation.



[v0.1.6-release] - 8/29/2023

 Fixed

 Fixed a bug that would not display the first Crit/Normal/Heal notification when just starting the game.



[v0.1.5.6-release] - 8/28/2023

 Added

 Added A new Heal Sound SFX for Normal Heals.



[v0.1.5.5-release] - 8/27/2023

 Fixed A bug where there was no sound for normal hit/heals

 Added

 Added Support for Classic Era / Hardcore.
 Updated Notification Animation.



[v0.1.4-alpha] - 8/23/2023

 Added

 Added new Crit animation for crits.
 Added CritMatic tooltip information to the spellbook.



[v0.1.3-alpha] - 8/20/2023

 Fixed

 A bug where hit messages disappearing too fast.



[v0.1.2-alpha] - 8/18/2023

 Added

 Added a max for crits,heals and normal hits so on some bosses you don't get a 1 million crits.
 Added a check to prevent CritMatic from attempting to track spells that are not in your spellbook.

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

