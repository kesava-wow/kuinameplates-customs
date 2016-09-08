--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
--
-- changes colour of health bars for specific units named in the in the table
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')

local units = {
    ['Stanzilla'] = { 1, 0, 0 }
}
local PRIORITY = 3 -- set above 10 to override tank mode colour

function mod:PostShow(msg, frame)
    local mycol = units[frame.name.text]
    if mycol then
        frame:SetHealthColour(PRIORITY, unpack(mycol))
    end
end
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
