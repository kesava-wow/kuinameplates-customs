--[[
-- Kui_Nameplates
-- By Kesava at curse.com
--
-- Moves health text to the left and level text to the right and makes health
-- text a bit larger. Conflicts with leftie.
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')

-- change these to your desired settings
local HEALTH_X_OFFSET = 2.5
local HEALTH_Y_OFFSET = 0
local HEALTH_FONT_SIZE = 14

------------------------------------------------------------------------ Show --
function mod:PostShow(msg, f)
	-- Place code to be performed after a frame is shown here
    f.health.p:ClearAllPoints()
    f.health.p:SetPoint('TOPLEFT', f.health, 'BOTTOMLEFT',
        HEALTH_X_OFFSET, kn.db.profile.text.healthoffset + HEALTH_Y_OFFSET)

    if f.health.mo then
        f.health.mo:ClearAllPoints()
        f.health.mo:SetPoint('BOTTOMLEFT', f.health.p, 'BOTTOMRIGHT', 0, 0)
    end

    if f.level and f.level.enabled then
        f.level:ClearAllPoints()
        f.level:SetPoint('TOPRIGHT', f.health, 'BOTTOMRIGHT',
            -2.5, kn.db.profile.text.healthoffset + 4)
    end

    -- change health font size
    local health_font = { f.health.p:GetFont() }
    health_font[2] = HEALTH_FONT_SIZE

    f.health.p:SetFont(unpack(health_font))
end
-------------------------------------------------------------------- Register --
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
