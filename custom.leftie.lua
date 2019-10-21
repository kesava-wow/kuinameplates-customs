local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('Leftie',104,5)
if not mod then return end

-- local functions #############################################################
local function UpdateNameTextPosition(f,...)
    f.leftie_UpdateNameTextPosition(f,...)

    if f.IN_NAMEONLY then return end

    f.NameText:ClearAllPoints()
    f.NameText:SetJustifyH('LEFT')
    f.NameText:SetPoint('BOTTOMLEFT',f.HealthBar,'TOPLEFT',2.5,core.profile.name_vertical_offset)

    if f.HealthText:IsShown() then
        f.NameText:SetPoint('RIGHT',f.HealthText,'LEFT')
    else
        f.NameText:SetPoint('RIGHT',f.HealthBar,2.5,0)
    end
end
local function UpdateHealthText(f,...)
    f.leftie_UpdateHealthText(f,...)

    if not f.HealthText:IsShown() then return end
    if f.state.no_name then return end

    f.HealthText:ClearAllPoints()
    f.HealthText:SetJustifyH('RIGHT')
    f.HealthText:SetPoint('BOTTOMRIGHT',f.HealthBar,'TOPRIGHT',-2.5,core.profile.name_vertical_offset)
end
local function UpdateSpellNamePosition(f,...)
    f.leftie_UpdateSpellNamePosition(f,...)

    f.SpellName:ClearAllPoints()
    f.SpellName:SetJustifyH('LEFT')
    f.SpellName:SetPoint(
        'TOPLEFT',f.CastBar,'BOTTOMLEFT',
        2.5, core.profile.castbar_name_vertical_offset
    )
end
-- messages ####################################################################
function mod:Create(f)
    if f.NameText and not f.leftie_UpdateNameTextPosition then
        f.leftie_UpdateNameTextPosition = f.UpdateNameTextPosition
        f.UpdateNameTextPosition = UpdateNameTextPosition
        f:UpdateNameTextPosition()
    end
    if f.HealthText and not f.leftie_UpdateHealthText then
        f.leftie_UpdateHealthText = f.UpdateHealthText
        f.UpdateHealthText = UpdateHealthText
        f:UpdateHealthText()
    end
    if f.SpellName and not f.leftie_UpdateSpellNamePosition then
        f.leftie_UpdateSpellNamePosition = f.UpdateSpellNamePosition
        f.UpdateSpellNamePosition = UpdateSpellNamePosition
        f:UpdateSpellNamePosition()
    end
end
-- register ####################################################################
function mod:OnEnable()
    self:RegisterMessage('Create')
end
