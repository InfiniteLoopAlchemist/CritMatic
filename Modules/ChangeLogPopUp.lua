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

[v0.3.5.9.6-release] - 11/4/2023

 Updated:

 We've overhauled the internal code structure for the Options Tables to pave the way for an exciting new feature dubbed "CritLog." Picture a widget similar to the Deathlog addon, which you can toggle on or off. The CritLog will track and display your critical strikes, regular hits, critical heals, and standard heals. Accessing this feature will be a breeze with the new slash command `/cmlog`. Stay tuned as we begin the development phase!

 We've updated the font color for the "CritMatic Loaded" notification for better visibility and style.






[v0.3.5.9-release] - 11/3/2023

 Fixed:

 The change log should now reflect new changes correctly.
 Various other fixes




[v0.3.5.8-release] - 11/3/2023

 Fixed:

 Resolved an issue where critical hit notifications were failing to dispatch in battleground instances.

 Added:

  Added a toggle to disable broadcasting critical hit alerts in battlegrounds.




[v0.3.5.7-release] - 11/2/2023

 Fixed:

 Resolved an edgecase condition where CritMatic erroneously reported 'not in a party or raid' within battlegrounds and arenas. 

 Added:

  An automated changelog popup to brief you on the latest patches. Run /cmlog anytime.




[v0.3.5.3-release] - 10/29/2023

 Fixed:
 Various Fixes.



[v0.3.5.1-release] - 10/29/2023

 Fixed:

 Removed extraneous debug log invocations.



[v0.3.5-release] - 10/28/2023

 Added:

 Extended compatibility to include WoW Retail through API adjustments.



[v0.3.4.1-release] - 10/28/2023

 Added:

 Implemented options for broadcasting critical events to Raid and Guild channels.



[v0.3.3-release] - 10/28/2023

 Added:

 Introduced versionchecking mechanism to notify users of outdated CritMatic versions.



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

