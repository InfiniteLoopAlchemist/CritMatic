-- Define a table to hold the highest hits data.
CritMaticData = CritMaticData or {}

--CTODO:  make a changes popup like details  does

local MAX_HIT = 40000

local function GetGCD()
  local _, gcdDuration = GetSpellCooldown(78) -- 78 is the spell ID for Warrior's Heroic Strike
  if gcdDuration == 0 then
    return 1.5 -- Default GCD duration if not available (you may adjust this value if needed)
  else
    return gcdDuration
  end
end
-- Function to create a new frame based on the template
CritMatic.CreateNewMessageFrame = function()
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
  local fontPath = LSM:Fetch("font", db.profile.fontSettings.font)
  f.text:SetFont(fontPath, db.profile.fontSettings.fontSize, db.profile.fontSettings.fontOutline)
  f.text:SetShadowOffset(unpack(db.profile.fontSettings.fontShadowSize))
  f.text:SetShadowColor(unpack(db.profile.fontSettings.fontShadowColor))

  return f
end

local function removeImproved(spellName)
  -- Stripping out "Improved " prefix
  local baseSpellName = spellName
  if spellName and string.sub(spellName, 1, 8) == "Improved" then
    baseSpellName = string.sub(spellName, 10)
  end
  return baseSpellName
end

local function IsSpellInSpellbook(spellName)
  local name = GetSpellInfo(spellName)
  return name ~= nil
end
local function checkAlertNotifications(input)
  print("Alert Notifications Enabled: ", db.profile.social.alertNotificationsEnabled)  -- Debugging line
  if db.profile.social.alertNotificationsEnabled == true then
    return input
  end
end

local function checkChatNotifications(input)
  print("Chat Notifications Enabled: ", db.profile.social.chatNotificationsEnabled)  -- Debugging line
  if db.profile.social.chatNotificationsEnabled == true then
    return input
  end
end


