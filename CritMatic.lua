local CritMaticGoldYellow = "|cffffd700"
local CritMaticGold = "|cffed9d09"
local CritMaticWhite = "|cffe8e7e3"
local CritMaticGray = "|cffc2bfb6"
local CritMaticRed = "|cffd41313"
local CritMaticBrown = "|cffada27f"

Critmatic = LibStub("AceAddon-3.0"):NewAddon(CritMaticGold .. "CritMatic|r", "AceConsole-3.0", "AceTimer-3.0",
        "AceEvent-3.0",
        "AceComm-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")

local MAX_HIT = 40000

local function GetGCD()
    local _, gcdDuration = GetSpellCooldown(78) -- 78 is the spell ID for Warrior's Heroic Strike
    if gcdDuration == 0 then
        return 1.5 -- Default GCD duration if not available (you may adjust this value if needed)
    else
        return gcdDuration
    end
end

local function IsSpellInSpellbook(spellName)
    for i = 1, GetNumSpellTabs() do
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for j = offset + 1, offset + numSpells do
            if GetSpellBookItemName(j, BOOKTYPE_SPELL) == spellName then
                return true
            end
        end
    end
    return false
end

local spellDataAggregate = {}

local function AddHighestHitsToTooltip(self, slot, isSpellBook)
    if (not slot) then
        return
    end
    local actionType, id, spellID

    if isSpellBook then
        -- Handle spellbook item
        spellID = select(3, GetSpellBookItemName(slot, BOOKTYPE_SPELL))
        actionType = "spell"
    else
        -- Handle action bar item
        actionType, id = GetActionInfo(slot)
        if actionType == "spell" then
            spellID = id
        end
    end
    local localizedSpellName = GetSpellInfo(spellID)
    -- Initialize an empty table for aggregating data by spell name

    -- Loop over all spells in CritMaticData to aggregate data by spell name
    for sID, data in pairs(CritMaticData) do
        local sName = GetSpellInfo(sID)

        if sName then
            -- Initialize the sub-table for each spell name if it doesn't exist
            if not spellDataAggregate[sName] then
                spellDataAggregate[sName] = {
                    highestCrit = 0,
                    highestNormal = 0,
                    highestHealCrit = 0,
                    highestHeal = 0,
                }
            end

            -- Now aggregate the data
            spellDataAggregate[sName].highestCrit = math.max(spellDataAggregate[sName].highestCrit, data.highestCrit or 0)
            spellDataAggregate[sName].highestNormal = math.max(spellDataAggregate[sName].highestNormal, data.highestNormal or 0)
            spellDataAggregate[sName].highestHealCrit = math.max(spellDataAggregate[sName].highestHealCrit, data.highestHealCrit or 0)
            spellDataAggregate[sName].highestHeal = math.max(spellDataAggregate[sName].highestHeal, data.highestHeal or 0)
        end

        if actionType == "spell" and spellID then
            if spellDataAggregate[localizedSpellName] then

                local cooldown = (GetSpellBaseCooldown(spellID) or 0) / 1000
                local _, _, _, castTime = GetSpellInfo(spellID)
                local effectiveCastTime = castTime > 0 and (castTime / 1000) or GetGCD()
                local effectiveTime = max(effectiveCastTime, cooldown)

                local critDPS = spellDataAggregate[localizedSpellName].highestCrit / effectiveTime
                local normalDPS = spellDataAggregate[localizedSpellName].highestNormal / effectiveTime
                local critHPS = spellDataAggregate[localizedSpellName].highestHealCrit / effectiveTime
                local normalHPS = spellDataAggregate[localizedSpellName].highestHeal / effectiveTime

                local CritMaticLeft = L["action_bar_crit"] .. ": "
                local DPS = L["action_bar_dps"] .. ") "
                local CritMaticRight = tostring(spellDataAggregate[localizedSpellName].highestCrit) .. " (" .. format("%.1f",
                        critDPS) .. DPS
                local normalMaticLeft = L["action_bar_hit"] .. ": "
                local normalMaticRight = tostring(spellDataAggregate[localizedSpellName].highestNormal) .. " (" .. format("%.1f", normalDPS) .. DPS

                local CritMaticHealLeft = L["action_bar_crit_heal"] .. ": "
                local HPS = L["action_bar_hps"] .. ") "
                local CritMaticHealRight = tostring(spellDataAggregate[localizedSpellName].highestHealCrit) .. " (" .. format("%.1f", critHPS) .. HPS
                local normalMaticHealLeft = L["action_bar_heal"] .. ": "
                local normalMaticHealRight = tostring(spellDataAggregate[localizedSpellName].highestHeal) .. " (" .. format("%.1f", normalHPS) .. HPS

                -- Check if lines are already present in the tooltip.
                local critMaticHealExists = false
                local normalMaticHealExists = false
                local critMaticExists = false
                local normalMaticExists = false

                for i = 1, self:NumLines() do
                    local gtl = _G["GameTooltipTextLeft" .. i]
                    local gtr = _G["GameTooltipTextRight" .. i]

                    if gtl and gtr then
                        -- Healing related
                        if gtl:GetText() == CritMaticHealLeft and gtr:GetText() == CritMaticHealRight then
                            critMaticHealExists = true
                        elseif gtl:GetText() == normalMaticHealLeft and gtr:GetText() == normalMaticHealRight then
                            normalMaticHealExists = true
                        end
                        -- Damage related
                        if gtl:GetText() == CritMaticLeft and gtr:GetText() == CritMaticRight then
                            critMaticExists = true
                        elseif gtl:GetText() == normalMaticLeft and gtr:GetText() == normalMaticRight then
                            normalMaticExists = true
                        end
                    end
                end

                -- This is a damaging spell
                if spellDataAggregate[localizedSpellName].highestCrit > 0 then
                    if not critMaticExists then
                        self:AddDoubleLine(CritMaticLeft, CritMaticRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0) -- left side color (white) right side color (gold)
                    end
                end

                if spellDataAggregate[localizedSpellName].highestNormal > 0 then

                    if not normalMaticExists then
                        self:AddDoubleLine(normalMaticLeft, normalMaticRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0)-- left side color (white) right side color (gold)
                    end
                end

                if spellDataAggregate[localizedSpellName].highestHealCrit > 0 then
                    if not critMaticHealExists then
                        self:AddDoubleLine(CritMaticHealLeft, CritMaticHealRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0) -- left side color (white)  right side color (gold)
                    end
                end

                if spellDataAggregate[localizedSpellName].highestHeal > 0 then

                    if not normalMaticHealExists then
                        self:AddDoubleLine(normalMaticHealLeft, normalMaticHealRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0) -- left side color (white) right side color (gold)
                    end
                end
            end

            self:Show()
        end
    end
