--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
--
-- changes colour of health bars for specific units in the table
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')

local units = {
    ['Stanzilla'] = { 1, 0, 0 }
}

function mod:PostShow(msg, frame)
    local mycol = units[frame.name:GetText()]
    if mycol then
        frame.health:SetStatusBarColor(unpack(mycol))
    end
end
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
