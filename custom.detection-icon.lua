local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('DetectionIcon',101)

function mod:Create(f)
    local detection = f.handler:CreateAuraFrame({
        max = 1,
        size = 24,
        squareness = 1,
        point = {'BOTTOMLEFT','LEFT','RIGHT'},
        rows = 1,
        filter = 'HELPFUL',
        whitelist = {
            [203761] = true,
            [213486] = true,
        },
    })

    detection:SetFrameLevel(0)
    detection:SetWidth(24)
    detection:SetHeight(24)
    detection:SetPoint('RIGHT',f.bg,'LEFT',-1,0)

    f.DetectionIcon = detection
end

function mod:Initialise()
    self:RegisterMessage('Create')
end
