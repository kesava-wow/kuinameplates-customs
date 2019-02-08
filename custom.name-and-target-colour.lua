-- colours nameplate healthbars depending on their name
-- (does not affect name-only mode)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('ColourBarByName',101,4)
if not mod then return end

local plugin_fading

-- table of names -> bar colours (r,g,b)
local names = {
    ['Meredil Glider'] = {1,0,0},
    ['Explosives'] = {1,0,1},
}
-- table of names -> frame alpha
local names_fade = {
    ['Explosives'] = 1,
}

-- to enable target colouring,
-- remove the two dashes at the start of the following line:
--local COLOUR_TARGET = {.4,.8,.4}

-- To overwrite tank mode, set this to 6
-- To overwrite execute, set this to 5
local PRIORITY = 3

-- local functions #############################################################
-- reimplemented locally in execute & tankmode
local function CanOverwriteHealthColor(f)
    return not f.state.health_colour_priority or
           f.state.health_colour_priority <= PRIORITY
end
-- messages ####################################################################
function mod.Fading_FadeRulesReset()
    plugin_fading:AddFadeRule(function(f)
        return f.state.name and names_fade[f.state.name]
    end,1)
end
function mod:NameUpdate(frame)
    if COLOUR_TARGET and frame.handler:IsTarget() then return end

    local col = frame.state.name and names[frame.state.name]

    if frame.state.name and names_fade[frame.state.name] then
        plugin_fading:UpdateFrame(frame)
    end

    if not col and frame.state.bar_is_name_coloured then
        frame.state.bar_is_name_coloured = nil

        if CanOverwriteHealthColor(frame) then
            frame.state.health_colour_priority = nil
            frame.HealthBar:SetStatusBarColor(unpack(frame.state.healthColour))
        end
    elseif col then
        if CanOverwriteHealthColor(frame) then
            frame.state.bar_is_name_coloured = true
            frame.state.health_colour_priority = PRIORITY

            frame.HealthBar:SetStatusBarColor(unpack(col))
        end
    end
end
function mod:UNIT_NAME_UPDATE(event,frame)
    self:NameUpdate(frame)
end
function mod:GainedTarget(frame)
    if not COLOUR_TARGET then return end
    if CanOverwriteHealthColor(frame) then
        frame.state.bar_is_name_coloured = true
        frame.state.health_colour_priority = PRIORITY
        frame.HealthBar:SetStatusBarColor(unpack(COLOUR_TARGET))
    end
end
-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Show','NameUpdate')
    self:RegisterMessage('HealthColourChange','NameUpdate')
    self:RegisterMessage('LostTarget','NameUpdate')
    self:RegisterUnitEvent('UNIT_NAME_UPDATE')

    self:RegisterMessage('GainedTarget','TargetUpdate')

    plugin_fading = addon:GetPlugin('Fading')

    self:AddCallback('Fading','FadeRulesReset',self.Fading_FadeRulesReset)
    self.Fading_FadeRulesReset()
end
