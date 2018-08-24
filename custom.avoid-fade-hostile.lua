--[[
-- Avoid fading hostile units
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('AvoidFadeHostile',101,3)
if not mod then return end

local plugin_fading

function mod.Fading_FadeRulesReset()
    plugin_fading:AddFadeRule(function(f)
        return not f.state.friend and 1
    end,1)
end
function mod:OnEnable()
    self:AddCallback('Fading','FadeRulesReset',self.Fading_FadeRulesReset)
    self.Fading_FadeRulesReset()
end
function mod:Initialise()
    plugin_fading = addon:GetPlugin('Fading')
end
