local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('Leftie',101,4)
if not mod then return end

local orig_UpdateHealthText,
      orig_UpdateNameTextPosition,
      orig_UpdateSpellNamePosition

-- local functions #############################################################
local function PostUpdateNameTextPosition(f,...)
    orig_UpdateNameTextPosition(f,...)

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
local function PostUpdateHealthText(f,...)
    orig_UpdateHealthText(f,...)

    if not f.HealthText:IsShown() then return end
    if f.state.no_name then return end

    f.HealthText:ClearAllPoints()
    f.HealthText:SetJustifyH('RIGHT')
    f.HealthText:SetPoint('BOTTOMRIGHT',f.HealthBar,'TOPRIGHT',-2.5,core.profile.name_vertical_offset)
end
local function PostUpdateSpellNamePosition(f,...)
    orig_UpdateSpellNamePosition(f,...)

    f.SpellName:ClearAllPoints()
    f.SpellName:SetJustifyH('LEFT')
    f.SpellName:SetPoint(
        'TOPLEFT',f.CastBar,'BOTTOMLEFT',
        2.5, -2+core.profile.castbar_name_vertical_offset
    )
end
-- messages ####################################################################
function mod:Create(f)
    if f.NameText then
        if not orig_UpdateNameTextPosition then
            orig_UpdateNameTextPosition = f.UpdateNameTextPosition
        end
        f.UpdateNameTextPosition = PostUpdateNameTextPosition
    end

    if f.HealthText then
        if not orig_UpdateHealthText then
            orig_UpdateHealthText = f.UpdateHealthText
        end
        f.UpdateHealthText = PostUpdateHealthText
    end

    if f.SpellName then
        if not orig_UpdateSpellNamePosition then
            orig_UpdateSpellNamePosition = f.UpdateSpellNamePosition
        end
        f.UpdateSpellNamePosition = PostUpdateSpellNamePosition
    end
end
-- register ####################################################################
function mod:Initialise()
    self:RegisterMessage('Create')
end
