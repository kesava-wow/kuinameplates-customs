-- ugly-scales the target nameplate
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('TargetScale',101,4)
if not mod then return end

local SCALE_FACTOR = 1.5

function mod:GainedTarget(frame)
    frame:SetScale(UIParent:GetScale()*SCALE_FACTOR)
end
function mod:LostTarget(frame)
    frame:SetScale(UIParent:GetScale())
end
function mod:Initialise()
    self:RegisterMessage('GainedTarget')
    self:RegisterMessage('LostTarget')
    self:RegisterMessage('Hide','LostTarget')
end
