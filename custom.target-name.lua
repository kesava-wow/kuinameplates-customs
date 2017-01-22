-- add the unit's target's name above their name. Difficult to describe in a
-- coherent sentence.
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('TargetName',101)

local UPDATE_INTERVAL = .1
local interval = 0

local update = CreateFrame('Frame')
update:SetScript('OnUpdate',function(self,elap)
    -- units changing target doesn't fire an event, so we have to check constantly
    interval = interval + elap

    if interval >= UPDATE_INTERVAL then
        interval = 0

        for _,f in addon:Frames() do
            if f:IsShown() and f.unit then
                f.TargetName:SetText(UnitName(f.unit..'target'))
            end
        end
    end
end)

function mod:Create(frame)
    local tn = frame:CreateFontString(nil,'OVERLAY')
    tn:SetFont(frame.NameText:GetFont())
    tn:SetPoint('CENTER',frame,'TOP')

    frame.TargetName = tn
end
function mod:Initialise()
    self:RegisterMessage('Create')
end
