local addon = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = addon:NewModule('LowHealthSpecs', addon.Prototype, 'AceEvent-3.0')

local low_health_specs = {
    [254] = 35, -- marksmanship
}
local low_health_default = 20

function mod:Update()
    local spec_index = GetSpecialization()
    if not spec_index then return end
    local spec = GetSpecializationInfo(spec_index)
    if not spec then return end

    if low_health_specs[spec] then
        addon.db.profile.general.lowhealthval = low_health_specs[spec]
    else
        addon.db.profile.general.lowhealthval = low_health_default
    end

    addon:ConfigChanged({'general','lowhealthval'},addon.db.profile)
end
function mod:OnInitialize()
    self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'Update')
    self:RegisterEvent('PLAYER_LOGIN', 'Update')
end
