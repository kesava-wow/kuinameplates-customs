local addon = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = addon:NewModule('LowHealthSpecs', addon.Prototype, 'AceEvent-3.0')

local low_health_specs = {
    [254] = 35, -- marksmanship
}
local low_health_default = 20

function mod:Update()
    local spec = GetSpecializationInfo(GetSpecialization())

    if low_health_specs[spec] then
        addon.db.profile.general.lowhealthval = low_health_specs[spec]
    else
        addon.db.profile.general.lowhealthval = low_health_default
    end

    addon:ConfigChanged({'general','lowhealthval'},addon.db.profile)
end
function mod:OnInitialize()
    self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED', 'Update')
    self:Update()
end
