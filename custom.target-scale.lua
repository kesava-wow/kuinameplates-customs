-- ugly-scales the target nameplate
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('Custom_TargetScale',101,5)
if not mod then return end

local SCALE_FACTOR = 1.5
local SCALE_DURATION = .05

local function Finished_In(self)
    self:GetParent():SetScale(addon.uiscale*SCALE_FACTOR)
    self:GetParent().state.custom_zoomed = true
end
local function Finished_Out(self)
    self:GetParent():SetScale(addon.uiscale)
    self:GetParent().state.custom_zoomed = nil
end
local function AnimStop(self)
    self:Finished()
end

function mod:GainedTarget(frame)
    frame.Custom_TargetScale:Stop()
    if not frame.state.custom_zoomed then
        frame.Custom_TargetScale.scale:SetFromScale(1,1)
        frame.Custom_TargetScale.scale:SetToScale(SCALE_FACTOR,SCALE_FACTOR)
        frame.Custom_TargetScale:Play()
        frame.Custom_TargetScale.Finished = Finished_In
    end
end
function mod:LostTarget(frame)
    frame.Custom_TargetScale:Stop()
    if frame.state.custom_zoomed then
        frame.Custom_TargetScale.scale:SetFromScale(1,1)
        frame.Custom_TargetScale.scale:SetToScale(1/SCALE_FACTOR,1/SCALE_FACTOR)
        frame.Custom_TargetScale:Play()
        frame.Custom_TargetScale.Finished = Finished_Out
    end
end
function mod:Create(frame)
    local this = frame:CreateAnimationGroup()
    local scale = this:CreateAnimation('Scale')
    scale:SetDuration(SCALE_DURATION)
    this.scale = scale
    frame.Custom_TargetScale = this

    this:SetScript('OnFinished',AnimStop)
    this:SetScript('OnStop',AnimStop)
end
function mod:Initialise()
    self:RegisterMessage('Create')
    self:RegisterMessage('GainedTarget')
    self:RegisterMessage('LostTarget')
    self:RegisterMessage('Hide','LostTarget')
end
