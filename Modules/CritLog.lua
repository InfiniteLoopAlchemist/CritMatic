local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")
local AceConsole = LibStub("AceConsole-3.0")

function toggleCritMaticCritLog()
    local db = Critmatic.db.profile
    local sizePos = Critmatic.db.profile.critLogWidgetPos
    if not Critmatic.crit_log_frame or not Critmatic.crit_log_frame.frame then

        --[[
            Crit Log Widget
            Note: This widget implementation incorporates certain elements and functionalities
            that are based on the DeathLog Widget.]]
        local Type, Version = "CritMatic_CritLog", 30
        local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
        if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then
            return
        end

        local main_font = ''

        local pairs, assert, type = pairs, assert, type
        local wipe = table.wipe

        local PlaySound = PlaySound
        local CreateFrame, UIParent = CreateFrame, UIParent
        local column_types = {
            "Name",
            "Guild",
            "Lvl",
            "F's",
            "Race",
            "Class",
            "Source",
            "ColoredName",
            "Zone",
            "ClassLogo1",
            "ClassLogo2",
            "RaceLogoSquare",
            "LastWords",
        }

        local function Button_OnClick(frame)
            PlaySound(799) -- SOUNDKIT.GS_TITLE_OPTION_EXIT
            frame.obj:Hide()
        end

        local function Frame_OnShow(frame)
            frame.obj:Fire("OnShow")
        end

        local function Frame_OnClose(frame)
            frame.obj:Fire("OnClose")
        end

        local function Frame_OnMouseDown(frame)
            AceGUI:ClearFocus()
        end

        local function Title_OnMouseDown(frame)
            AceGUI:ClearFocus()
        end

        local function MoverSizer_OnMouseUp(mover)
            local frame = mover:GetParent()
            frame:StopMovingOrSizing()
            local self = frame.obj
            local status = self.status or self.localstatus
            status.width = frame:GetWidth()
            status.height = frame:GetHeight()
            status.top = frame:GetTop()
            status.left = frame:GetLeft()
        end

        local function SizerSE_OnMouseDown(frame)
            frame:GetParent():StartSizing("BOTTOMRIGHT")
            AceGUI:ClearFocus()
        end

        local function SizerS_OnMouseDown(frame)
            frame:GetParent():StartSizing("BOTTOM")
            AceGUI:ClearFocus()
        end

        local function SizerE_OnMouseDown(frame)
            frame:GetParent():StartSizing("RIGHT")
            AceGUI:ClearFocus()
        end

        local function StatusBar_OnEnter(frame)
            frame.obj:Fire("OnEnterStatusBar")
        end

        local function StatusBar_OnLeave(frame)
            frame.obj:Fire("OnLeaveStatusBar")
        end

        local methods = {
            ["OnAcquire"] = function(self)
                self.frame:SetParent(UIParent)
                self.frame:SetFrameStrata("FULLSCREEN_DIALOG")
                self.frame:SetFrameLevel(100) -- Lots of room to draw under it
                self:SetTitle()
                self:SetSubTitle()
                self:SetStatusText()
                self:ApplyStatus()
                self:Show()
                self:EnableResize(false)
            end,

            ["OnRelease"] = function(self)
                self.status = nil
                wipe(self.localstatus)
            end,

            ["OnWidthSet"] = function(self, width)
                local content = self.content
                local contentwidth = width - 34
                if contentwidth < 0 then
                    contentwidth = 0
                end
                content:SetWidth(contentwidth)
                content.width = contentwidth
                self.titlebg:SetWidth(contentwidth - 35)
            end,

            ["OnHeightSet"] = function(self, height)
                local content = self.content
                local contentheight = height
                if contentheight < 0 then
                    contentheight = 0
                end
                content:SetHeight(contentheight)
                content.height = contentheight
            end,

            ["SetTitle"] = function(self, title)
                self.titletext:SetText(title)

            end,

            ["SetSubTitle"] = function(self, subtitle_data)
                local column_offset = 17
                if subtitle_data == nil then
                    return
                end

                for _, v in ipairs(column_types) do
                    self.subtitletext_tbl[v]:SetText("")
                end
                for _, v in ipairs(subtitle_data) do
                    if v[1] == "ClassLogo1" or v[1] == "ClassLogo2" or v[1] == "RaceLogoSquare" then
                        self.subtitletext_tbl[v[1]]:SetText("")
                    else
                        self.subtitletext_tbl[v[1]]:SetText(v[1])
                    end
                    self.subtitletext_tbl[v[1]]:SetPoint("LEFT", self.frame, "TOPLEFT", column_offset, -26)
                    column_offset = column_offset + v[2]
                end
            end,
            ["SetSubTitleOffset"] = function(self, _x, _y, subtitle_data)
                local column_offset = 17
                for _, v in ipairs(subtitle_data) do
                    self.subtitletext_tbl[v[1]]:SetPoint("LEFT", self.frame, "TOPLEFT", column_offset + _x, -26 + _y)
                    column_offset = column_offset + v[2]
                end
            end,

            ["SetStatusText"] = function(self, text)
                self.statustext:SetText(text)
            end,

            ["Hide"] = function(self)
                self.frame:Hide()
            end,

            ["Minimize"] = function(self)
                self.frame:Hide()
                is_minimized = true
            end,

            ["IsMinimized"] = function(self)
                return is_minimized
            end,

            ["Maximize"] = function(self)
                self.frame:Show()
                is_minimized = false
            end,

            ["Show"] = function(self)
                self.frame:Show()
            end,

            ["EnableResize"] = function(self, state)
                local func = state and "Show" or "Hide"
                self.sizer_se[func](self.sizer_se)
                self.sizer_s[func](self.sizer_s)
                self.sizer_e[func](self.sizer_e)
            end,

            -- called to set an external table to store status in
            -- Function to set an external table to store status in
            ["SetStatusTable"] = function(self, status)
                assert(type(status) == "table")
                self.status = status
                self:ApplyStatus()
            end,

            -- Function to apply the status to the frame
            ["ApplyStatus"] = function(self)
                local sizePos = Critmatic.db.profile.critLogWidgetPos
                local frame = self.frame

                -- Set the width and height from sizePos or use default values
                self:SetWidth(sizePos.size_x or 700)
                self:SetHeight(sizePos.size_y or 500)

                frame:ClearAllPoints()

                -- If sizePos has position data, use it to set the frame's position
                if sizePos.pos_x and sizePos.pos_y then
                    frame:SetPoint("CENTER", UIParent, "CENTER", sizePos.pos_x, sizePos.pos_y)

                end
            end,
        }

        local FrameBackdrop = {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\CHATFRAME\\ChatFrameBorder",
            tile = false,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 8, right = 8, top = 8, bottom = 8 },
        }

        local PaneBackdrop = {
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Glues\\COMMON\\TextPanel-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 32,
            insets = { left = 3, right = 3, top = 5, bottom = 3 },
        }

        local function Constructor()
            local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
            frame:Hide()

            frame:EnableMouse(true)
            frame:SetMovable(true)
            frame:SetResizable(true)
            frame:SetFrameStrata("FULLSCREEN_DIALOG")
            frame:SetFrameLevel(100) -- Lots of room to draw under it
            frame:SetBackdrop(PaneBackdrop)
            frame:SetBackdropColor(0, 0, 0, 0.6)
            frame:SetBackdropBorderColor(1, 1, 1, 1)
            frame:SetSize(250, 150)

            if frame.SetResizeBounds then
                frame:SetResizeBounds(100, 50)
            else
                frame:SetMinResize(150, 100)
            end
            frame:SetToplevel(true)
            frame:SetScript("OnShow", Frame_OnShow)
            frame:SetScript("OnHide", Frame_OnClose)
            frame:SetScript("OnMouseDown", Frame_OnMouseDown)

            local closebutton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            closebutton:SetScript("OnClick", Button_OnClick)
            closebutton:SetPoint("BOTTOMRIGHT", -27, 17)
            closebutton:SetHeight(0)
            closebutton:SetWidth(100)
            closebutton:SetText(CLOSE)
            closebutton:Hide()

            local statusbg = CreateFrame("Button", nil, frame, "BackdropTemplate")
            statusbg:SetPoint("BOTTOMLEFT", 15, 15)
            statusbg:SetPoint("BOTTOMRIGHT", -132, 15)
            statusbg:SetHeight(0)
            statusbg:SetBackdrop(PaneBackdrop)
            statusbg:SetBackdropColor(0.1, 0.1, 0.1)
            statusbg:SetBackdropBorderColor(0.4, 0.4, 0.4)
            statusbg:SetScript("OnEnter", StatusBar_OnEnter)
            statusbg:SetScript("OnLeave", StatusBar_OnLeave)
            statusbg:Hide()

            local statustext = statusbg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            statustext:SetPoint("TOPLEFT", 7, -2)
            statustext:SetPoint("BOTTOMRIGHT", -7, 2)
            statustext:SetHeight(0)
            statustext:SetJustifyH("LEFT")
            statustext:SetText("")
            statustext:Hide()

            local titlebg = frame:CreateTexture(nil, "OVERLAY")
            titlebg:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-DetailHeaderLeft")
            titlebg:SetTexCoord(0, 1, 0, 1)
            titlebg:SetPoint("TOP", 0, 12)
            titlebg:SetWidth(100)
            titlebg:SetHeight(40)
            titlebg:Hide()

            local title = CreateFrame("Frame", nil, frame)
            title:EnableMouse(true)
            title:SetScript("OnMouseDown", Title_OnMouseDown)
            title:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
            title:SetAllPoints(titlebg)

            local titletext = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            titletext:SetFont(main_font, 13, "")
            titletext:SetPoint("LEFT", frame, "TOPLEFT", 32, -10)

            local subtitletext_tbl = {}
            for _, v in ipairs(column_types) do
                subtitletext_tbl[v] = title:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                subtitletext_tbl[v]:SetPoint("LEFT", frame, "TOPLEFT", 20, -26)
                subtitletext_tbl[v]:SetFont(main_font, 12, "")
                subtitletext_tbl[v]:SetTextColor(0.5, 0.5, 0.5)
                subtitletext_tbl[v]:SetWordWrap(false)
            end

            local titlebg_l = frame:CreateTexture(nil, "OVERLAY")
            titlebg_l:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
            titlebg_l:SetTexCoord(0.21, 0.31, 0, 0.63)
            titlebg_l:SetPoint("RIGHT", titlebg, "LEFT")
            titlebg_l:SetWidth(30)
            titlebg_l:SetHeight(40)
            titlebg_l:Hide()

            local titlebg_r = frame:CreateTexture(nil, "OVERLAY")
            titlebg_r:SetTexture(131080) -- Interface\\DialogFrame\\UI-DialogBox-Header
            titlebg_r:SetTexCoord(0.67, 0.77, 0, 0.63)
            titlebg_r:SetPoint("LEFT", titlebg, "RIGHT")
            titlebg_r:SetWidth(30)
            titlebg_r:SetHeight(40)
            titlebg_r:Hide()

            local sizer_se = CreateFrame("Frame", nil, frame)
            sizer_se:SetPoint("BOTTOMRIGHT")
            sizer_se:SetWidth(25)
            sizer_se:SetHeight(25)
            sizer_se:EnableMouse()
            sizer_se:SetScript("OnMouseDown", SizerSE_OnMouseDown)
            sizer_se:SetScript("OnMouseUp", MoverSizer_OnMouseUp)

            local line1 = sizer_se:CreateTexture(nil, "BACKGROUND")
            line1:SetWidth(14)
            line1:SetHeight(14)
            line1:SetPoint("BOTTOMRIGHT", -8, 8)
            line1:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
            local x = 0.1 * 14 / 17
            line1:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

            local line2 = sizer_se:CreateTexture(nil, "BACKGROUND")
            line2:SetWidth(8)
            line2:SetHeight(8)
            line2:SetPoint("BOTTOMRIGHT", -8, 8)
            line2:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
            x = 0.1 * 8 / 17
            line2:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

            local sizer_s = CreateFrame("Frame", nil, frame)
            sizer_s:SetPoint("BOTTOMRIGHT", -25, 0)
            sizer_s:SetPoint("BOTTOMLEFT")
            sizer_s:SetHeight(25)
            sizer_s:EnableMouse(true)
            sizer_s:SetScript("OnMouseDown", SizerS_OnMouseDown)
            sizer_s:SetScript("OnMouseUp", MoverSizer_OnMouseUp)

            local sizer_e = CreateFrame("Frame", nil, frame)
            sizer_e:SetPoint("BOTTOMRIGHT", 0, 25)
            sizer_e:SetPoint("TOPRIGHT")
            sizer_e:SetWidth(25)
            sizer_e:EnableMouse(true)
            sizer_e:SetScript("OnMouseDown", SizerE_OnMouseDown)
            sizer_e:SetScript("OnMouseUp", MoverSizer_OnMouseUp)

            --Container Support
            local content = CreateFrame("Frame", nil, frame)
            content:SetPoint("TOPLEFT", 3, -33)
            content:SetPoint("BOTTOMRIGHT", 15, 6)

            local scrollContainer = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
            scrollContainer:SetSize(250, 120)
            scrollContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -20)

            local scrollChild = CreateFrame("Frame", nil, scrollContainer)
            scrollContainer:SetScrollChild(scrollChild)
            scrollChild:SetSize(180, 200)  -- Initial height, adjust as needed

            -- Table to keep track of created frames
            local createdSpellFrames = {}

            function RedrawCritMaticWidget()
                local yOffset = 0
                local spellFrameHeight = 60

                -- Hide or delete all previously created frames
                for _, frame in ipairs(createdSpellFrames) do
                    frame:Hide()
                    frame:SetParent(nil)
                end
                wipe(createdSpellFrames)

                local spellsByName = {}

                for spellID, spellData in pairs(CritMaticData) do
                    local spellName = GetSpellInfo(spellID)

                    if spellName then
                        if not spellsByName[spellName] then
                            spellsByName[spellName] = {
                                ids = { spellID },
                                data = spellData,
                                latestTimestamp = spellData.timestamp -- Initialize with the first timestamp
                            }
                        else
                            local spellGroup = spellsByName[spellName]
                            local existingData = spellGroup.data
                            table.insert(spellGroup.ids, spellID)

                            -- Compare and update the timestamp
                            spellGroup.latestTimestamp = math.max(spellGroup.latestTimestamp or 0, spellData.timestamp or 0)

                            -- Initialize a flag to track if data is updated


                            -- Update old values before merging the data
                            if spellData.highestCrit and spellData.highestCrit > (existingData.highestCrit or 0) then
                                existingData.highestCritOld = existingData.highestCrit
                                existingData.highestCrit = spellData.highestCrit

                            end
                            if spellData.highestNormal and spellData.highestNormal > (existingData.highestNormal or 0) then
                                existingData.highestNormalOld = existingData.highestNormal
                                existingData.highestNormal = spellData.highestNormal

                            end
                            if spellData.highestHealCrit and spellData.highestHealCrit > (existingData.highestHealCrit or 0) then
                                existingData.highestHealCritOld = existingData.highestHealCrit
                                existingData.highestHealCrit = spellData.highestHealCrit

                            end
                            if spellData.highestHeal and spellData.highestHeal > (existingData.highestHeal or 0) then
                                existingData.highestHealOld = existingData.highestHeal
                                existingData.highestHeal = spellData.highestHeal

                            end


                        end
                    end
                end

                -- Convert the spell data by name to a sortable list
                local sortableData = {}
                for spellName, spellGroup in pairs(spellsByName) do
                    table.insert(sortableData, {
                        name = spellName,
                        data = spellGroup.data,
                        ids = spellGroup.ids,
                        timestamp = spellGroup.latestTimestamp -- Use the latest timestamp for sorting
                    })
                end

                -- Sort by the latest timestamp, most recent first
                table.sort(sortableData, function(a, b)
                    return (a.timestamp or 0) > (b.timestamp or 0)
                end)

                for _, entry in ipairs(sortableData) do
                    local spellName = entry.name
                    local spellData = entry.data
                    -- Check if the spell is ignored
                    if not Critmatic.ignoredSpells or not Critmatic.ignoredSpells[spellName:lower()] then


                        local spellIDs = entry.ids  -- Now you have access to all IDs for this spell name
                        local spellIDToUse = #spellIDs > 1 and spellIDs[2] or spellIDs[1]
                        local _, _, spellIconPath = GetSpellInfo(spellIDToUse)

                        if spellIconPath then
                            local spellFrame = CreateFrame("Frame", nil, scrollChild)
                            spellFrame:SetSize(198, spellFrameHeight)
                            spellFrame:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -yOffset)

                            local spellIcon = spellFrame:CreateTexture(nil, "ARTWORK")
                            spellIcon:SetSize(30, 30)
                            spellIcon:SetPoint("LEFT", spellFrame, "LEFT", 5, 0)
                            spellIcon:SetTexture(spellIconPath)

                            local spellText = spellFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                            spellText:SetJustifyH("LEFT")
                            spellText:SetPoint("LEFT", spellIcon, "RIGHT", 5, 0)
                            spellText:SetWidth(175)
                            local gold = "|cffffd700"
                            local gray = "|cffd4d4d4"
                            local spellInfoText = gold .. "%s|r\n"

                            -- Construct the spell info text based on available data
                            spellInfoText = string.format(spellInfoText, GetSpellInfo(spellIDs[1]))

                            if spellData.highestCrit and spellData.highestCrit > 0 then
                                spellInfoText = spellInfoText .. string.format(gray .. L["crit_log_crit"] .. ": %s (" .. L["crit_log_old"] .. ": %s)|r\n", spellData.highestCrit, spellData.highestCritOld or "0")
                            end

                            if spellData.highestNormal and spellData.highestNormal > 0 then
                                spellInfoText = spellInfoText .. string.format(gray .. L["crit_log_hit"] .. ": %s (" .. L["crit_log_old"] .. ": %s)|r\n", spellData.highestNormal, spellData.highestNormalOld or "0")
                            end

                            if spellData.highestHealCrit and spellData.highestHealCrit > 0 then
                                spellInfoText = spellInfoText .. string.format(gray .. L["crit_log_crit"] .. " " .. L["crit_log_heal"] .. ": %s (" .. L["crit_log_old"] .. ": %s)|r\n", spellData.highestHealCrit, spellData.highestHealCritOld or "0")
                            end

                            if spellData.highestHeal and spellData.highestHeal > 0 then
                                spellInfoText = spellInfoText .. string.format(gray .. L["crit_log_heal"] .. ": %s (" .. L["crit_log_old"] .. ": %s)|r", spellData.highestHeal, spellData.highestHealOld or "0")
                            end

                            spellText:SetText(spellInfoText)


                            -- Add the new frame to the table
                            table.insert(createdSpellFrames, spellFrame)

                            yOffset = yOffset + spellFrameHeight

                        end
                        if scrollContainer and scrollContainer.SetVerticalScroll then
                            scrollContainer:SetVerticalScroll(0)

                        end
                    end
                end
            end

            function RecordEvent(spellID)
                -- Check if the spellName is valid
                if not spellID then
                    return
                end

                -- Initialize spell data if not already present
                if not CritMaticData[spellID] then
                    CritMaticData[spellID] = {
                        timestamp = 0  -- Initialize the timestamp
                    }
                end

                -- Update the timestamp for the spell event
                CritMaticData[spellID].timestamp = time()
            end

            RedrawCritMaticWidget()
            -- A function to update CritMaticData and refresh the widget


            local widget = {
                localstatus = {},
                titletext = titletext,
                subtitletext_tbl = subtitletext_tbl,
                statustext = statustext,
                titlebg = titlebg,
                sizer_se = sizer_se,
                sizer_s = sizer_s,
                sizer_e = sizer_e,
                content = content,
                frame = frame,
                type = Type,
            }
            for method, func in pairs(methods) do
                widget[method] = func
            end
            closebutton.obj, statusbg.obj = widget, widget

            return AceGUI:RegisterAsContainer(widget)
        end

        AceGUI:RegisterWidgetType(Type, Constructor, Version)

        -- Frame creation and initial setup code
        Critmatic.crit_log_frame = AceGUI:Create("CritMatic_CritLog")

        Critmatic.crit_log_frame.frame:SetMovable(true)
        Critmatic.crit_log_frame.frame:EnableMouse(true)
        Critmatic.crit_log_frame:SetTitle("CritMatic")
        Critmatic.crit_log_frame:SetLayout("Fill")

        local function CritLogDefaultPosFrame()
            local frame = Critmatic.crit_log_frame
            local defaultPos = defaults.profile.critLogWidgetPos -- Adjust path if needed
            frame:Show()
            frame:ClearAllPoints()
            frame:SetPoint("RIGHT", UIParent, "RIGHT", defaultPos.pos_x, defaultPos.pos_y)
            Critmatic.db.profile.critLogWidgetPos.pos_x = defaultPos.pos_x
            Critmatic.db.profile.critLogWidgetPos.pos_y = defaultPos.pos_y

        end

        AceConsole:RegisterChatCommand("cmcritlogdefaultpos", CritLogDefaultPosFrame)

        local critmatic_icon_frame = CreateFrame("Frame", nil, Critmatic.crit_log_frame.frame)
        critmatic_icon_frame:SetSize(40, 40)
        critmatic_icon_frame:SetMovable(true)
        critmatic_icon_frame:EnableMouse(true)
        critmatic_icon_frame:SetPoint("TOPLEFT", Critmatic.crit_log_frame.frame, "TOPLEFT", -4, 10)

        local texture_round_black = critmatic_icon_frame:CreateTexture(nil, "OVERLAY")
        texture_round_black:SetPoint("CENTER", critmatic_icon_frame, "CENTER", -5, 4)
        texture_round_black:SetParent(UIParent)
        texture_round_black:SetDrawLayer("OVERLAY", 2)
        texture_round_black:SetHeight(40)
        texture_round_black:SetWidth(40)
        texture_round_black:SetTexture("Interface\\PVPFrame\\PVP-Separation-Circle-Cooldown-overlay")

        local texture_CritMatic_icon = critmatic_icon_frame:CreateTexture(nil, "OVERLAY")
        texture_CritMatic_icon:SetParent(UIParent)
        texture_CritMatic_icon:SetPoint("CENTER", critmatic_icon_frame, "CENTER", -4, 4)
        texture_CritMatic_icon:SetDrawLayer("OVERLAY", 3)
        texture_CritMatic_icon:SetHeight(25)
        texture_CritMatic_icon:SetWidth(25)
        texture_CritMatic_icon:SetTexture("Interface\\AddOns\\CritMatic\\Media\\Textures\\icon.blp")

        local texture_gold_ring = critmatic_icon_frame:CreateTexture(nil, "OVERLAY")
        texture_gold_ring:SetParent(UIParent)
        texture_gold_ring:SetPoint("CENTER", critmatic_icon_frame, "CENTER", 0, 0)
        texture_gold_ring:SetDrawLayer("OVERLAY", 4)
        texture_gold_ring:SetHeight(50)
        texture_gold_ring:SetWidth(50)
        texture_gold_ring:SetTexture("Interface\\COMMON\\BlueMenuRing")
        -- Load the saved state and apply it
        if Critmatic.db.profile.isCritLogFrameShown then

            Critmatic.crit_log_frame.frame:ClearAllPoints()
            Critmatic.crit_log_frame.frame:SetPoint(sizePos.anchor, UIParent, sizePos.anchor2, sizePos.pos_x, sizePos
                    .pos_y)
            Critmatic.crit_log_frame.frame:SetSize(300, 153)
            Critmatic.crit_log_frame.frame:Show()
            RedrawCritMaticWidget()
            --  critmatic_icon_frame:Show()
        else

            Critmatic.crit_log_frame.frame:Hide()
            texture_round_black:Hide()
            texture_CritMatic_icon:Hide()
            texture_gold_ring:Hide()
        end
        critmatic_icon_frame:HookScript("OnShow", function(self, button)
            texture_round_black:Show()
            texture_CritMatic_icon:Show()
            texture_gold_ring:Show()
        end)

        critmatic_icon_frame:HookScript("OnHide", function(self, button)
            texture_round_black:Hide()
            texture_CritMatic_icon:Hide()
            texture_gold_ring:Hide()
        end)

        -- Make sure the main frame is movable and draggable
        Critmatic.crit_log_frame.frame:SetMovable(true)
        Critmatic.crit_log_frame.frame:RegisterForDrag("LeftButton")

        -- When you start dragging the main frame, this will be called
        Critmatic.crit_log_frame.frame:SetScript("OnDragStart", function(self)
            if db.critLogWidgetPos.lock then
                return
            end

            self:StartMoving()
            critmatic_icon_frame:StartMoving()

        end)

        -- When you stop dragging the main frame, this will be called
        Critmatic.crit_log_frame.frame:SetScript("OnDragStop", function(self)
            if db.critLogWidgetPos.lock then
                return
            end
            self:StopMovingOrSizing()
            local anchor, _, anchor2, xOfs, yOfs = self:GetPoint()  -- Get the current anchor point and offsets

            sizePos.anchor = anchor
            sizePos.anchor2 = anchor2-- Save the anchor point
            sizePos.pos_x = xOfs
            sizePos.pos_y = yOfs
        end)

        hooksecurefunc(Critmatic.crit_log_frame.frame, "StopMovingOrSizing", function()
            sizePos.size_x = Critmatic.crit_log_frame.frame:GetWidth()
            sizePos.size_y = Critmatic.crit_log_frame.frame:GetHeight()
        end)
        Critmatic.crit_log_frame.frame:SetFrameStrata("BACKGROUND")
        Critmatic.crit_log_frame.frame:Lower()


    else
        -- Toggle visibility

        if Critmatic.crit_log_frame.frame:IsShown() then
            Critmatic.crit_log_frame.frame:Hide()
            db.isCritLogFrameShown = false


        else

            Critmatic.crit_log_frame.frame:Show()
            db.isCritLogFrameShown = true
            RedrawCritMaticWidget()
        end
        -- Save the visibility state

    end
end
