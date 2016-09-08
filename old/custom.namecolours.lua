--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
--
-- changes the name text colour of friendly/enemeny units.
-- this functionality will be removed as a built in option soon, because it's
-- extremely easy to reproduce in custom.lua. Like this.
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')
function mod:PostShow(msg, frame)
    if frame.friend then
        frame.name:SetTextColor(0,1,0)
    else
        frame.name:SetTextColor(1,0,0)
    end
end
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
