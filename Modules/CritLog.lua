local AceGUI = LibStub("AceGUI-3.0")
Critmatic = Critmatic or {}

Critmatic.showCritLog = function()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(300, 200) -- Set the default size
    frame:SetMovable(true) -- Make the frame movable
    frame:EnableMouse(true) -- Enable mouse for the frame
    frame:RegisterForDrag("LeftButton") -- Register left mouse button for drag
    frame:SetScript("OnDragStart", frame.StartMoving) -- Start moving on drag start
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing() -- Stop moving on drag stop
        -- Save the position here if needed
    end)
    -- Create a background texture
    local background = frame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(frame)
    background:SetColorTexture(0, 0, 0, 0.5) -- Set the color and alpha of the background

    -- Create a border
    local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    border:SetAllPoints(frame)
    border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", -- Path to border texture
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    local widget = {
        frame = frame,
        type = "CritMatic_miniLog"
    }

    -- OnAcquire is called when the widget is requested for use
    function widget:OnAcquire()
        self.frame:Show()
    end

    -- OnRelease is called when the widget is no longer needed
    function widget:OnRelease()
        self.frame:Hide()
    end

    -- Other widget methods would go here

    return AceGUI:RegisterAsWidget(widget)
end

-- Register the widget with AceGUI
AceGUI:RegisterWidgetType("CritMatic_miniLog", Critmatic.showCritLog, 1)
local myLogWidget = AceGUI:Create("CritMatic_miniLog")
-- Now 'myLogWidget' contains your custom widget

-- You can then manipulate 'myLogWidget' as needed, for example:
myLogWidget.frame:SetPoint("CENTER", UIParent, "CENTER") -- This centers the widget on the screen
myLogWidget.frame:Show() -- This makes sure the widget is visible, though it should be already from 'OnAcquire'