-- some icons which are important for mythic+
-- (they should show up on the top right of nameplates)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('MythicAuras',101,5)
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
            [226510] = true, -- Mythic Plus Affix: Sanguine
            [277242] = true, -- BfA Season 1: Symbiote of G'huun
            [260805] = true, -- Waycrest Manor: Focusing Iris
            [263246] = true, -- Temple of Sethralis: Lightning Shield
            [257597] = true, -- MOTHERLODE: Azerite Infusion
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
