local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")


Critmatic.showCritLog = function()
    local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    frame:SetSize(300, 200)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    local backgroundTexture = LSM:Fetch("background", Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.backgroundTexture)
    local borderTexture = LSM:Fetch("border", Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderTexture)
    local borderSize = Critmatic.db.profile.changeLogPopUp.borderAndBackgroundSettings.borderSize

    frame:SetBackdrop({
        bgFile = backgroundTexture,
        edgeFile = borderTexture,
        edgeSize = borderSize,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    frame:SetBackdropColor(0, 0, 0, 0.5)



    local widget = {
        frame = frame,
        type = "CritMatic_miniLog"
    }

    function widget:OnAcquire()
        self.frame:Show()
    end


    function widget:OnRelease()
        self.frame:Hide()
    end

    return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType("CritMatic_miniLog", Critmatic.showCritLog, 1)
local myLogWidget = AceGUI:Create("CritMatic_miniLog")

myLogWidget.frame:SetPoint("CENTER", UIParent, "CENTER")
myLogWidget.frame:Show()