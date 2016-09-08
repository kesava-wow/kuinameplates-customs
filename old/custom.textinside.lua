local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')
function mod:PostShow(msg, frame)
    frame.level:ClearAllPoints()
    frame.name:ClearAllPoints()
    frame.health.p:ClearAllPoints()

    frame.level:SetJustifyV('MIDDLE')
    frame.name:SetJustifyH('LEFT')

    frame.name:SetJustifyV('MIDDLE')
    frame.name:SetJustifyH('LEFT')

    frame.health.p:SetJustifyV('MIDDLE')
    frame.health.p:SetJustifyH('RIGHT')

    frame.health.p:SetPoint('RIGHT', -3.5, -1.5)

    if frame.level:IsShown() then
        frame.level:SetPoint('LEFT', 3.5, -1.5)
        frame.name:SetPoint('LEFT', frame.level, 'RIGHT')
    else
        frame.name:SetPoint('LEFT', 3.5, -1.5)
    end

    frame.name:SetPoint('RIGHT', frame.health.p, 'LEFT')
end
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
