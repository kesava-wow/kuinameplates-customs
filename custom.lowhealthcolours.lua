--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
--
-- changes colour of health bars based on health percentage
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')

local LOW_HEALTH_COLOR = { 1, .3, .5 }
local PRIORITY = 5 -- set above 10 to override tank mode colour

local function OnHealthValueChanged(oldHealth,current)
    local frame = oldHealth:GetParent():GetParent().kui
    local percent = frame.health.percent

    if percent <= 20 then
        frame:SetHealthColour(PRIORITY, unpack(LOW_HEALTH_COLOR))
        frame.stuckLowHealth = true
    elseif frame.stuckLowHealth then
        frame:SetHealthColour(false)
        frame.stuckLowHealth = nil
    end
end

---------------------------------------------------------------------- Create --
function mod:PostCreate(msg, frame)
    frame.oldHealth:HookScript('OnValueChanged',OnHealthValueChanged)
end

-------------------------------------------------------------------- Register --
mod:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')
