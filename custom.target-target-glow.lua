-- makes the target's target's nameplate glow pink
-- eg. a healer targeting a tank can see which nameplate the tank is targeting
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('TargetTargetGlow',101,4)
if not mod then return end
local previous_frame
-- local functions #############################################################
local function UpdateTargetTargetGlow()
    local tt = C_NamePlate.GetNamePlateForUnit('targettarget')
    if previous_frame and previous_frame ~= tt then
        if previous_frame.kui.unit then
            previous_frame.kui:UpdateFrameGlow()
        end
        previous_frame = nil
    end
    if tt and tt.kui and tt.kui.unit then
        previous_frame = tt
        tt.kui:UpdateFrameGlow()
    end
end
local function Frame_UpdateFrameGlow(frame)
    frame:TargetTargetHighlight_UpdateFrameGlow()

    if not frame.state.target and
       not frame.state.highlight and
       not frame.state.glowing and
       UnitIsUnit(frame.unit,'targettarget')
    then
        if frame.IN_NAMEONLY then
            frame.NameOnlyGlow:SetVertexColor(153,0,255)
            frame.NameOnlyGlow:SetAlpha(.8)
            frame.NameOnlyGlow:Show()
        else
            frame.ThreatGlow:SetVertexColor(153,0,255)
            frame.ThreatGlow:SetAlpha(.8)
        end
    end
end
-- events ######################################################################
function mod:UNIT_TARGET(event,unit)
    if unit ~= 'target' and unit ~= 'player' then return end
    UpdateTargetTargetGlow()
end
-- messages ####################################################################
function mod:Create(frame)
    frame.TargetTargetHighlight_UpdateFrameGlow = frame.UpdateFrameGlow
    frame.UpdateFrameGlow = Frame_UpdateFrameGlow
end
function mod:TargetUpdate(frame)
    UpdateTargetTargetGlow()
end
-- initialise ##################################################################
function mod:OnEnable()
    self:RegisterEvent('UNIT_TARGET')
    self:RegisterMessage('Create')
    self:RegisterMessage('GainedTarget','TargetUpdate')
    self:RegisterMessage('LostTarget','TargetUpdate')
end
