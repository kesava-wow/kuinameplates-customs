local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local kui = LibStub('Kui-1.0')
local mod = addon:NewPlugin('TwoHealthValues',101)

function ReplaceLevelText(f)
    if f.state.health_cur == f.state.health_max then
        f.LevelText:SetText()
    else
        f.LevelText:SetText(kui.num(f.state.health_cur))
    end

    f:leveltohealth_UpdateHealthText()
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
    self:RegisterUnitEvent('UNIT_LEVEL')
end
