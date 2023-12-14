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

[v0.4.2.7.2-release] - 12/14/2023

 Fixed:

 Various bug fixes.





[v0.4.2.7.1-release] - 12/10/2023




[v0.4.2.7-release] - 12/6/2023

 Added:

 Added options for maxMessages, startDelay, and fadeTime settings also a way to reset them.





[v0.4.2.5-release] - 12/6/2023

 Added:

 Added alert notification preview feature in options under Alert

 Chat customization is coming next.





[v0.4.2.1-release] - 12/4/2023

 Updated:

 Removed ignore Auto Attack from options. You can use /cmignore spell name to ignore Auto Attack instead.


 Added:

 You can now customize the alert notification message. Use /cm Its under Alert. Soon chat messages too.





[v0.4.1-release] - 12/3/2023

 Updated:

 When you use /cmcritlogdefaultpos it will now show if its currently hidden.



[v0.4.0-release] - 12/2/2023

 Fixed:

 Fixed issue where Crit Log shifts right on Reload/Logout.

 Added:

 To reset specific spell data, use the command /cmdeletespelldata spell name This avoids the need to clear all data
  with /cmreset.



[v0.3.9.8-release] - 12/1/2023

 Added:

 Added a new slash command to reset the position of Crit Log if it goes off screen. Use /cmcritlogdefaultpos Causes a
  ReloadUI.



[v0.3.9.7-release] - 12/1/2023



[v0.3.9.6-release] - 12/1/2023

 Fixed:

 Removed localization for everything but English for now, because it was causing bugs.



[v0.3.9.5-release] - 11/30/2023

 Fixed:

 Resolved issue with /cmcritlog slash command not functioning as expected.

 Additional slash commands have been tested and confirmed operational.

 Updated:

 You can now ignore specific spells from tracking by using /cmignore Spell Name.

 Make sure the spelling is correct, but it's case insensitive. Use /cmhelp for even more slash commands.



[v0.3.8.8-release] - 11/29/2023

 Updated:

 We need your help translating CritMatic to other languages just visit the localization tab
  on https://legacy.curseforge.com/wow/addons/critmatic to start.

 You will translation credit in the addon and on CurseForge.



[v0.3.8.3-release] - 11/26/2023

 Fixed:

 A bug where spells not in the spellbook caused an error for the action bar tooltip.



[v0.3.8.2-release] - 11/25/2023

 Fixed:

 Good news! We've fixed a bug that affected how the crit log displayed information for spells that can both heal and
  damage. Previously, if a spell had both of these capabilities, the crit log wasn't displaying correctly.

 This issue did not affect spells that were exclusively for healing or damage. With this latest update, you can
  expect accurate and consistent display for all spells, regardless of whether they heal, damage, or do both.

 Thank you for your continued support and feedback, which helps us improve CritMatic. Enjoy your enhanced gaming
  experience!



[v0.3.8-release] - 11/24/2023

 Updated:

 Changed the spell data handling from using spell names to spell IDs. This update enhances localization support,
  allowing CritMatic to be more compatible with different language settings and paving the way for future international
  releases.

 Due to this change, existing spell data in CritMatic had to be cleared. We apologize for any inconvenience this may
  cause and appreciate your understanding.



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

 Addressed the issue where critical hits (crits) were not consistently displayed correctly in the CritMatic addon, a
  bug fix has been implemented. This should resolve the intermittent inaccuracies in the alerts and chat crit display.

 a bug has been fixed that was preventing new critical hits (crits) from being announced in battlegrounds, raids, and
  parties. This update ensures that crit announcements are correctly broadcasted in these group environments.


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

