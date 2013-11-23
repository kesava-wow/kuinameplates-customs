--[[
-- Kui_Nameplates
-- By Kesava at curse.com
   Left-aligned text layout for those who prefer it.
   Does not currently take custom text offset into account.
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')
------------------------------------------------------------------------ Show --
function mod:PostShow(msg, frame)
    if not frame.trivial then
        frame.name:ClearAllPoints()
        frame.name:SetPoint('BOTTOMLEFT', frame.health, 'TOPLEFT', 2.5, -2)
        frame.name:SetJustifyH('LEFT')

        frame.health.p:ClearAllPoints()
        frame.health.p:SetPoint('BOTTOMRIGHT', frame.health, 'TOPRIGHT', -2.5, -2)
        frame.health.p:SetJustifyH('RIGHT')

        frame.name:SetPoint('RIGHT', frame.health.p, 'LEFT')

        if frame.level.enabled then
            frame.level:ClearAllPoints()
            frame.level:SetPoint('TOPLEFT', frame.health, 'BOTTOMLEFT', 2.5, 5)
            frame.level:SetJustifyH('LEFT')
        end

        if frame.health.mo then
            frame.health.mo:ClearAllPoints()
            frame.health.mo:SetPoint('TOPRIGHT', frame.health, 'BOTTOMRIGHT', -2.5, 5)
            frame.health.mo:SetJustifyH('RIGHT')
        end

        if frame.castbar.name then
            frame.castbar.name:ClearAllPoints()
            frame.castbar.name:SetPoint('TOPLEFT', frame.castbar.bar, 'BOTTOMLEFT', 2.5, -3)
            frame.castbar.name:SetPoint('TOPRIGHT', frame.castbar.bar, 'BOTTOMRIGHT')
            frame.castbar.name:SetJustifyH('LEFT')
        end

        if frame.castbar.curr then
            frame.castbar.curr:ClearAllPoints()
            frame.castbar.curr:SetPoint('TOPRIGHT', frame.castbar.bar, 'BOTTOMRIGHT', -2.5, -3)
            frame.castbar.curr:SetJustifyH('RIGHT')

            frame.castbar.name:SetPoint('RIGHT', frame.castbar.curr, 'LEFT')
        end
    end
end
-------------------------------------------------------------------- Register --
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
