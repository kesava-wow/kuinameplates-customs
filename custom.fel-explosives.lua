-- THIS IS A TEST
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('FelExplosives',101)

local points = {
    'TOP','BOTTOM','LEFT','RIGHT'
}
function mod:Create(f)
    local v = f:CreateTexture()
    v:SetTexture('interface/buttons/white8x8')
    v:SetVertexColor(1,0,0,.5)
    v:SetHeight(30000)
    v:SetWidth(3)

    local h = f:CreateTexture()
    h:SetTexture('interface/buttons/white8x8')
    h:SetVertexColor(1,0,0,.5)
    h:SetHeight(3)
    h:SetWidth(30000)

    local i = f:CreateTexture()
    i:SetTexture(135799)
    i:SetVertexColor(1,1,1,1)
    i:SetHeight(50)
    i:SetWidth(50)

    i:SetPoint('BOTTOM',f,'TOP')
    v:SetPoint('CENTER',i)
    h:SetPoint('CENTER',i)

    f.feicon = {
        ['Show'] = function()
            v:Show()
            h:Show()
            i:Show()
        end,
        ['Hide'] = function()
            v:Hide()
            h:Hide()
            i:Hide()
        end
    }
    f.feicon:Hide()
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
