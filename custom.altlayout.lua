--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
--
-- test version of alternate text layout
-- doesn't truncate long names, may eventually be the default
-- (will be implemented as an option soon, too)
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')
function mod:PostShow(msg, frame)
    if not frame.trivial then
        -- move name to center
        frame.name:ClearAllPoints()
        frame.name:SetPoint('BOTTOM', frame.health, 'TOP',
                            -2, -kn.db.profile.text.healthoffset)

        if frame.level.enabled then
            -- move level to bottom left
            if frame.boss:IsVisible() then
                frame.level:SetText('boss')
            end

            frame.level:ClearAllPoints()
            frame.level:SetPoint('TOPLEFT', frame.health, 'BOTTOMLEFT',
                                2.5, kn.db.profile.text.healthoffset + 4)

            frame.level = frame:CreateFontString(frame.level, { reset = true,
                font = kn.font, size = 'small', alpha = 1, outline = 'OUTLINE' })
        end

        -- move large health value to bottom right
        frame.health.p:ClearAllPoints()
        frame.health.p:SetPoint('TOPRIGHT', frame.health, 'BOTTOMRIGHT',
                                -2.5, kn.db.profile.text.healthoffset + 4)

        frame.health.p = frame:CreateFontString(frame.health.p, { reset = true,
            font = kn.font, size = 'small', alpha = 1, outline = 'OUTLINE' })

        if frame.health.mo then
            -- move alt health to left of large health
            frame.health.mo:ClearAllPoints()
            frame.health.mo:SetPoint('TOPRIGHT', frame.health.p, 'TOPLEFT', 0, 2)
        end
    end
end
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