local function AddHighestHitsToTooltip(self, slot, isSpellBook)
  if (not slot) then
    return
  end
  local actionType, id, spellName, castTime
  if isSpellBook then
    -- Handle spellbook item
    spellName = GetSpellBookItemName(slot, BOOKTYPE_SPELL)
    id, _, _, castTime = GetSpellInfo(spellName)
    actionType = "spell"
  else
    -- Handle action bar item
    actionType, id = GetActionInfo(slot)
    spellName, _, _, castTime = GetSpellInfo(id)
  end
  if actionType == "spell" then

    local baseSpellName = removeImproved(spellName)

    if CritMaticData[baseSpellName] then

      local cooldown = (GetSpellBaseCooldown(id) or 0) / 1000
      --TODO: if the action is less than the GCD, use the GCD instead
      local effectiveCastTime = castTime > 0 and (castTime / 1000) or GetGCD()
      local effectiveTime = max(effectiveCastTime, cooldown)

      local critHPS = CritMaticData[baseSpellName].highestHealCrit / effectiveTime
      local normalHPS = CritMaticData[baseSpellName].highestHeal / effectiveTime
      local critDPS = CritMaticData[baseSpellName].highestCrit / effectiveTime
      local normalDPS = CritMaticData[baseSpellName].highestNormal / effectiveTime

      local CritMaticHealLeft = "Highest Heal Crit: "
      local CritMaticHealRight = tostring(CritMaticData[baseSpellName].highestHealCrit) .. " (" .. format("%.1f", critHPS) .. " HPS)"
      local normalMaticHealLeft = "Highest Heal Normal: "
      local normalMaticHealRight = tostring(CritMaticData[baseSpellName].highestHeal) .. " (" .. format("%.1f", normalHPS) .. " HPS)"

      local CritMaticLeft = "Highest Crit: "
      local CritMaticRight = tostring(CritMaticData[baseSpellName].highestCrit) .. " (" .. format("%.1f", critDPS) .. " DPS)"
      local normalMaticLeft = "Highest Normal: "
      local normalMaticRight = tostring(CritMaticData[baseSpellName].highestNormal) .. " (" .. format("%.1f", normalDPS) .. " DPS)"

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

      if CritMaticData[baseSpellName].highestHealCrit > 0 then
        if not critMaticHealExists then
          self:AddDoubleLine(CritMaticHealLeft, CritMaticHealRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0) -- left side color (white)  right side color (gold)
        end
      end

      if CritMaticData[baseSpellName].highestHeal > 0 then

        if not normalMaticHealExists then
          self:AddDoubleLine(normalMaticHealLeft, normalMaticHealRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0) -- left side color (white) right side color (gold)
        end
      end

      -- This is a damaging spell
      if CritMaticData[baseSpellName].highestCrit > 0 then
        if not critMaticExists then
          self:AddDoubleLine(CritMaticLeft, CritMaticRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0) -- left side color (white) right side color (gold)
        end
      end

      if CritMaticData[baseSpellName].highestNormal > 0 then

        if not normalMaticExists then
          self:AddDoubleLine(normalMaticLeft, normalMaticRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0)-- left side color (white) right side color (gold)
        end
      end

      self:Show()
    end
  end
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
highestCritSpellName = ""
highestCritHealSpellName = ""
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

    local baseSpellName = removeImproved(spellName)

    if baseSpellName == "Auto Attack" and not db.profile.generalSettings.autoAttacksEnabled then
      return
    end
    local LSM = LibStub("LibSharedMedia-3.0")
    local soundCrit = LSM:Fetch("sound", db.profile.soundSettings.damageCrit)
    local soundNormal = LSM:Fetch("sound", db.profile.soundSettings.damageNormal)
    local soundHealCrit = LSM:Fetch("sound", db.profile.soundSettings.healCrit)
    local soundHealNormal = LSM:Fetch("sound", db.profile.soundSettings.healNormal)

    if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") and destGUID ~= UnitGUID("player") and (eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" or eventType == "SPELL_PERIODIC_DAMAGE") and amount > 0 then
      if baseSpellName then
        CritMaticData[baseSpellName] = CritMaticData[baseSpellName] or {
          highestCrit = 0,
          highestNormal = 0,
          highestHealCrit = 0,
          highestHeal = 0,

        }


        if IsSpellInSpellbook(baseSpellName) or baseSpellName == "Auto Attack" then
          --print(CombatLogGetCurrentEventInfo())

          if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
            if critical then

              -- When the event is a heal and it's a critical heal.
              if amount > CritMaticData[baseSpellName].highestHealCrit and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestHealCrit = amount
                if not db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundHealCrit)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")

                if db.profile.generalSettings.alertNotificationsEnabled then
                  CritMatic.ShowNewHealCritMessage(baseSpellName, amount)
                end

                if db.profile.generalSettings.chatNotificationsEnabled then
                  print("|cffffd700New highest crit heal for " .. baseSpellName .. ": |r" ..
                          CritMaticData[baseSpellName].highestHealCrit)
                end

              end
            elseif not critical then
              if amount > CritMaticData[baseSpellName].highestHeal and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestHeal = amount

                if not db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundHealNormal)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heaven.ogg", "SFX")

                if db.profile.generalSettings.alertNotificationsEnabled then
                  CritMatic.ShowNewHealMessage(baseSpellName, amount)
                end

                if db.profile.generalSettings.chatNotificationsEnabled then
                  print("New highest normal heal for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestHeal)
                end

              end
            end
          elseif eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
            if critical then
              -- When the event is damage and it's a critical hit.
              if amount > CritMaticData[baseSpellName].highestCrit and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestCrit = amount
                --PlaySound(888, "SFX")
                if not db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundCrit)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")
                if db.profile.generalSettings.alertNotificationsEnabled then
                  CritMatic.ShowNewCritMessage(baseSpellName, amount)
                end

                if db.profile.generalSettings.chatNotificationsEnabled then
                  print("|cffffd700New highest crit hit for " .. baseSpellName .. ": |r" ..
                          CritMaticData[baseSpellName].highestCrit)
                end

              end
            elseif not critical then
              -- When the event is damage but it's not a critical hit.
              if amount > CritMaticData[baseSpellName].highestNormal and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestNormal = amount
                if not db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundNormal)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heroism_Cast.ogg", "SFX")
                if db.profile.generalSettings.alertNotificationsEnabled then
                  CritMatic.ShowNewNormalMessage(baseSpellName, amount)
                end

                if db.profile.generalSettings.chatNotificationsEnabled then
                  print("New highest normal hit for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestNormal)
                end

              end
            end
          end

            ProcessNewHighs(eventType, baseSpellName, amount, critical)

        end
      end
    end
  elseif event == "PLAYER_REGEN_ENABLED" then

    if IsInGroup() and db.profile.social.canSendCritsToParty then
      -- For highest critical hit
      if highestCritDuringCombat > 0 then

        SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " ..
                highestCritDuringCombat,  IsPartyLFG() and "INSTANCE_CHAT" or "PARTY"  )
      end
      -- For highest critical heal
      if highestCritHealDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " ..
                highestCritHealDuringCombat,  IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
      end
    elseif IsInRaid() and db.profile.social.canSendCritsToRaid then
      if highestCritDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " ..
                highestCritDuringCombat,  "RAID"  )
      end
      -- For highest critical heal
      if highestCritHealDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " ..
                highestCritHealDuringCombat, "RAID")
      end
    elseif IsInGuild() and db.profile.social.canSendCritsToGuild then
      if highestCritDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " ..
                highestCritDuringCombat,  "GUILD"  )
      end
      -- For highest critical heal
      if highestCritHealDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " ..
                highestCritHealDuringCombat,  "GUILD")
      end

    end



    highestCritDuringCombat = 0
      highestCritHealDuringCombat = 0
      highestCritSpellName  = ""
      highestCritHealSpellName = ""
    end
