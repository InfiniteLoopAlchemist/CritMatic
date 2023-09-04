local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function OpenConfigWindow(container)
    local AceGUI = LibStub("AceGUI-3.0")

    -- Create the tab group
    local tabGroup = AceGUI:Create("TabGroup")
    tabGroup:SetLayout("Flow")
    tabGroup:SetTabs({
        {text="Tab 1", value="tab1"},
        {text="Tab 2", value="tab2"},
        {text="Tab 3", value="tab3"}
    })

    local function SelectGroup(container, event, group)
        container:ReleaseChildren()

        if group == "tab1" then
            local button1 = AceGUI:Create("Button")
            button1:SetText("Button in Tab 1")
            container:AddChild(button1)
        elseif group == "tab2" then
            local button2 = AceGUI:Create("Button")
            button2:SetText("Button in Tab 2")
            container:AddChild(button2)
        elseif group == "tab3" then
            local button3 = AceGUI:Create("Button")
            button3:SetText("Button in Tab 3")
            container:AddChild(button3)
        end
    end

    tabGroup:SetCallback("OnGroupSelected", SelectGroup)
    tabGroup:SelectTab("tab1")

    container:AddChild(tabGroup)
end

-- Define the options table
local options = {
    name = "CritMatic",
    type = "group",
    childGroups = "tab",
    args = {
        configTab = {
            type = "group",
            name = "Configuration",
            args = {
                customControl = {
                    type = "group",
                    name = "Custom Control",
                    args = {},
                    guiInline = true,
                    inline = true,
                    order = 1,
                },
            },
        },
    },
}

-- Register the options table
AceConfig:RegisterOptionsTable("CritMatic", options)

-- Add to Blizzard's Interface Options
local blizzPanel = AceConfigDialog:AddToBlizOptions("CritMatic", "CritMatic")

-- Hook into the Blizzard options panel to embed your custom control
hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)
    if frame == blizzPanel then
        OpenConfigWindow(frame)
    end
end)
