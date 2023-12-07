local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
local MESSAGE_SPACING = 3
local MAX_MESSAGES = 4
local activeMessages = {}
--/run CritMatic.ShowNewCritMessage("Killing Spree", 300)CritMatic.ShowNewNormalMessage("Killing Spree",435)

-- Utility function to adjust message positions
local function AdjustMessagePositions()
    -- Position the first message at the top
    activeMessages[1]:SetPoint("CENTER", UIParent, "CENTER", 0, 350)

    -- Position subsequent messages relative to the previous one
    for i = 2, #activeMessages do
        activeMessages[i]:SetPoint("TOP", activeMessages[i - 1], "BOTTOM", 0, -MESSAGE_SPACING)
    end
end




-- Utility function to remove the oldest message and adjust the rest
local function RemoveOldestMessage()
    local oldestMessage = table.remove(activeMessages)  -- Remove the oldest message (first in the table)

    -- Hide the message frame and perform any necessary cleanup
    if oldestMessage then
        oldestMessage:Hide()
        -- Any additional cleanup logic, if needed
    end
end

Critmatic.MessageFrame = {}

function Critmatic.MessageFrame:CreateMessage(text, r, g, b)
    local delayInSeconds = 0.45
    local function delayedExecution()
        -- Replace frame creation with a call to CreateNewMessageFrame()
        local f = Critmatic.CreateNewMessageFrame()

        -- Set the text and color
        f.text:SetText(text)
        f.text:SetTextColor(r, g, b)

        -- Create or update the fade-out animation (if it's not already in CreateNewMessageFrame)
        f.fadeOut = f:CreateAnimationGroup()
        local fade = f.fadeOut:CreateAnimation("Alpha")
        fade:SetFromAlpha(1)
        fade:SetToAlpha(0)
        fade:SetDuration(0.5)
        fade:SetStartDelay(7.5)
        f.fadeOut:SetScript("OnFinished", function()
            f:Hide()
        end)

        -- Play the animations
        f.bounce:Play()
        f.fadeOut:Play()

        -- Insert the new message at the beginning
        table.insert(activeMessages, 1, f)

        -- Adjust positions of all messages
        AdjustMessagePositions()

        -- Remove the oldest message if there are too many
        if #activeMessages > MAX_MESSAGES then
            RemoveOldestMessage()
        end

        return f
    end

    -- Delay the execution using C_Timer
    C_Timer.After(delayInSeconds, delayedExecution)
end
local message = ""
function Critmatic.ShowNewCritMessage(spellName, amount)
    if Critmatic.db.profile.alertNotificationFormat.isUpper then
        -- If spellName does not end with 'Heal', use the format string as is
        message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.critAlertNotificationFormat, spellName, amount))
    else
        message = string.format(Critmatic.db.profile.alertNotificationFormat.critAlertNotificationFormat, spellName, amount)

    end

    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b)
end

function Critmatic.ShowNewNormalMessage(spellName, amount)
    if Critmatic.db.profile.alertNotificationFormat.isUpper then

        message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.hitAlertNotificationFormat, spellName, amount))
    else
        message = string.format(Critmatic.db.profile.alertNotificationFormat.hitAlertNotificationFormat, spellName, amount)

    end
    local message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.hitAlertNotificationFormat, spellName, amount))
    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b)

end
function Critmatic.ShowNewHealCritMessage(spellName, amount)
    if Critmatic.db.profile.alertNotificationFormat.isUpper then
        -- If spellName does not end with 'Heal', use the format string as is
        message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.critHealAlertNotificationFormat, spellName, amount))
    else
        message = string.format(Critmatic.db.profile.alertNotificationFormat.critHealAlertNotificationFormat, spellName, amount)

    end
    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b)  -- Gold color
end

function Critmatic.ShowNewHealMessage(spellName, amount)
    -- Check if the spellName ends with 'Heal', 'heal', or 'HEAL'

    if string.sub(spellName, -4):lower() == "heal" then
        -- Remove the redundant 'Heal' from the format string
        local formatString = Critmatic.db.profile.alertNotificationFormat.healAlertNotificationFormat
        formatString = string.gsub(formatString, "%%s Heal", "%%s")
        formatString = string.gsub(formatString, "%%s heal", "%%s")
        formatString = string.gsub(formatString, "%%s HEAL", "%%s")
        if Critmatic.db.profile.alertNotificationFormat.isUpper then
            message = string.upper(string.format(formatString, spellName, amount))
        else
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
            message = string.format(formatString, spellName, amount)

        end
    else
        if Critmatic.db.profile.alertNotificationFormat.isUpper then
            -- If spellName does not end with 'Heal', use the format string as is
            message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.healAlertNotificationFormat, spellName, amount))
        else
            message = string.format(Critmatic.db.profile.alertNotificationFormat.healAlertNotificationFormat, spellName, amount)

        end
    end

    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b)
end