end)
-- Function to process new high values during combat
function ProcessNewHighs(eventType, baseSpellName, amount, critical)
  if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
    if critical then
      if amount > highestCritHealDuringCombat then
        highestCritHealDuringCombat = amount
        highestCritHealSpellName = baseSpellName
      end
    end
  elseif eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
    if critical then
      if amount > highestCritDuringCombat then
        highestCritDuringCombat = amount
        highestCritSpellName = baseSpellName
      end
    end
  end
end
Critmatic = LibStub("AceAddon-3.0"):NewAddon("|cffffd700CritMatic|r", "AceConsole-3.0", "AceTimer-3.0" ,"AceEvent-3.0","AceComm-3.0")

local version = GetAddOnMetadata("CritMatic", "Version")

local function CritMaticLoaded()
  Critmatic:Print("|cff918d86 v|r|cffd3cfc7 " .. version .. "|r|cff918d86 Loaded! - Use|cffffd700 /cm|r|cff918d86 for options|r")
end

function Critmatic:TimerCritMaticLoaded()
  CritMaticLoaded()
end

function Critmatic:OpenOptions()
  LibStub("AceConfigDialog-3.0"):Open("CritMaticOptions")
end
-- Flag to indicate whether the message has been displayed
Critmatic.hasDisplayedUpdateMessage = false

function Critmatic:OnCommReceived(prefix , message, distribution, sender)

  if message and version then

    local isNewerVersion = message > version

    if isNewerVersion and not Critmatic.hasDisplayedUpdateMessage then
      Critmatic:Print("|cff0000ffAn updated version of CritMatic has been released. We strongly recommend upgrading to the latest version for enhanced features and stability.|r |cff918d86The update is available on CurseForge, Wago .io, and WoW Interface.|r")
      Critmatic.hasDisplayedUpdateMessage = true
    end
  end
end





