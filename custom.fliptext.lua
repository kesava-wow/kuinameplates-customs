--[[
-- Kui_Nameplates
-- By Kesava at curse.com
--
-- Moves health text to the left and level text to the right.
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')

------------------------------------------------------------------------ Show --
function mod:PostShow(msg, f)
	-- Place code to be performed after a frame is shown here
    f.health.p:ClearAllPoints()
    f.health.p:SetPoint('TOPLEFT', f.health, 'BOTTOMLEFT',
        2.5, kn.db.profile.text.healthoffset + 4)

    if f.health.mo then
        f.health.mo:ClearAllPoints()
        f.health.mo:SetPoint('BOTTOMLEFT', f.health.p, 'BOTTOMRIGHT', 0, 0)
    end

    if f.level and f.level.enabled then
        f.level:ClearAllPoints()
        f.level:SetPoint('TOPRIGHT', f.health, 'BOTTOMRIGHT',
            -2.5, kn.db.profile.text.healthoffset + 4)
    end

end
-------------------------------------------------------------------- Register --
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
