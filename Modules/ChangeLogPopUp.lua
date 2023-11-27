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

[v0.3.8.4-release] - 11/27/2023

 Added:

 CritMatic was translated to traditional Chinese using Google Translate. So if it made a mistake, let me know on discord. I only speak English. Sorry for any connivence.





[v0.3.8.3-release] - 11/26/2023

 Fixed:

 A bug where spells not in the spellbook caused an error for the action bar tooltip.





[v0.3.8.2-release] - 11/25/2023

 Fixed:

 Good news! We've fixed a bug that affected how the crit log displayed information for spells that can both heal and damage. Previously, if a spell had both of these capabilities, the crit log wasn't displaying correctly.

 This issue did not affect spells that were exclusively for healing or damage. With this latest update, you can expect accurate and consistent display for all spells, regardless of whether they heal, damage, or do both.

 Thank you for your continued support and feedback, which helps us improve CritMatic. Enjoy your enhanced gaming experience!





[v0.3.8-release] - 11/24/2023

 Updated:

 Changed the spell data handling from using spell names to spell IDs. This update enhances localization support, allowing CritMatic to be more compatible with different language settings and paving the way for future international releases.

 Due to this change, existing spell data in CritMatic had to be cleared. We apologize for any inconvenience this may cause and appreciate your understanding.





[v0.3.7.1-release] - 11/20/2023

 Updated:

 Crit Log now sorts by latest Crits/Hits/Crit Heals/Heals.





[v0.3.7-release] - 11/19/2023

 Added:

 New CritLog widget, that displays your latest Crits/Normal Hits/CritHeals/Heals. Open it with /cmcritlog that 
  you can macro.





[v0.3.6.2.5-release] - 11/12/2023

 Fixed:

 Turning off social messages was not working its fixed now.





[v0.3.6.2.4-release] - 11/12/2023

 Fixed:

 Addressed the issue where critical hits (crits) were not consistently displayed correctly in the CritMatic addon, a bug fix has been implemented. This should resolve the intermittent inaccuracies in the alerts and chat crit display.

 a bug has been fixed that was preventing new critical hits (crits) from being announced in battlegrounds, raids, and parties. This update ensures that crit announcements are correctly broadcasted in these group environments.





[v0.3.6.2.3-release] - 11/11/2023

 Fixed:

 Broadcast Bug in CritMatic. Resolved an issue in CritMatic:BroadcastVersion(). Ensures accurate new version notifications across WoW Classic, Wrath, and Retail. Please update for improved functionality and version notifications.





[v0.3.6.2.2-release] - 11/10/2023

 Fixed:

 Various fixes.





[v0.3.6.2.1-release] - 11/4/2023

 Fixed:

 We've rolled out a series of tweaks and fixes to enhance stability and performance.



[v0.3.6.2-release] - 11/4/2023

 Fixed:

 We've patched up the 'New Version' popup to ensure it's functioning smoothly. You should now receive a popup when
  an update is available, keeping you in the loop with the latest enhancements.



[v0.3.5.9.6-release] - 11/4/2023

 Updated:

 We've overhauled the internal code structure for the Options Tables to pave the way for an exciting new feature
  dubbed "CritLog." Picture a widget similar to the Deathlog addon, which you can toggle on or off. The CritLog will
  track and display your critical strikes, regular hits, critical heals, and standard heals. Accessing this feature will
  be a breeze with the new slash command `/cmlog`. Stay tuned as we begin the development phase!

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

 Resolved an edgecase condition where CritMatic erroneously reported 'not in a party or raid' within battlegrounds
  and arenas.

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

