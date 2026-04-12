Critmatic = Critmatic or {}
local L = LibStub("AceLocale-3.0"):GetLocale("CritMatic")

function Critmatic:IgnoredSpellsTab_Initialize()
    return {
        name = L["options_ignored_spells"],
        type = "group",
        order = 6,
        args = {
            description = {
                name = L["options_ignored_spells_desc"],
                type = "description",
                order = 1,
                fontSize = "medium",
            },
            ignoredSpellSelect = {
                name = L["options_ignored_spells_select"],
                type = "select",
                width = "double",
                order = 2,
                values = function()
                    local spells = {}
                    if Critmatic.ignoredSpells then
                        for spellName, _ in pairs(Critmatic.ignoredSpells) do
                            local displayName = spellName:gsub("(%a)([%w_']*)", function(a, b)
                                return a:upper() .. b
                            end)
                            spells[spellName] = displayName
                        end
                    end
                    if next(spells) == nil then
                        spells["none"] = "|cff888888No ignored spells|r"
                    end
                    return spells
                end,
                get = function()
                    return Critmatic.selectedIgnoredSpell
                end,
                set = function(_, val)
                    if val ~= "none" then
                        Critmatic.selectedIgnoredSpell = val
                    end
                end,
            },
            removeSelected = {
                name = L["options_ignored_spells_remove"],
                type = "execute",
                order = 3,
                width = "normal",
                func = function()
                    if Critmatic.selectedIgnoredSpell and Critmatic.ignoredSpells then
                        Critmatic.ignoredSpells[Critmatic.selectedIgnoredSpell] = nil
                        Critmatic.selectedIgnoredSpell = nil
                        if RedrawCritMaticWidget then
                            RedrawCritMaticWidget()
                        end
                    end
                end,
                disabled = function()
                    return not Critmatic.selectedIgnoredSpell
                end,
            },
            clearAll = {
                name = L["options_ignored_spells_clear_all"],
                type = "execute",
                order = 4,
                width = "normal",
                confirm = true,
                confirmText = L["options_ignored_spells_clear_all_confirm"],
                func = function()
                    if Critmatic.ignoredSpells then
                        wipe(Critmatic.ignoredSpells)
                        Critmatic.selectedIgnoredSpell = nil
                        if RedrawCritMaticWidget then
                            RedrawCritMaticWidget()
                        end
                    end
                end,
            },
        },
    }
end
