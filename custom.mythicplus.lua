-- UNTESTED
-- some icons which are important for mythic+
-- (they should show up on the top right of nameplates)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('MythicAuras',101,3)
if not mod then return end

function mod:Create(f)
    local mythic = f.handler:CreateAuraFrame({
        max = 2,
        size = 32,
        squareness = 1,
        point = {'BOTTOMRIGHT','RIGHT','LEFT'},
        rows = 1,
        filter = 'HELPFUL',
        whitelist = {
            [226510] = true, -- sanguine
            [277242] = true, -- symbiote of g'huun
        },
    })
    mythic:SetFrameLevel(0)
    mythic:SetWidth(32)
    mythic:SetHeight(32)
    mythic:SetPoint('BOTTOMRIGHT',f.bg,'TOPRIGHT',0,10)
    f.MythicAuras = mythic
end
function mod:Initialise()
    self:RegisterMessage('Create')
end
