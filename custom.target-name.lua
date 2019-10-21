-- add the unit's target's name above their name.
-- Difficult to describe in a coherent sentence.
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local kui = LibStub('Kui-1.0')

local mod = addon:NewPlugin('TargetName',101,5)
if not mod then return end

local UPDATE_INTERVAL = .25
local update_frame = CreateFrame('Frame')
local elapsed = 0

-- local functions #############################################################
local function update_frame_OnUpdate(self,elap)
    -- units changing target doesn't fire an event, so we have to check constantly
    elapsed = elapsed + elap

    if elapsed >= UPDATE_INTERVAL then
        elapsed = 0

        for _,f in addon:Frames() do
            if f:IsShown() and f.unit then
                local name = UnitName(f.unit..'target')
                if name ~= f.state.target_name then
                    f.state.target_name = name
                    addon:DispatchMessage('TargetChanged',f)
                end
            end
        end
    end
end
-- messages ####################################################################
function mod:Create(frame)
    if frame.TargetName then return end

    local tn = frame:CreateFontString(nil,'OVERLAY')
    tn:SetPoint('CENTER',frame.NameText,'TOP',0,10)

    frame.TargetName = tn
end
function mod:TargetChanged(frame)
    if frame.state.personal then return end
    if frame.state.target_name then
        if frame.state.target_name == UnitName('player') then
            frame.TargetName:SetText('You')
            frame.TargetName:SetTextColor(1,.1,.1)
        else
            frame.TargetName:SetText(frame.state.target_name)
            frame.TargetName:SetTextColor(kui.GetUnitColour(frame.unit..'target',2))
        end
        frame.TargetName:Show()
    else
        frame.TargetName:Hide()
    end
end
function mod:Show(frame)
    local font,_,flags = frame.NameText:GetFont()
    frame.TargetName:SetFont(font,core.profile.font_size_small,flags)

    frame.state.target_name = UnitName(frame.unit..'target')
    self:TargetChanged(frame)
end
function mod:Hide(frame)
    frame.TargetName:Hide()
end
-- initialise ##################################################################
function mod:OnEnable()
    for _,f in addon:Frames() do
        self:Create(f)
    end

    update_frame:SetScript('OnUpdate',update_frame_OnUpdate)

    self:RegisterMessage('Create')
    self:RegisterMessage('TargetChanged')
    self:RegisterMessage('Show')
    self:RegisterMessage('Hide')
end
function mod:OnDisable()
    update_frame:SetScript('OnUpdate',nil)
end
