-- THIS IS A TEST
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('FelExplosives',101)
function mod:Create(f)
    local feicon = f:CreateTexture()
    feicon:SetTexture('interface/buttons/white8x8')
    feicon:SetVertexColor(1,1,1,1)
    feicon:SetPoint('BOTTOM',f,'TOP')
    feicon:SetSize(50,50)
    feicon:Hide()
    f.feicon = feicon
end
function mod:Show(f)
    if f.state.name == 'Fel Explosives' then
        f.feicon:Show()
    else
        f.feicon:Hide()
    end
end
function mod:Initialise()
    print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')
    self:RegisterMessage('Show')
    self:RegisterMessage('Create')
end
