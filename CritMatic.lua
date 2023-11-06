-- This line should be at the top of your main Lua file, outside any function.
Critmatic = LibStub("AceAddon-3.0"):NewAddon("|cffffd700CritMatic|r", "AceConsole-3.0", "AceTimer-3.0" ,"AceEvent-3.0","AceComm-3.0")

local MAX_HIT = 40000

local function GetGCD()
  local _, gcdDuration = GetSpellCooldown(78) -- 78 is the spell ID for Warrior's Heroic Strike
  if gcdDuration == 0 then
    return 1.5 -- Default GCD duration if not available (you may adjust this value if needed)
  else
    return gcdDuration
  end
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
  function Critmatic:OnCommReceived(prefix , message, distribution, sender)

    if message and version then

      local isNewerVersion = message > version

      if isNewerVersion and not Critmatic.hasDisplayedUpdateMessage then
        Critmatic:Print("|cffff0000An updated version of CritMatic has been released. We strongly recommend upgrading to the latest version for enhanced features and stability.|r |cff918d86The update is available on CurseForge, Wago .io, and WoW Interface.|r")
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

    elseif
    self:SendCommMessage("Critmatic", version, IsPartyLFG() and "INSTANCE_CHAT" or "PARTY") then
    elseif IsInRaid() then
      self:SendCommMessage("Critmatic", version, "RAID")
    end
  end

  -- Event handler for GROUP_ROSTER_UPDATE
  function Critmatic:GROUP_ROSTER_UPDATE()
    self:BroadcastVersion()
  end
  -- Register console commands
  Critmatic:RegisterChatCommand("cmreset", "CritMaticReset")
  -- Register the slash commands
  Critmatic:RegisterChatCommand("critmatic", "OpenOptions")
  Critmatic:RegisterChatCommand("cm", "OpenOptions")
  Critmatic:RegisterChatCommand("cmlog", "OpenChangeLog")
  Critmatic:RegisterChatCommand("cmcritlog", "OpenCritLog")
  Critmatic:RegisterChatCommand("cmdbreset", "CritMaticDBReset")

  self:RegisterComm("Critmatic")
  -- Trigger version broadcast when group roster updates
  Critmatic:RegisterEvent("GROUP_ROSTER_UPDATE", "BroadcastVersion")
  -- Function to handle incoming messages

  hooksecurefunc(GameTooltip, "SetAction", AddHighestHitsToTooltip)
  local GameTooltip = IsAddOnLoaded("ElvUI") and _G.ElvUISpellBookTooltip or _G.GameTooltip
  hooksecurefunc(GameTooltip, "SetSpellBookItem", AddHighestHitsToTooltip)

  function Critmatic:CritMaticLoaded()
    self:Print("|cffd4d4d4 v|r|cfff2f2f2 " .. version .. "|r|cffd4d4d4 Loaded! - Use|cffffd700  /cm|r|cffd4d4d4 for  options - |cffffd700/cmcritlog |r|cffd4d4d4 for crit log. |r - |cffffd700/cmlog|r|cffd4d4d4 for change log. |r")
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
  -- Code to run when the addon is enabled.
end

function Critmatic:OnDisable()
  -- Code to run when the addon is disabled.
end
function Critmatic:OpenOptions()
  LibStub("AceConfigDialog-3.0"):Open("CritMaticOptions")
end
function Critmatic:OpenCritLog()
  Critmatic.showCritLog()
end
function Critmatic:OpenChangeLog()
  Critmatic.showChangeLog()
end

function Critmatic:CritMaticReset()
  CritMaticData = {}
  Critmatic:Print("|cffff0000Data Reset!|r")
