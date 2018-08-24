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

local mod = addon:NewPlugin('LOSFader',101,3)
if not mod then return end

local plugin_fading
local RULE_UID = 'los_fade'

-- local functions #############################################################
local function sizer_OnSizeChanged(self,x,y)
    if not self then return end
    if self.f.parent:IsShown() then
        -- add LOS state
        if self.f.parent:GetAlpha() <= .4 then
            self.f.state.LOS = false
        else
            self.f.state.LOS = true
        end

        if self.f.state.was_LOS == nil or
           self.f.state.was_LOS ~= self.f.state.LOS
        then
            -- LOS state has changed,
            -- calculate frame alpha upon moving
            plugin_fading:UpdateFrame(self.f)
            self.f.state.was_LOS = self.f.state.LOS
        end
    end
end
local function fading_FadeRulesReset()
    -- add LOS rule
    plugin_fading:AddFadeRule(function(f)
        return not f.state.LOS and 0
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
            sizer_OnSizeChanged(_G[f:GetName()..'PositionHelper'])
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
    -- hook to frames' sizer
    local sizer = _G[frame:GetName()..'PositionHelper']
    if sizer then
        sizer:HookScript('OnSizeChanged',sizer_OnSizeChanged)
    end
end
function mod:Show(frame)
    uf:SetScript('OnUpdate',uf_OnUpdate)
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
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end
function mod:Initialise()
    plugin_fading = addon:GetPlugin('Fading')
    self:AddCallback('Fading','FadeRulesReset',fading_FadeRulesReset)
end
