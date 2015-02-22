--[[
-- Kui_Nameplates
-- By Kesava at curse.com
-- All rights reserved
--
-- changes colour of health bars based on health percentage
-- conflicts with tank mode
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')

local LOW_HEALTH_COLOR = { 1, .3, .5 }

local function OnHealthValueChanged(oldHealth,current)
    local frame = oldHealth:GetParent():GetParent().kui
    local percent = frame.health.percent

    if percent <= 20 then
        frame:SetHealthColour(true, unpack(LOW_HEALTH_COLOR))
    else
        frame:SetHealthColour(false)
    end
end

---------------------------------------------------------------------- Create --
function mod:PostCreate(msg, frame)
    frame.oldHealth:HookScript('OnValueChanged',OnHealthValueChanged)
end

-------------------------------------------------------------------- Register --
mod:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')