end
function Critmatic:CritMaticDBReset()

  Critmatic:Print("|cffff0000Database Reset!|r")
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

    if baseSpellName == "Auto Attack" and not Critmatic.db.profile.generalSettings.autoAttacksEnabled then
      return
    end
    local LSM = LibStub("LibSharedMedia-3.0")
    local soundCrit = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.damageCrit)
    local soundNormal = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.damageNormal)
    local soundHealCrit = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.healCrit)
    local soundHealNormal = LSM:Fetch("sound", Critmatic.db.profile.soundSettings.healNormal)

    if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") and destGUID ~= UnitGUID("player") and (eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" or eventType == "SPELL_PERIODIC_DAMAGE") and amount > 0 then
      if baseSpellName then
        CritMaticData[baseSpellName] = CritMaticData[baseSpellName] or {
          highestCrit = 0,
          highestNormal = 0,
          highestHealCrit = 0,
          highestHeal = 0,

        }
        if amount <= MAX_HIT then


          ProcessNewHighs(eventType, baseSpellName, amount, critical)
        end
        if IsSpellInSpellbook(baseSpellName) or baseSpellName == "Auto Attack" then
          --print(CombatLogGetCurrentEventInfo())

          if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
            if critical then

              -- When the event is a heal and it's a critical heal.
              if amount > CritMaticData[baseSpellName].highestHealCrit and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestHealCrit = amount
                if not Critmatic.db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundHealCrit)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")

                if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                  Critmatic.ShowNewHealCritMessage(baseSpellName, amount)
                end

                if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                  print("|cffffd700New highest crit heal for " .. baseSpellName .. ": |r" .. CritMaticData[baseSpellName].highestHealCrit)
                end

              end
            elseif not critical then
              if amount > CritMaticData[baseSpellName].highestHeal and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestHeal = amount

                if not Critmatic.db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundHealNormal)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heaven.ogg", "SFX")

                if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                  Critmatic.ShowNewHealMessage(baseSpellName, amount)
                end

                if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
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
                if not Critmatic.db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundCrit)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")
                if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                  Critmatic.ShowNewCritMessage(baseSpellName, amount)
                end

                if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                  print("|cffffd700New highest crit hit for " .. baseSpellName .. ": |r" ..
                          CritMaticData[baseSpellName].highestCrit)
                end

              end
            elseif not critical then
              -- When the event is damage but it's not a critical hit.
              if amount > CritMaticData[baseSpellName].highestNormal and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestNormal = amount
                if not Critmatic.db.profile.soundSettings.muteAllSounds then
                  PlaySoundFile(soundNormal)
                end

                --PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heroism_Cast.ogg", "SFX")
                if Critmatic.db.profile.generalSettings.alertNotificationsEnabled then
                  Critmatic.ShowNewNormalMessage(baseSpellName, amount)
                end

                if Critmatic.db.profile.generalSettings.chatNotificationsEnabled then
                  print("New highest normal hit for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestNormal)
                end

              end
            end
          end



        end
      end
    end
  elseif event == "PLAYER_REGEN_ENABLED" then
    -- First check if we are in an instance and what type it is
    local inInstance, instanceType = IsInInstance()
    if IsInGuild() and Critmatic.db.profile.social.canSendCritsToGuild then

      if highestCritDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " .. highestCritDuringCombat, "GUILD")

      end

      -- For highest critical heal
      if highestCritHealDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " .. highestCritHealDuringCombat, "GUILD")
      end
    end
    if inInstance and (instanceType == "pvp") and Critmatic.db.profile.social.canSendCritsToBattleGrounds then
      if highestCritDuringCombat > 0 then

        SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " ..
                highestCritDuringCombat, "INSTANCE_CHAT")
      end
      -- For highest critical heal
      if highestCritHealDuringCombat > 0 then
        SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " ..
                highestCritHealDuringCombat, "INSTANCE_CHAT")
      end
    else

      if inInstance and (instanceType == "pvp" or instanceType == "arena") then
        return
      elseif IsInGroup() and Critmatic.db.profile.social.canSendCritsToParty then
        -- For highest critical hit
        if highestCritDuringCombat > 0 then

          SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " ..
                  highestCritDuringCombat, IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
        end
        -- For highest critical heal
        if highestCritHealDuringCombat > 0 then
          SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " ..
                  highestCritHealDuringCombat, IsPartyLFG() and "INSTANCE_CHAT" or "PARTY")
        end
      elseif IsInRaid() and Critmatic.db.profile.social.canSendCritsToRaid then
        if highestCritDuringCombat > 0 then
          SendChatMessage("{star}CritMatic: New highest crit hit for " .. highestCritSpellName .. ": " ..
                  highestCritDuringCombat, "RAID")
        end
        -- For highest critical heal
        if highestCritHealDuringCombat > 0 then
          SendChatMessage("{star}CritMatic: New highest crit heal for " .. highestCritHealSpellName .. ": " ..
                  highestCritHealDuringCombat, "RAID")
        end

      end
      -- For highest critical hit


    end


    highestCritDuringCombat = 0
    highestCritHealDuringCombat = 0
    highestCritSpellName  = ""
    highestCritHealSpellName = ""
  end
end)
-- Function to process new high values during combat
function ProcessNewHighs(eventType, baseSpellName, amount, critical)
  -- Check for healing critical events
  if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
    if critical then
      if CritMaticData[baseSpellName].highestHealCrit == 0 then
        CritMaticData[baseSpellName].highestHealCrit = amount
      else
        if amount > CritMaticData[baseSpellName].highestHealCrit then
        highestCritHealDuringCombat = amount
        highestCritHealSpellName = baseSpellName
        end
      end
    end

    -- Check for damage critical events
  elseif eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
    if critical then

      if CritMaticData[baseSpellName].highestCrit == 0 then
        CritMaticData[baseSpellName].highestCrit = amount
      else
        if amount > CritMaticData[baseSpellName].highestCrit then
          print("New highest crit hit recorded for " .. baseSpellName .. ": " .. amount)
        highestCritDuringCombat = amount
        highestCritSpellName = baseSpellName

        end

      end
  end
end
end
