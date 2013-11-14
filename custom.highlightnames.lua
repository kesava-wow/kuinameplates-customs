--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
--
-- changes colour of health bar depending on the name of a mob
-- i.e. if a mob's name exists in the colours table, that colour
-- (in { r, g, b } format) will be used for its health bar.
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')
local colours = {
	['This is definitely the name of a mob'] = { 1, .5, 0 },
	['Strongarms'] = { 1, 1, 1 }
}
function mod:PostShow(msg, frame)
	local colour = colours[frame.name:GetText()] or nil
	if colour then
		frame.health:SetStatusBarColor(unpack(colour))
	end
end
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
