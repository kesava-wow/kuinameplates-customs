local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local kui = LibStub('Kui-1.0')

local mod = addon:NewPlugin('TwoHealthValues',101,3)
if not mod then return end

-- replace level text instead of modifing health text?
local REPLACE_LEVEL_TEXT = false
-- show percent symbol? (only when REPLACE_LEVEL_TEXT is false)
local PERCENT_SYMBOL = false

-- #############################################################################
local function ReplaceLevelText(f)
    f:leveltohealth_UpdateHealthText()

    if REPLACE_LEVEL_TEXT then
        if f.state.health_cur == f.state.health_max then
            f.LevelText:SetText()
        else
            f.LevelText:SetText(kui.num(f.state.health_cur))
        end
    else
        local p = f.state.health_per
        p = p < 1 and string.format('%.1f',p) or ceil(p)

        -- override with current + percent
        f.HealthText:SetText(kui.num(f.state.health_cur)..' | '..p..(PERCENT_SYMBOL and '%' or ''))
    end
end

function mod:Create(f)
    f.leveltohealth_UpdateHealthText = f.UpdateHealthText
    f.UpdateHealthText = ReplaceLevelText
end
function mod:UNIT_LEVEL(event,f)
    f:UpdateHealthText()
end

function mod:Initialise()
    self:RegisterMessage('Create')

    if REPLACE_LEVEL_TEXT then
        self:RegisterUnitEvent('UNIT_LEVEL')
    end
end