-- Function to broadcast your version
function Critmatic:BroadcastVersion()
  -- Check and send to guild
  if IsInGuild() then
    self:SendCommMessage("Critmatic", version, "GUILD")
  end
    self:SendCommMessage("Critmatic", version, IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
  if IsInRaid() then
    self:SendCommMessage("Critmatic", version, "RAID")
  end
end

-- Event handler for GROUP_ROSTER_UPDATE
function Critmatic:GROUP_ROSTER_UPDATE()
  self:BroadcastVersion()
end


-- Called when the addon is loaded
function Critmatic:OnInitialize()

  db = LibStub("AceDB-3.0"):New("CritMaticDB14", defaults)
  CritMaticData = _G["CritMaticData"]
  -- Register console commands
  Critmatic:RegisterChatCommand("cmreset", "CritMaticReset")
  -- Register the slash commands
  Critmatic:RegisterChatCommand("critmatic", "OpenOptions")
  Critmatic:RegisterChatCommand("cm", "OpenOptions")
  Critmatic:RegisterChatCommand("cmdbreset", "CritMaticDBReset")

  self:RegisterComm("Critmatic")
  -- Trigger version broadcast when group roster updates
  Critmatic:RegisterEvent("GROUP_ROSTER_UPDATE", "BroadcastVersion")
  -- Function to handle incoming messages

  hooksecurefunc(GameTooltip, "SetAction", AddHighestHitsToTooltip)
  local GameTooltip = IsAddOnLoaded("ElvUI") and _G.ElvUISpellBookTooltip or _G.GameTooltip
  hooksecurefunc(GameTooltip, "SetSpellBookItem", AddHighestHitsToTooltip)
  local f = CritMatic.CreateNewMessageFrame()
  -- Ensure Ace3 and AceGUI are loaded
  local SharedMedia = LibStub("LibSharedMedia-3.0")
  local borders = SharedMedia:List("border")
  print("Available Border Textures:")
  for i, name in ipairs(borders) do
    print(name)
  end
  -- Ensure Ace3 and AceGUI are loaded
  local AceGUI = LibStub("AceGUI-3.0")

  -- Ensure SharedMedia is loaded
  local SharedMedia = LibStub("LibSharedMedia-3.0")

  -- Function to show the change log
  local function ShowChangeLog()
    -- Create a container frame
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("CritMatic - Change Log")
    frame:SetStatusText("Need Help? Follow the Discord Link in General Options. ")
    frame:SetLayout("Fill")
    frame:SetWidth(600)
    frame:SetHeight(500)

    local backgroundTexture = SharedMedia:Fetch("background", "Blizzard Parchment 2")
    frame.frame:SetBackdrop({
      bgFile = backgroundTexture,
      edgeFile = SharedMedia:Fetch("border", "Blizzard Achievement Wood"),  -- Set the border to "Parchment 2"
      edgeSize = 24,
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

  [v0.3.5.3-release] - 10/29/2023

    Fixed:
      Various Fixes.


  [v0.3.5.1-release] - 10/29/2023

   Fixed:
    I left some debug print statements in. Sorry about that.


  [v0.3.5-release] - 10/28/2023

   Added:

    CritMatic is now compatible with Retail.


  [v0.3.4.1-release] - 10/28/2023

   Added:

    Added Options to send Crits to Raid and Guild.


  [v0.3.3-release] - 10/28/2023

     Added:

      Added notification when CritMatic is out of date.


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


## [v0.2.8-release] - 10/21/2023

### Added:

- **Option to track auto attacks or not.**


## [v0.2.5.7-release] - 9/27/2023

### Updated:

- **Various Fixes.**


## [v0.2.5.6-relea## [v0.3.5.3-release] - 10/29/2023

### Fixed:

- **Various Fixes.**


## [v0.3.5.1-release] - 10/29/2023

### Fixed:

- **I left some debug print statements in. Sorry about that.**


## [v0.3.5-release] - 10/28/2023

### Added:

- **CritMatic is now compatible with Retail.**


## [v0.3.4.1-release] - 10/28/2023

### Added:

- **Added Options to send Crits to Raid and Guild.**


## [v0.3.3-release] - 10/28/2023

### Added:

- **Added notification when CritMatic is out of date.**


## [v0.3.2-release] - 10/26/2023

### Updated:

- **Various changes.**

### Added:

- **General options.**


## [v0.3.1-release] - 10/26/2023

### Fixed:

- **After Working on the addon all day I left some debug messages.**

### Updated:

- **Party Notifications updated: Now only displays Critical Hits and Critical Heals. Removed notifications for Normal Hits and Heals.**

### Added:

- **Option to shut up CritMatic party notifications**


## [v0.3.0-release] - 10/25/2023


## [v0.2.9.1-release] - 10/22/2023

### Updated:

- **Quick hot fix**

- **Changed the color of the crit heal and normal crits chat notifications to gold.**

### Added:

- **Options to turn off chat and alert notifications.**


## [v0.2.8-release] - 10/21/2023

### Added:

- **Option to track auto attacks or not.**


## [v0.2.5.7-release] - 9/27/2023

### Updated:

- **Various Fixes.**


## [v0.2.5.6-release] - 9/27/2023

### Updated:

- **Various Changes.**


## [v0.2.5.5-release] - 9/26/2023

### Fixed:

- **Various Fixes.**


## [v0.2.3-release] - 9/19/2023

### Fixed

- **Fixed the problem for setting not saving on exit or reload.**

### Updated

- **Changed the default font size to 22**
- **Delayed the notification message by 0.45**

## [v0.2.2-release] - 9/17/2023

### Updated

- **Changed the default font size to 24**
- **Delayed the notification message, by adding 0.25 seconds to it. So you have more time to notice the animation.**

## [v0.2.1.5-release] - 9/12/2023

### Fixed

- **Fixed Various Bugs.**

## [v0.2.1-release] - 9/10/2023

### Added

- **Added Font Settings**

- **More options coming soon**

## [v0.2.0-release] - 9/05/2023

### Added

- **New Slash Commands to open the options menu /cm and /critmatic**
- **You can Change the Crit and Normal hit / heal sounds.**
  More options coming soon

## [v0.1.6-release] - 9/01/2023

### Updated

- **Updated the notification animation.**

## [v0.1.6-release] - 8/29/2023

### Fixed

- **Fixed a bug that would not display the first Crit/Normal/Heal notification when just starting the game.**

## [v0.1.5.6-release] - 8/28/2023

### Added

- **Added A new Heal Sound SFX for Normal Heals.**

## [v0.1.5.5-release] - 8/27/2023

- **Fixed A bug where there was no sound for normal hit/heals**

### Added

- **Added Support for Classic Era / Hardcore.**
- **Updated Notification Animation.**

## [v0.1.4-alpha] - 8/23/2023

### Added

- **Added new Crit animation for crits.**
- **Added CritMatic tooltip information to the spell-book.**

## [v0.1.3-alpha] - 8/20/2023

### Fixed

- **A bug where hit messages disappearing too fast.**

## [v0.1.2-alpha] - 8/18/2023

### Added

- **Added a max for crits,heals and normal hits so on some bosses you don't get a 1 million crits.**
- **Added a check to prevent CritMatic from attempting to track spells that are not in your spell-book.**

se] - 9/27/2023


## [v0.2.5.5-release] - 9/26/2023

### Fixed:

- **Various Fixes.**


## [v0.2.3-release] - 9/19/2023

### Fixed

- **Fixed the problem for setting not saving on exit or reload.**

### Updated

- **Changed the default font size to 22**
- **Delayed the notification message by 0.45**

## [v0.2.2-release] - 9/17/2023

### Updated

- **Changed the default font size to 24**
- **Delayed the notification message, by adding 0.25 seconds to it. So you have more time to notice the animation.**

## [v0.2.1.5-release] - 9/12/2023

### Fixed

- **Fixed Various Bugs.**

## [v0.2.1-release] - 9/10/2023

### Added

- **Added Font Settings**

- **More options coming soon**

## [v0.2.0-release] - 9/05/2023

### Added

- **New Slash Commands to open the options menu /cm and /critmatic**
- **You can Change the Crit and Normal hit / heal sounds.**
  More options coming soon

## [v0.1.6-release] - 9/01/2023

### Updated

- **Updated the notification animation.**

## [v0.1.6-release] - 8/29/2023

### Fixed


- **A bug where hit messages disappearing too fast.**

## [v0.1.2-alpha] - 8/18/2023

### Added

- **Added a max for crits,heals and normal hits so on some bosses you don't get a 1 million crits.**
- **Added a check to prevent CritMatic from attempting to track spells that are not in your spell-book.**


    ]]

    -- Fetch the custom font from SharedMedia
    local customFont = SharedMedia:Fetch("font", "Coming Soon")  -- Replace "YourCustomFont" with your font's name

    local logLabel = AceGUI:Create("Label")
    logLabel:SetText(changelog)
    logLabel:SetFullWidth(true)
    logLabel:SetFont(customFont, 12, "OUTLINE")-- Set the font here
    logLabel:SetColor(0.22, 0.25, 0.25)

    scroll:AddChild(logLabel)
  end

  -- Show the change log (call this function when you want to display the log)
  ShowChangeLog()


  local fonts = SharedMedia:List("font")
  print("Available Fonts:")
  for i, name in ipairs(fonts) do
    print(name)
  end




  if IsAddOnLoaded("ElvUI") then
    self:ScheduleTimer("TimerCritMaticLoaded", 8)
  else
    self:ScheduleTimer("TimerCritMaticLoaded", 8)
  end
end
-- Called when the addon is enabled
function Critmatic:OnEnable()

end

-- Called when the addon is disabled
function Critmatic:OnDisable()

end

function Critmatic:CritMaticReset()
  CritMaticData = {}
  Critmatic:Print("|cffff0000Data Reset!|r")
end
function Critmatic:CritMaticDBReset()

  Critmatic:Print("|cffff0000Database Reset!|r")
end