--[[
-- Avoid fading hostile units
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('CustomInjector',101)
local plugin_fading

function mod.Fading_FadeRulesReset()
    plugin_fading:AddFadeRule(function(f)
        return not f.state.friend and 1
    end,1)
end
function mod:Initialise()
    print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')

    plugin_fading = addon:GetPlugin('Fading')

    self:AddCallback('Fading','FadeRulesReset',self.Fading_FadeRulesReset)
    self.Fading_FadeRulesReset()
end
