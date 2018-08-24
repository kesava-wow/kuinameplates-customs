-- ugly-scales the target nameplate
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('TargetScale',101,3)
if not mod then return end

local SCALE_FACTOR = 1.5

local function ForcePositionUpdate(frame)
    if not frame:IsShown() then return end

    local sizer = _G[frame:GetName()..'PositionHelper']
    frame:SetPoint('CENTER',WorldFrame,'BOTTOMLEFT',
        floor(sizer:GetWidth()),floor(sizer:GetHeight()))
end

function mod:GainedTarget(frame)
    frame:SetScale(UIParent:GetScale()*SCALE_FACTOR)
    ForcePositionUpdate(frame)
end
function mod:LostTarget(frame)
    frame:SetScale(UIParent:GetScale())
    ForcePositionUpdate(frame)
end
function mod:Initialise()
    self:RegisterMessage('GainedTarget')
    self:RegisterMessage('LostTarget')
    self:RegisterMessage('Hide','LostTarget')
end
