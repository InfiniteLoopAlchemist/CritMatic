local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
local MESSAGE_SPACING = 3

local activeMessages = {}
--/run CritMatic.ShowNewCritMessage("Killing Spree", 300)CritMatic.ShowNewNormalMessage("Killing Spree",435)

-- Utility function to convert percentage to pixel offset
local function ConvertPercentageToOffset(xPercent, yPercent)
    local screenWidth = UIParent:GetWidth()
    local screenHeight = UIParent:GetHeight()
    
    -- Convert percentages to pixel offsets from center
    local xOffset = (xPercent - 50) * screenWidth / 100
    local yOffset = (yPercent - 50) * screenHeight / 100
    
    return xOffset, yOffset
end

-- Utility function to adjust message positions
local function AdjustMessagePositions()
    -- Get position settings from database
    local xPos = Critmatic.db.profile.alertNotificationFormat.position.xPos
    local yPos = Critmatic.db.profile.alertNotificationFormat.position.yPos
    
    -- Convert percentages to pixel offsets
    local xOffset, yOffset = ConvertPercentageToOffset(xPos, yPos)
    
    -- Position the first message using configurable values
    activeMessages[1]:SetPoint("CENTER", UIParent, "CENTER", xOffset, yOffset)

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

    end
end

Critmatic.MessageFrame = {}

local ICON_SIZE = 24
local ICON_SPACING = 6

function Critmatic.MessageFrame:CreateMessage(text, r, g, b, spellIcon)
    local MAX_MESSAGES = Critmatic.db.profile.alertNotificationFormat.global.maxMessages
    local delayInSeconds = 0.45
    local function delayedExecution()
        local f = Critmatic.CreateNewMessageFrame()

        f.text:SetText(text)
        f.text:SetTextColor(r, g, b)

        if spellIcon then
            if not f.icon then
                f.icon = f:CreateTexture(nil, "ARTWORK")
                f.icon:SetSize(ICON_SIZE, ICON_SIZE)
            end
            f.icon:SetTexture(spellIcon)
            f.icon:Show()

            local textWidth = f.text:GetStringWidth() or 200
            local totalWidth = textWidth + ICON_SIZE + ICON_SPACING
            local iconOffsetX = -(totalWidth / 2) + (ICON_SIZE / 2)

            f.icon:ClearAllPoints()
            f.icon:SetPoint("CENTER", f, "CENTER", iconOffsetX, 0)

            f.text:ClearAllPoints()
            f.text:SetPoint("CENTER", f, "CENTER", (ICON_SIZE + ICON_SPACING) / 2, 0)

            if not f.iconBounce then
                f.iconBounce = f.icon:CreateAnimationGroup()
                local scaleUp = f.iconBounce:CreateAnimation("Scale")
                scaleUp:SetScale(1.5, 1.5)
                scaleUp:SetDuration(0.15)
                scaleUp:SetOrder(1)
                local pause = f.iconBounce:CreateAnimation("Pause")
                pause:SetDuration(0.12)
                pause:SetOrder(2)
                local scaleDown = f.iconBounce:CreateAnimation("Scale")
                scaleDown:SetScale(1 / 1.5, 1 / 1.5)
                scaleDown:SetDuration(0.15)
                scaleDown:SetOrder(3)
            end
            f.iconBounce:Play()
        elseif f.icon then
            f.icon:Hide()
            f.text:ClearAllPoints()
            f.text:SetAllPoints()
        end

        f.fadeOut = f:CreateAnimationGroup()
        local fade = f.fadeOut:CreateAnimation("Alpha")
        fade:SetFromAlpha(1)
        fade:SetToAlpha(0)
        fade:SetDuration(Critmatic.db.profile.alertNotificationFormat.global.fadeTime)
        fade:SetStartDelay(Critmatic.db.profile.alertNotificationFormat.global.startDelay)
        f.fadeOut:SetScript("OnFinished", function()
            f:Hide()
        end)

        f.bounce:Play()
        f.fadeOut:Play()

        table.insert(activeMessages, 1, f)
        AdjustMessagePositions()

        if #activeMessages > MAX_MESSAGES then
            RemoveOldestMessage()
        end

        return f
    end

    C_Timer.After(delayInSeconds, delayedExecution)
end
local message = ""
function Critmatic.ShowNewCritMessage(spellName, amount, spellIcon)
    if Critmatic.db.profile.alertNotificationFormat.global.isUpper then
        message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.strings
                                                      .critAlertNotificationFormat, spellName, amount))
    else
        message = string.format(Critmatic.db.profile.alertNotificationFormat.strings.critAlertNotificationFormat,
                spellName, amount)
    end

    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b, spellIcon)
end

function Critmatic.ShowNewNormalMessage(spellName, amount, spellIcon)
    if Critmatic.db.profile.alertNotificationFormat.global.isUpper then
        message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.strings
                                                      .hitAlertNotificationFormat, spellName, amount))
    else
        message = string.format(Critmatic.db.profile.alertNotificationFormat.strings.hitAlertNotificationFormat,
                spellName, amount)
    end
    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b, spellIcon)
end

function Critmatic.ShowNewHealCritMessage(spellName, amount, spellIcon)
    if Critmatic.db.profile.alertNotificationFormat.global.isUpper then
        message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.strings
                                                      .critHealAlertNotificationFormat, spellName, amount))
    else
        message = string.format(Critmatic.db.profile.alertNotificationFormat.strings.critHealAlertNotificationFormat,
                spellName, amount)
    end
    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColorCrit)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b, spellIcon)
end

function Critmatic.ShowNewHealMessage(spellName, amount, spellIcon)
    -- Check if the spellName ends with 'Heal', 'heal', or 'HEAL'

    if string.sub(spellName, -4):lower() == "heal" then
        -- Remove the redundant 'Heal' from the format string
        local formatString = Critmatic.db.profile.alertNotificationFormat.strings.healAlertNotificationFormat
        formatString = string.gsub(formatString, "%%s Heal", "%%s")
        formatString = string.gsub(formatString, "%%s heal", "%%s")
        formatString = string.gsub(formatString, "%%s HEAL", "%%s")
        if Critmatic.db.profile.alertNotificationFormat.global.isUpper then
            message = string.upper(string.format(formatString, spellName, amount))
        else

            message = string.format(formatString, spellName, amount)

        end
    else
        if Critmatic.db.profile.alertNotificationFormat.global.isUpper then
            -- If spellName does not end with 'Heal', use the format string as is
            message = string.upper(string.format(Critmatic.db.profile.alertNotificationFormat.strings
                                                          .healAlertNotificationFormat, spellName, amount))
        else
            message = string.format(Critmatic.db.profile.alertNotificationFormat.strings.healAlertNotificationFormat, spellName, amount)

        end
    end

    local r, g, b = unpack(Critmatic.db.profile.fontSettings.fontColor)
    Critmatic.MessageFrame:CreateMessage(message, r, g, b, spellIcon)
end


