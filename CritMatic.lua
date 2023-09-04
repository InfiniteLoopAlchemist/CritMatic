-- Define a table to hold the highest hits data.
CritMaticData = CritMaticData or {}
--CTODO: add party/raid chat messages for highest hits with the option to turn off.

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
  f:SetSize(750, 30)
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
  local fontPath = "Interface\\AddOns\\CritMatic\\Media\\fonts\\8bit.ttf"
  f.text:SetFont(fontPath, 20, "THICKOUTLINE")
  f.text:SetShadowOffset(3, -3)

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

      if CritMaticData[baseSpellName].highestHeal > 0 or CritMaticData[baseSpellName].highestHealCrit > 0 then

        if not critMaticHealExists then
          self:AddDoubleLine(CritMaticHealLeft, CritMaticHealRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0)
          _G["GameTooltipTextLeft" .. self:NumLines()]:SetTextColor(1, 1, 1) -- left side color (white)
          _G["GameTooltipTextRight" .. self:NumLines()]:SetTextColor(1, 0.82, 0) -- right side color (gold)
        end

        if not normalMaticHealExists then
          self:AddDoubleLine(normalMaticHealLeft, normalMaticHealRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0)
          _G["GameTooltipTextLeft" .. self:NumLines()]:SetTextColor(1, 1, 1) -- left side color (white)
          _G["GameTooltipTextRight" .. self:NumLines()]:SetTextColor(1, 0.82, 0) -- right side color (gold)
        end
      end
      -- This is a damaging spell
      if CritMaticData[baseSpellName].highestNormal > 0 or CritMaticData[baseSpellName].highestCrit > 0 then
        if not critMaticExists then
          self:AddDoubleLine(CritMaticLeft, CritMaticRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0)
          _G["GameTooltipTextLeft" .. self:NumLines()]:SetTextColor(1, 1, 1) -- left side color (white)
          _G["GameTooltipTextRight" .. self:NumLines()]:SetTextColor(1, 0.82, 0) -- right side color (gold)
        end
        if not normalMaticExists then
          self:AddDoubleLine(normalMaticLeft, normalMaticRight, 0.9, 0.9, 0.9, 0.9, 0.82, 0)
          _G["GameTooltipTextLeft" .. self:NumLines()]:SetTextColor(1, 1, 1) -- left side color (white)
          _G["GameTooltipTextRight" .. self:NumLines()]:SetTextColor(1, 0.82, 0) -- right side color (gold)
        end
      end

      self:Show()
    end
  end
end

-- Register an event that fires when the player hits an enemy.
local f = CreateFrame("FRAME")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

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

    if baseSpellName == "Auto Attack" then
      return
    end

    if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") and destGUID ~= UnitGUID("player") and (eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" or eventType == "SPELL_PERIODIC_DAMAGE") and amount > 0 then
      if baseSpellName then
        CritMaticData[baseSpellName] = CritMaticData[baseSpellName] or {
          highestCrit = 0,
          highestNormal = 0,
          highestHealCrit = 0,
          highestHeal = 0,

        }
        if IsSpellInSpellbook(baseSpellName) then
          --print(CombatLogGetCurrentEventInfo())

          if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
            if critical then

              -- When the event is a heal and it's a critical heal.
              if amount > CritMaticData[baseSpellName].highestHealCrit and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestHealCrit = amount
                PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")
                CritMatic.ShowNewHealCritMessage(baseSpellName, amount)
                print("New highest crit heal for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestHealCrit)
              end
            elseif not critical then
              if amount > CritMaticData[baseSpellName].highestHeal and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestHeal = amount
                PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heaven.ogg", "SFX")
                CritMatic.ShowNewHealMessage(baseSpellName, amount)
                print("New highest normal heal for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestHeal)
              end
            end
          elseif eventType == "SPELL_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
            if critical then
              -- When the event is damage and it's a critical hit.
              if amount > CritMaticData[baseSpellName].highestCrit and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestCrit = amount
                --PlaySound(888, "SFX")
                PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\LevelUp.ogg", "SFX")
                CritMatic.ShowNewCritMessage(baseSpellName, amount)
                print("New highest crit hit for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestCrit)
              end
            elseif not critical then
              -- When the event is damage but it's not a critical hit.
              if amount > CritMaticData[baseSpellName].highestNormal and amount <= MAX_HIT then
                CritMaticData[baseSpellName].highestNormal = amount
                PlaySoundFile("Interface\\AddOns\\CritMatic\\Media\\Sounds\\Heroism_Cast.ogg", "SFX")
                CritMatic.ShowNewNormalMessage(baseSpellName, amount)
                print("New highest normal hit for " .. baseSpellName .. ": " .. CritMaticData[baseSpellName].highestNormal)
              end
            end
          end
        end
      end
    end
  end
end)
Critmatic = LibStub("AceAddon-3.0"):NewAddon("|cffffd700CritMatic|r", "AceConsole-3.0","AceTimer-3.0")

local version = GetAddOnMetadata("CritMatic", "Version")

local function CritMaticLoaded()
  Critmatic:Print("|cff918d86 v|r|cffd3cfc7 "..version.."|r|cff918d86 Loaded!|r")
end

function Critmatic:TimerCritMaticLoaded()
  CritMaticLoaded()
end
-- Called when the addon is loaded
function Critmatic:OnInitialize()
  -- Register console commands
  Critmatic:RegisterChatCommand("cmreset", "CritMaticReset")
  CritMaticData = _G["CritMaticData"]

  hooksecurefunc(GameTooltip, "SetAction", AddHighestHitsToTooltip)
  local GameTooltip = IsAddOnLoaded("ElvUI") and _G.ElvUISpellBookTooltip or _G.GameTooltip
  hooksecurefunc(GameTooltip, "SetSpellBookItem", AddHighestHitsToTooltip)
  local f = CritMatic.CreateNewMessageFrame()

  if IsAddOnLoaded("ElvUI") then
    self:ScheduleTimer("TimerCritMaticLoaded", 5)
  else
    self:ScheduleTimer("TimerCritMaticLoaded", 5)
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
