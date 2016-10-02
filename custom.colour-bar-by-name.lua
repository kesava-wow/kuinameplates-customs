-- colours nameplate healthbars depending on their name
-- (does not affect name-only mode)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('ColourBarByName',101)

-- 4 = execute
-- 5 = tank mode
-- check is that <= this
local PRIORITY = 3

-- table of names -> bar colours (r,g,b)
local names = {
    ['Arcane Sentinel'] = {1,0,0},
    ['Duskwatch Battlemaster'] = {1,0,1},
}

-- local functions #############################################################
-- reimplemented locally in execute & tankmode
local function CanOverwriteHealthColor(f)
    return not f.state.health_colour_priority or
           f.state.health_colour_priority <= PRIORITY
end
-- messages ####################################################################
function mod:NameUpdate(frame)
    local col = frame.state.name and names[frame.state.name]

    if not col and frame.state.bar_is_name_coloured then
        frame.state.bar_is_name_coloured = nil

        if CanOverwriteHealthColor(frame) then
            frame.state.health_colour_priority = nil
            frame.HealthBar:SetStatusBarColor(unpack(frame.state.healthColour))
        end
    elseif col and not frame.state.bar_is_name_coloured then
        if CanOverwriteHealthColor(frame) then
            frame.state.bar_is_name_coloured = true
            frame.state.health_colour_priority = PRIORITY

            frame.HealthBar:SetStatusBarColor(unpack(col))
        end
    end
end
-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Show','NameUpdate')
    self:RegisterMessage('HealthColourChange','NameUpdate')
    self:RegisterEvent('UNIT_NAME_UPDATE','NameUpdate')
end
