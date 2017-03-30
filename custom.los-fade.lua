--[[
-- THIS IS INCREDIBLY INEFFICIENT.
-- I DO NOT RECOMMEND USING IT IN RAIDS.
--
-- Fade out frames which are out of your characters line of sight,
-- leaving their clickboxes and motion behaviour intact, as that can't be
-- arbitrarily changed by addons.
--
-- This relies on the CVar "nameplateOccludedAlphaMult" being set to 0.4 or
-- lower, and "nameplateMinAlpha" being 0.3 or above. The defaults are fine.
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('CustomInjector',101)
local plugin_fading

local function sizer_OnSizeChanged(self,x,y)
    -- add LOS state when frames move
    if self.f.parent:IsShown() then
        if self.f.parent:GetAlpha() < .3 then
            self.f.state.LOS = nil
        else
            self.f.state.LOS = true
        end
    end

    -- calculate frame alpha upon moving
    -- (this is the massively inefficient part)
    plugin_fading:UpdateFrame(self.f)
end
local function fading_FadeRulesReset()
    -- add LOS rule
    plugin_fading:AddFadeRule(function(f)
        return not f.state.LOS and 0
    end,1)
end
function mod:Create(frame)
    -- hook to frames' sizer
    local sizer = _G[frame:GetName()..'PositionHelper']
    if sizer then
        sizer:HookScript('OnSizeChanged',sizer_OnSizeChanged)
    end
end
function mod:Initialise()
    print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')

    plugin_fading = addon:GetPlugin('Fading')
    self:AddCallback('Fading','FadeRulesReset',fading_FadeRulesReset)
    fading_FadeRulesReset()

    self:RegisterMessage('Create')
end