end
-- Function to create a new frame based on the template
Critmatic.CreateNewMessageFrame = function()
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetSize(1000, 30)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 350)

    f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    f.text:SetAllPoints()

    f.bounce = f:CreateAnimationGroup()
    local scaleUp = f.bounce:CreateAnimation("Scale")
    scaleUp:SetScale(1.5, 1.5)
    scaleUp:SetDuration(0.15)
    scaleUp:SetOrder(1)
    local pause = f.bounce:CreateAnimation("Pause")
    pause:SetDuration(0.12) -- Duration of the pause
    pause:SetOrder(2) -- Second phase

    -- Scale down to original size
    local scaleDown = f.bounce:CreateAnimation("Scale")
    scaleDown:SetScale(1 / 1.5, 1 / 1.5)
    scaleDown:SetDuration(0.15) -- Duration of the scale-down phase
    scaleDown:SetOrder(3) -- Third phase
    local LSM = LibStub("LibSharedMedia-3.0")
    local fontPath = LSM:Fetch("font", Critmatic.db.profile.fontSettings.font)
    f.text:SetFont(fontPath, Critmatic.db.profile.fontSettings.fontSize, Critmatic.db.profile.fontSettings.fontOutline)
    f.text:SetShadowOffset(unpack(Critmatic.db.profile.fontSettings.fontShadowSize))
    f.text:SetShadowColor(unpack(Critmatic.db.profile.fontSettings.fontShadowColor))

    return f
