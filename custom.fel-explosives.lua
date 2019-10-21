--
-- adds a crosshair to explosives in M+
--
-- (zhTW translation needed)
--
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('FelExplosives',101,5)
if not mod then return end

local mob_name
local function icon_Show(self)
    self.v:Show()
    self.h:Show()
    self.i:Show()
end
local function icon_Hide(self)
    self.v:Hide()
    self.h:Hide()
    self.i:Hide()
end
function mod:Create(f)
    f.feicon = {}

    local v = f:CreateTexture(nil,'ARTWORK',nil,1)
    v:SetTexture('interface/buttons/white8x8')
    v:SetVertexColor(1,0,0,.5)
    v:SetHeight(30000)
    v:SetWidth(3)
    f.feicon.v = v

    local h = f:CreateTexture(nil,'ARTWORK',nil,1)
    h:SetTexture('interface/buttons/white8x8')
    h:SetVertexColor(1,0,0,.5)
    h:SetHeight(3)
    h:SetWidth(30000)
    f.feicon.h = h

    local i = f:CreateTexture(nil,'ARTWORK',nil,2)
    i:SetTexture(135799)
    i:SetVertexColor(1,1,1,1)
    i:SetHeight(50)
    i:SetWidth(50)
    f.feicon.i = i

    i:SetPoint('BOTTOM',f,'TOP')
    v:SetPoint('CENTER',i)
    h:SetPoint('CENTER',i)

    f.feicon.Show = icon_Show
    f.feicon.Hide = icon_Hide
    f.feicon:Hide()
end
function mod:Show(f)
    if f.state.name == mob_name then
        f.feicon:Show()
    end
end
function mod:Hide(f)
    f.feicon:Hide()
end
function mod:PLAYER_ENTERING_WORLD()
    if IsInInstance() then
        self:RegisterMessage('Show')
    else
        self:UnregisterMessage('Show')
    end
end
function mod:Initialise()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterMessage('Create')
    self:RegisterMessage('Hide')

    local locale = GetLocale()
    local names = {
        deDE = 'Sprengstoff',
        enUS = 'Explosives',
        esMX = 'Explosivos',
        frFR = 'Explosifs',
        itIT = 'Esplosivi',
        ptBR = 'Explosivos',
        ruRU = 'Взрывчатка',
        koKR = '폭발물',
        zhCN = '爆炸物',
    }
    mob_name = (locale and names[locale]) or names.enUS
end
