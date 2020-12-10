-- change colour of nameplate healthbars depending on their name or auras,
-- or if they're your current target.
local addon = KuiNameplates
local kui = LibStub('Kui-1.0')
local mod = addon:NewPlugin('ColourBarByName',101,5)
if not mod then return end
Mixin(mod,kui.FrameLockMixin)
local plugin_fading,COLOUR_TARGET

-- table of names -> bar colours (r,g,b)
local names = {
    ['Elite Queensguard'] = {1,0,0},
    ['Explosives'] = {1,0,1},
}
-- should frames stay at max alpha when they match one of the above names?
local FADE_IN_WITH_NAME = true

-- table of spell ids -> bar colours
local buffs = {
    [17] = {.6,1,.6},
}
local debuffs = {
    [6788] = {1,.6,.6},
}
-- should frames stay at max alpha when they have one of the above auras?
local FADE_IN_WITH_AURA = true

-- un-comment the next line to enable target colour (by removing the dashes)
--COLOUR_TARGET = {.4,.8,.4}

-- To overwrite tank mode, change 3 to 6
-- To overwrite execute, change 3 to 5
local PRIORITY = 3

-- local functions #############################################################
-- reimplemented locally in execute & tankmode
local function CanOverwriteHealthColor(f)
    return not f.state.health_colour_priority or
           f.state.health_colour_priority <= PRIORITY
end
local function FindAura(unit,func,tbl)
    for i=1,40 do
        local spellid = select(10,func(unit,i))
        if not spellid then return end
        if tbl[spellid] then return tbl[spellid] end
    end
end
local function ResetBarColour(frame)
    if CanOverwriteHealthColor(frame) then
        frame.state.health_colour_priority = nil
        frame.HealthBar:SetStatusBarColor(unpack(frame.state.healthColour))
    end
end
local function SetBarColour(frame,colour)
    frame.state.health_colour_priority = PRIORITY
    frame.HealthBar:SetStatusBarColor(unpack(colour))
end
local function Fading_Update(frame)
    plugin_fading:UpdateFrame(frame)
end
-- #############################################################################
function mod.Fading_FadeRulesReset()
    if FADE_IN_WITH_NAME then
        plugin_fading:AddFadeRule(function(f)
            return f.state.ColourBarByName_Name and 1
        end,1)
    end
    if FADE_IN_WITH_AURA then
        plugin_fading:AddFadeRule(function(f)
            return f.state.ColourBarByName_Aura and 1
        end,1)
    end
end
function mod:NameUpdate(frame)
    if frame.state.ColourBarByName_Aura then return end
    if COLOUR_TARGET and frame.handler:IsTarget() then return end

    local col = frame.state.name and names[frame.state.name]
    local update_alpha
    if not col and frame.state.ColourBarByName_Name then
        update_alpha = true
        frame.state.ColourBarByName_Name = nil
        ResetBarColour(frame)
    elseif col and CanOverwriteHealthColor(frame) then
        update_alpha = not frame.state.ColourBarByName_Name
        frame.state.ColourBarByName_Name = true
        SetBarColour(frame,col)
    end
    if update_alpha then
        self:FrameLockFunc(Fading_Update,frame)
    end
end
-- messages ####################################################################
function mod:Show(frame)
    self:UNIT_AURA(nil,frame)
    self:NameUpdate(frame)
end
function mod:GainedTarget(frame)
    if not COLOUR_TARGET then return end
    if CanOverwriteHealthColor(frame) then
        frame.state.ColourBarByName_Name = true
        SetBarColour(frame,COLOUR_TARGET)
    end
end
function mod:LostTarget(frame)
    if not COLOUR_TARGET then return end
    self:Show(frame)
end
-- events ######################################################################
function mod:UNIT_NAME_UPDATE(_,frame)
    self:NameUpdate(frame)
end
function mod:UNIT_AURA(_,frame)
    if COLOUR_TARGET and frame.handler:IsTarget() then return end
    local col = FindAura(frame.unit,UnitDebuff,debuffs)
    if not col then col = FindAura(frame.unit,UnitBuff,buffs) end

    local update_alpha
    if col and CanOverwriteHealthColor(frame) then
        update_alpha = not frame.state.ColourBarByName_Aura
        frame.state.ColourBarByName_Aura = true
        frame.state.ColourBarByName_Name = nil
        SetBarColour(frame,col)
    elseif frame.state.ColourBarByName_Aura then
        update_alpha = true
        frame.state.ColourBarByName_Aura = nil
        ResetBarColour(frame)
        self:NameUpdate(frame)
    end
    if update_alpha then
        self:FrameLockFunc(Fading_Update,frame)
    end
end
-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Show')
    self:RegisterMessage('HealthColourChange','Show')
    self:RegisterMessage('GainedTarget')
    self:RegisterMessage('LostTarget')
    self:RegisterUnitEvent('UNIT_NAME_UPDATE')
    self:RegisterUnitEvent('UNIT_AURA')

    plugin_fading = addon:GetPlugin('Fading')

    self:AddCallback('Fading','FadeRulesReset',self.Fading_FadeRulesReset)
    self.Fading_FadeRulesReset()
end