end

function Critmatic:OnInitialize()
    -- Initialization code here.
    self.db = LibStub("AceDB-3.0"):New("CritMaticDB14", defaults)
    CritMaticData = CritMaticData or {}

    CritMaticData = _G["CritMaticData"]

    local version = GetAddOnMetadata("CritMatic", "Version")

    function Critmatic:OnCommReceived(prefix, message, distribution, sender)

        if message and version then

            local isNewerVersion = message > version

            if isNewerVersion and not Critmatic.hasDisplayedUpdateMessage then
                Critmatic:Print(CritMaticRed .. L["new_version_notification"] .. "|r" .. CritMaticGray .. L["new_version_notification_part"] .. "|r")
                Critmatic.hasDisplayedUpdateMessage = true
            end
        end
    end
    function compareVersions(version1, version2)
        local function splitVersion(str)
            local parts = {}
            for part in string.gmatch(str, "[%d]+") do
                table.insert(parts, tonumber(part))
            end
            return parts
        end

        local parts1 = splitVersion(version1)
        local parts2 = splitVersion(version2)

        for i = 1, math.max(#parts1, #parts2) do
            local num1 = parts1[i] or 0
            local num2 = parts2[i] or 0
            if num1 > num2 then
                return true -- version1 is newer
            elseif num1 < num2 then
                return false -- version2 is newer
            end
            -- if equal, continue to the next part
        end

        return false -- versions are equal or indistinguishable
    end

    --if self.db.profile.isCritLogFrameShown then
    toggleCritMaticCritLog() -- This will show the frame if it was shown before
    --end

    Critmatic.oldVersion = Critmatic.db.profile.oldVersion
    Critmatic.newVersion = tostring(version)
    if Critmatic.newVersion and Critmatic.oldVersion then

        local isNewerVersion = compareVersions(Critmatic.newVersion, Critmatic.oldVersion)
        if isNewerVersion then
            if Critmatic.db.profile.generalSettings.isChangeLogAutoPopUpEnabled then
                Critmatic.showChangeLog()
            end

            Critmatic.db.profile.oldVersion = Critmatic.newVersion

        end

    end
    -- Function to broadcast your version
    function Critmatic:BroadcastVersion()
        -- Check and send to guild
        if IsInGuild() then
            self:SendCommMessage("Critmatic", version, "GUILD")
        end

        local inInstance, instanceType = IsInInstance()
        if inInstance and (instanceType == "pvp" or instanceType == "arena") then
            return
        end

        -- Check if IsPartyLFG exists (Retail version)
        if IsPartyLFG and IsPartyLFG() then
            self:SendCommMessage("Critmatic", version, "INSTANCE_CHAT")
        elseif IsInRaid() then
            self:SendCommMessage("Critmatic", version, "RAID")
        else
            -- For Classic Era or if not in LFG party (Retail)
            self:SendCommMessage("Critmatic", version, "PARTY")
        end
    end

    -- Event handler for GROUP_ROSTER_UPDATE
    function Critmatic:GROUP_ROSTER_UPDATE()
        self:BroadcastVersion()
    end

    -- Register the slash commands
    Critmatic:RegisterChatCommand("critmatic", "OpenOptions")
    Critmatic:RegisterChatCommand("cm", "OpenOptions")
    Critmatic:RegisterChatCommand(L["slash_cmlog"], "OpenChangeLog")
    Critmatic:RegisterChatCommand(L["slash_cmcritlog"], function()
        toggleCritMaticCritLog()
    end)

    local function capitalizeFirstLetterOfEachWord(str)
        return (str:gsub("(%a)([%w_']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end))
    end
    -- Function to handle the slash command input
    local function resetSingleSpellDataSlashCommand(input)
        if not input or input:trim() == "" then
            Critmatic:Print(CritMaticRed .. "Please provide a spell name!" .. "|r")
            return
        end

        local capitalizedInput = capitalizeFirstLetterOfEachWord(input)
        local inputSpellName = capitalizedInput:lower() -- Standardize for comparison

        local spellFound = false
        for spellID, _ in pairs(CritMaticData) do
            local spellName = GetSpellInfo(spellID)
            if spellName and spellName:lower() == inputSpellName then
                -- Reset data for the found spell
                CritMaticData[spellID] = nil -- or reset to initial state if needed
                spellFound = true
                Critmatic:Print(CritMaticGoldYellow .. capitalizedInput .. "|r" .. CritMaticRed .. " data has been reset." .. "|r")
                RedrawCritMaticWidget()
                break
            end
        end

        if not spellFound then
            Critmatic:Print(CritMaticGoldYellow .. capitalizedInput .. "|r" .. CritMaticRed .. " is not a tracked spell currently" .. "|r")
        end

    end

    local function ignoredSpellSlashCommand(input)
        if not input or input:trim() == "" then
            Critmatic:Print(CritMaticRed .. "Please provide a spell name!" .. "|r")
            return
        end

        local capitalizedInput = capitalizeFirstLetterOfEachWord(input)
        local inputSpellName = capitalizedInput:lower() -- Standardize for comparison

        local spellFound = false
        for spellID, _ in pairs(CritMaticData) do
            local spellName = GetSpellInfo(spellID)
            if spellName and spellName:lower() == inputSpellName then
                spellFound = true
                break
            end
        end

        if not spellFound then
            Critmatic:Print(CritMaticRed .. capitalizedInput .. "|r" .. CritMaticWhite .. " is not a tracked spell currently" .. "|r")
            return
        end

        -- Add the spell name to the ignoredSpells table
        Critmatic.ignoredSpells[inputSpellName] = true
        Critmatic:Print(CritMaticGoldYellow .. capitalizedInput .. "|r" .. CritMaticWhite .. " added to " .. CritMaticRed .. "ignored" .. "|r " .. CritMaticWhite .. "spells." .. "|r")
        RedrawCritMaticWidget()
    end

    local function ListIgnoredSpells()
        if not Critmatic.ignoredSpells or next(Critmatic.ignoredSpells) == nil then
            Critmatic:Print(CritMaticRed .. "No spells are currently being ignored." .. "|r")
            return
        end

        Critmatic:Print(CritMaticRed .. "Ignored" .. "|r " .. "Spells:")
        for spellName, _ in pairs(Critmatic.ignoredSpells) do
            Critmatic:Print(CritMaticGoldYellow .. "- " .. capitalizeFirstLetterOfEachWord(spellName) .. "|r")
        end
    end

    local function RemoveIgnoredSpell(input)
        if not input or input:trim() == "" then
            Critmatic:Print(CritMaticRed .. "Please provide a spell name." .. "|r")
            return
        end

        local spellName = input:lower()  -- assuming spell names are stored in lowercase
        if Critmatic.ignoredSpells and Critmatic.ignoredSpells[spellName] then
            Critmatic.ignoredSpells[spellName] = nil
            Critmatic:Print(CritMaticGoldYellow .. capitalizeFirstLetterOfEachWord(spellName) .. "|r" .. CritMaticRed .. " has been removed from ignored spells." .. "|r")
            RedrawCritMaticWidget()
        else
            Critmatic:Print(CritMaticRed .. "Spell not found in ignored spells." .. "|r")
        end
    end
    -- Function to wipe all ignored spells
    local function WipeIgnoredSpells()
        if not Critmatic.ignoredSpells or next(Critmatic.ignoredSpells) == nil then
            Critmatic:Print(CritMaticRed .. "The ignored spells list is already empty!" .. "|r")
            return
        end

        wipe(Critmatic.ignoredSpells)  -- Clear the table
        Critmatic:Print(CritMaticRed .. "All ignored spells have been removed." .. "|r")
        RedrawCritMaticWidget()
    end
    local function ignoredTargetSlashCommand(input)
        local inputTargetID = tonumber(input)
        if not input or not inputTargetID  then
            Critmatic:Print(CritMaticRed .. "Please provide a target id!" .. "|r")
            return
        end

        -- Add the target id to the ignoredTargets table
        Critmatic.ignoredTargets[inputTargetID] = true
        Critmatic:Print(CritMaticGoldYellow .. input .. "|r" .. CritMaticWhite .. " added to " .. CritMaticRed .. "ignored" .. "|r " .. CritMaticWhite .. "targets." .. "|r")
        RedrawCritMaticWidget()
    end

    local function ListIgnoredTargets()
        if not Critmatic.ignoredTargets or next(Critmatic.ignoredTargets) == nil then
            Critmatic:Print(CritMaticRed .. "No targets are currently being ignored." .. "|r")
            return
        end

        Critmatic:Print(CritMaticRed .. "Ignored" .. "|r " .. "Targets:")
        for targetID, _ in pairs(Critmatic.ignoredTargets) do
            Critmatic:Print(CritMaticGoldYellow .. "- " .. tostring(targetID) .. "|r")
        end
    end
    local function RemoveIgnoredTarget(input)
        local targetID = tonumber(input)
        if not input or not targetID then
            Critmatic:Print(CritMaticRed .. "Please provide a target id." .. "|r")
            return
        end

        if Critmatic.ignoredTargets and Critmatic.ignoredTargets[targetID] then
            Critmatic.ignoredTargets[targetID] = nil
            Critmatic:Print(CritMaticGoldYellow .. tostring(targetID) .. "|r" .. CritMaticRed .. " has been removed from ignored targets." .. "|r")
            RedrawCritMaticWidget()
        else
            Critmatic:Print(CritMaticRed .. "Target not found in ignored targets." .. "|r")
        end
    end
    -- Function to wipe all ignored targets
    local function WipeIgnoredTargets()
        if not Critmatic.ignoredTargets or next(Critmatic.ignoredTargets) == nil then
            Critmatic:Print(CritMaticRed .. "The ignored targets list is already empty!" .. "|r")
            return
        end

        wipe(Critmatic.ignoredTargets)  -- Clear the table
        Critmatic:Print(CritMaticRed .. "All ignored targets have been removed." .. "|r")
        RedrawCritMaticWidget()
    end

    Critmatic:RegisterChatCommand("cmhelp", function()
        self:Print(CritMaticBrown .. "Commands:|r")
        print(CritMaticBrown .. "There can be is a short calibration period, if you you dont have any crit data, level up or have multiple new gear upgrades" .. "|r")
        print(CritMaticGoldYellow .. "/cm" .. "|r " .. CritMaticGray .. "- Open the CritMatic options menu." .. "|r")
        print(CritMaticGoldYellow .. "/cmlog" .. "|r " .. CritMaticGray .. "- Open the CritMatic changelog." .. "|r")
        print(CritMaticGoldYellow .. "/cmcritlog" .. "|r " .. CritMaticGray .. "- Open the CritMatic crit log." .. "|r")
        print(CritMaticGoldYellow .. "/cmcritlogdefaultpos" .. "|r " .. CritMaticGray .. "- Resets the Crit Log position. Causes a Reload." .. "|r")
        print(CritMaticGoldYellow .. "/cmdeletespelldata spell name" .. "|r " .. CritMaticGray .. "- Reset a single spell's data." .. "|r")
        print(CritMaticGoldYellow .. "/cmreset" .. "|r " .. CritMaticGray .. "- Reset all CritMatic data." .. "|r")
        print(CritMaticGoldYellow .. "/cmignore  spell name" .. "|r " .. CritMaticGray .. "- Ignore a spell." .. "|r")
        print(CritMaticGoldYellow .. "/cmignoredspells" .. "|r " .. CritMaticGray .. "- List all ignored spells." .. "|r")
        print(CritMaticGoldYellow .. "/cmremoveignoredspell spell name" .. "|r  " .. CritMaticGray .. "- Remove a spell from the ignored spells list." .. "|r")
        print(CritMaticGoldYellow .. "/cmwipeignoredspells" .. "|r  " .. CritMaticGray .. "- Remove all spells from the ignored spells list." .. "|r")
        print(CritMaticGoldYellow .. "/cmignoretarget  target id" .. "|r " .. CritMaticGray .. "- Ignore a target." .. "|r")
        print(CritMaticGoldYellow .. "/cmignoredtargets" .. "|r " .. CritMaticGray .. "- List all ignored targets." .. "|r")
        print(CritMaticGoldYellow .. "/cmremoveignoredtarget target id" .. "|r  " .. CritMaticGray .. "- Remove a target from the ignored target list." .. "|r")
        print(CritMaticGoldYellow .. "/cmwipeignoredtargets" .. "|r  " .. CritMaticGray .. "- Remove all targets from the ignored targets list." .. "|r")

    end)
    Critmatic:RegisterChatCommand("cmdeletespelldata", resetSingleSpellDataSlashCommand)
    Critmatic:RegisterChatCommand("cmwipeignoredspells", WipeIgnoredSpells)
    Critmatic:RegisterChatCommand("cmremoveignoredspell", RemoveIgnoredSpell)
    Critmatic:RegisterChatCommand("cmignoredspells", ListIgnoredSpells)
    Critmatic:RegisterChatCommand("cmwipeignoredtargets", WipeIgnoredTargets)
    Critmatic:RegisterChatCommand("cmignoredtargets", ListIgnoredTargets)
    Critmatic:RegisterChatCommand(L["slash_cmignore"], ignoredSpellSlashCommand)
    Critmatic:RegisterChatCommand(L["slash_cmreset"], "CritMaticReset")
    Critmatic:RegisterChatCommand(L["slash_cmignoretarget"], ignoredTargetSlashCommand)

    self:RegisterComm("Critmatic")
    -- Trigger version broadcast when group roster updates
    Critmatic:RegisterEvent("GROUP_ROSTER_UPDATE", "BroadcastVersion")
    -- Function to handle incoming messages

    hooksecurefunc(GameTooltip, "SetAction", AddHighestHitsToTooltip)
    local GameTooltip = IsAddOnLoaded("ElvUI") and _G.ElvUISpellBookTooltip or _G.GameTooltip
    hooksecurefunc(GameTooltip, "SetSpellBookItem", AddHighestHitsToTooltip)

    function Critmatic:CritMaticLoaded()
        self:Print(CritMaticGray .. " " .. L["version_string"] .. "|r" .. CritMaticWhite .. " " .. version .. "|r " .. CritMaticGray .. L["critmatic_loaded"] .. CritMaticGoldYellow .. "  /cm" .. "|r" .. CritMaticGray .. " " .. L["critmatic_loaded_for_options"] .. "|r " .. CritMaticGoldYellow .. L["critmatic_loaded_cmhelp"] .. "|r " .. CritMaticGray .. L["critmatic_loaded_for_all_slash_commands"] .. "|r ")
    end

    local f = Critmatic.CreateNewMessageFrame()
    -- Ensure Ace3 and AceGUI are loaded

    function Critmatic:TimerCritMaticLoaded()
        Critmatic:CritMaticLoaded()
    end

    if IsAddOnLoaded("ElvUI") then
        Critmatic:ScheduleTimer("TimerCritMaticLoaded", 8)
    else
        Critmatic:ScheduleTimer("TimerCritMaticLoaded", 4)
    end


    -- Flag to indicate whether the message has been displayed
    Critmatic.hasDisplayedUpdateMessage = false

end

function Critmatic:OnEnable()
    -- Called when the addon is fully loaded and all saved variables are available.
    CritMaticData = _G["CritMaticData"]
    CritMatic_ignoredSpells = CritMatic_ignoredSpells or {}
    Critmatic.ignoredSpells = CritMatic_ignoredSpells
    CritMatic_ignoredTargets = CritMatic_ignoredTargets or {}
    Critmatic.ignoredTargets = CritMatic_ignoredTargets
    -- Now that we know our data is available, we can safely draw the widget.
    RedrawCritMaticWidget()
end

function Critmatic:OnDisable()
    -- Code to run when the addon is disabled.
end
function Critmatic:OpenOptions()
    LibStub("AceConfigDialog-3.0"):Open("CritMaticOptions")
end
function Critmatic:OpenCritLog()
    toggleCritMaticCritLog()
end
function Critmatic:OpenChangeLog()
    self.showChangeLog()
end

function Critmatic:CritMaticReset()
    CritMaticData = {}
    Critmatic:Print(CritMaticRed .. L["critmatic_reset"] .. "|r")
    RedrawCritMaticWidget()

end

-- Register an event that fires when the player hits an enemy.
local f = CreateFrame("FRAME")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("GROUP_JOINED")

-- Variables to hold the highest values during combat
local highestCritDuringCombat = 0
local highestCritHealDuringCombat = 0
local highestCritSpellName = ""
local highestCritHealSpellName = ""
f:SetScript("OnEvent", function(self, event, ...)


    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local eventInfo = { CombatLogGetCurrentEventInfo() }

        local _, eventType, _, sourceGUID, _, _, _, destGUID = unpack(eventInfo)
        local _, spellID, spellName, spellSchool, amount, overhealing, absorbed, critical
        if eventType == "SWING_DAMAGE" then
            spellName = "Auto Attack"
            spellID = 6603 -- or specify the path to a melee icon, if you have one
            amount, _, _, _, _, _, critical = unpack(eventInfo, 12, 18)
        elseif eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
            spellID, spellName, spellSchool = unpack(eventInfo, 12, 14)
            amount, overhealing, absorbed, critical = unpack(eventInfo, 15, 18)
        elseif eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
            spellID, spellName, spellSchool = unpack(eventInfo, 12, 14)
            amount, overhealing, _, _, _, absorbed, critical = unpack(eventInfo, 15, 21)
        end

        local localizedSpellName = GetSpellInfo(spellID)
        local baseSpellName = localizedSpellName

        local LSM = LibStub("LibSharedMedia-3.0")
        local soundCrit = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.damageCrit)
        local soundNormal = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.damageNormal)
        local soundHealCrit = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.healCrit)
        local soundHealNormal = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.healNormal)

        if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") and destGUID ~= UnitGUID("player") and (eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" or eventType == "SPELL_PERIODIC_DAMAGE") and amount > 0 then

            if spellID then
                CritMaticData[spellID] = CritMaticData[spellID] or {
                    highestCrit = 0,
                    highestCritOld = 0,
                    highestNormal = 0,
                    hightestNormalOld = 0,
                    highestHealCrit = 0,
                    highestHealCritOld = 0,
                    highestHeal = 0,
                    highestHealOld = 0,

                }

                if Critmatic.ignoredSpells then
                    for spellName, _ in pairs(Critmatic.ignoredSpells) do
                        if spellName:lower() == baseSpellName:lower() then
                            return
                        end
                    end
                end
                local _, _, _, _, _, destID, _ = strsplit("-", destGUID)		
                destID = tonumber(destID)
                if Critmatic.ignoredTargets then
                    for targetID, _ in pairs(Critmatic.ignoredTargets) do
                        if targetID == destID then
                            return
                        end
                    end
                end
                --print(CombatLogGetCurrentEventInfo())



                if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
                    if critical then

                        -- When the event is a heal and it's a critical heal.
                        if amount > CritMaticData[spellID].highestHealCrit and amount <= MAX_HIT then
                            CritMaticData[spellID].highestHealCritOld = CritMaticData[spellID].highestHealCrit
                            CritMaticData[spellID].highestHealCrit = amount

                            highestCritHealDuringCombat = amount
                            highestCritHealSpellName = baseSpellName
                            if not Critmatic.db.profile.soundSettings.muteAllSounds then
                                PlaySoundFile(soundHealCrit)
                            end

                            --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")

                            if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                                Critmatic.ShowNewHealCritMessage(baseSpellName, amount)
                            end

                            if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                                Critmatic:Print(CritMaticGoldYellow .. L["chat_crit_heal"] .. baseSpellName .. ": |r" ..
                                        CritMaticData[spellID].highestHealCrit)
                            end
                            RecordEvent(spellID)
                            RedrawCritMaticWidget()
                        end
                    elseif not critical then
                        if amount > CritMaticData[spellID].highestHeal and amount <= MAX_HIT then
                            CritMaticData[spellID].highestHealOld = CritMaticData[spellID].highestHeal
                            CritMaticData[spellID].highestHeal = amount

                            if not Critmatic.db.profile.soundSettings.muteAllSounds then
                                PlaySoundFile(soundHealNormal)
                            end

                            --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heaven.ogg", "SFX")

                            if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                                Critmatic.ShowNewHealMessage(baseSpellName, amount)
                            end

                            if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                                Critmatic:Print(" " .. CritMaticWhite .. L["chat_heal"] .. baseSpellName .. ": " .. CritMaticData[spellID].highestHeal .. "|r")
                            end
                            RecordEvent(spellID)
                            RedrawCritMaticWidget()
                        end
                    end
                elseif eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
                    if critical then
                        -- When the event is damage and it's a critical hit.
                        if amount > CritMaticData[spellID].highestCrit and amount <= MAX_HIT then
                            CritMaticData[spellID].highestCritOld = CritMaticData[spellID].highestCrit
                            CritMaticData[spellID].highestCrit = amount
                            highestCritDuringCombat = amount
                            highestCritSpellName = baseSpellName
                            --PlaySound(888, "SFX")
                            if not Critmatic.db.profile.soundSettings.muteAllSounds then
                                PlaySoundFile(soundCrit)
                            end

                            --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")
                            if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                                Critmatic.ShowNewCritMessage(baseSpellName, amount)
                            end

                            if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                                Critmatic:Print(CritMaticGoldYellow .. L["chat_crit"] .. baseSpellName .. ": |r" ..
                                        CritMaticData[spellID].highestCrit)
                            end
                            RecordEvent(spellID)
                            RedrawCritMaticWidget()
                        end
                    elseif not critical then
                        -- When the event is damage but it's not a critical hit.
                        if amount > CritMaticData[spellID].highestNormal and amount <= MAX_HIT then
                            CritMaticData[spellID].highestNormalOld = CritMaticData[spellID].highestNormal
                            CritMaticData[spellID].highestNormal = amount
                            if not Critmatic.db.profile.soundSettings.muteAllSounds then
                                PlaySoundFile(soundNormal)
                            end

                            --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heroism_Cast.ogg", "SFX")
                            if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                                Critmatic.ShowNewNormalMessage(baseSpellName, amount)
                            end

                            if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                                Critmatic:Print(CritMaticWhite .. L["chat_hit"] .. baseSpellName .. ": " ..
                                        CritMaticData[spellID].highestNormal .. "|r")
                            end
                            RecordEvent(spellID)
                            RedrawCritMaticWidget()
                        end
                    end
                end

                -- end


            end
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- First check if we are in an instance and what type it is
        local inInstance, instanceType = IsInInstance()

        local function sendChat(chatType)
            -- For highest critical hit
            if highestCritDuringCombat > 0 then
                SendChatMessage("{star}CritMatic: " .. L["social_crit"] .. highestCritSpellName .. ": " .. highestCritDuringCombat, chatType)
            end
            -- For highest critical heal
            if highestCritHealDuringCombat > 0 then
                SendChatMessage("{star}CritMatic: " .. L["social_crit_heal"] .. highestCritHealSpellName .. ": " .. highestCritHealDuringCombat, chatType)
            end
        end

        if IsInGuild() and Critmatic.db.profile.social.canSendCritsToGuild then

            sendChat("GUILD")
        end

        if IsInGroup() then

            if inInstance and (instanceType == "pvp") and Critmatic.db.profile.social.canSendCritsToBattleGrounds then
                sendChat("INSTANCE_CHAT")
            elseif IsPartyLFG and IsPartyLFG() and Critmatic.db.profile.social.canSendCritsToParty then
                sendChat("INSTANCE_CHAT")
            elseif IsInRaid() and Critmatic.db.profile.social.canSendCritsToRaid then
                sendChat("RAID")
            else
                if Critmatic.db.profile.social.canSendCritsToParty then
                    sendChat("PARTY")
                end
            end

        end

        highestCritDuringCombat = 0
        highestCritHealDuringCombat = 0
        highestCritSpellName = ""
        highestCritHealSpellName = ""
    end
end)
