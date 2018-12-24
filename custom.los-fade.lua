--[[
-- This is inefficient and may have a performance impact on slower PCs.
--
-- Fade out frames which are out of your characters line of sight,
-- leaving their clickboxes and motion behaviour intact, as that can't be
-- arbitrarily changed by addons.
--
-- This relies on the CVar "nameplateOccludedAlphaMult" being set to 0.4 or
-- lower, and "nameplateMinAlpha" being 0.3 or above. The defaults are fine.
--]]
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('LOSFader',101,4)
if not mod then return end

local FADE_TO = 0.3

local plugin_fading
local RULE_UID = 'los_fade'

-- local functions #############################################################
local function sizer_OnSizeChanged(self)
    if not self or not self:IsShown() then return end

    -- add LOS state
    self.f.state.LOS = self.f.parent:GetAlpha() > .4

    if self.f.state.was_LOS == nil or
       self.f.state.was_LOS ~= self.f.state.LOS
    then
        -- LOS state changed
        plugin_fading:UpdateFrame(self.f)
        self.f.state.was_LOS = self.f.state.LOS
    end
end
local function fading_FadeRulesReset()
    -- add LOS rule
    plugin_fading:AddFadeRule(function(f)
        return not f.state.LOS and FADE_TO
    end,21,RULE_UID)
end
-- world entry alpha check loop ################################################
local uf = CreateFrame('Frame')
local uf_elapsed,uf_loop_world_entry = 0,0
local function uf_OnUpdate(self,elap)
    uf_elapsed = uf_elapsed + elap
    if uf_elapsed > .1 then
        uf_elapsed = 0

        for k,f in addon:Frames() do
            -- force LOS updates on all frames
            sizer_OnSizeChanged(f.LOSFade_Sizer)
        end

        uf_loop_world_entry = uf_loop_world_entry + 1
        if uf_loop_world_entry > 2 then
            uf_loop_world_entry = 0
            self:SetScript('OnUpdate',nil)
        end
    end
end
-- messages ####################################################################
function mod:Create(frame)
    -- create a frame to monitor when nameplates move
    local sizer = CreateFrame('Frame',frame:GetName()..'LOSFadeSizer',frame)
    sizer:SetPoint('BOTTOMLEFT',WorldFrame)
    sizer:SetPoint('TOPRIGHT',frame,'CENTER')
    sizer:SetScript('OnSizeChanged',sizer_OnSizeChanged)
    sizer.f = frame
    frame.LOSFade_Sizer = sizer
end
function mod:Show(frame)
    uf:SetScript('OnUpdate',uf_OnUpdate)
end
function mod:LostTarget(frame)
    -- target confuses us because it bumps the alpha up, so check again
    sizer_OnSizeChanged(frame.LOSFade_Sizer)
end
-- events ######################################################################
function mod:PLAYER_ENTERING_WORLD()
    uf:SetScript('OnUpdate',uf_OnUpdate)
end
-- initialise ##################################################################
function mod:OnEnable()
    fading_FadeRulesReset()
    self:RegisterMessage('Create')
    self:RegisterMessage('Show')
    self:RegisterMessage('LostTarget')
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end
function mod:Initialise()
    plugin_fading = addon:GetPlugin('Fading')
    self:AddCallback('Fading','FadeRulesReset',fading_FadeRulesReset)
end
