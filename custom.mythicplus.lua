-- some icons which are important for mythic+
-- (they should show up on the top right of nameplates)
local addon = KuiNameplates
local mod = addon:NewPlugin('Custom_MythicAuras',101,5)
if not mod then return end
local HAS_ENABLED

local function GetBolsterCount(unit)
    local c = 0
    for i=1,40 do
        local name = UnitAura(unit,i)
        if name and name == 'Bolster' then -- XXX locale
            c = c+1
        end
    end
    return c
end
local function PostDisplayAuraButton(auraframe,button)
    if auraframe.id ~= 'Custom_Bolster' then return end
    button.count:SetText(GetBolsterCount(auraframe.parent.unit))
    button.count:Show()
end
local function EnableAll()
    for _,f in addon:Frames() do
        if not f.MythicAuras then
            mod:Create(f)
        else
            f.MythicAuras:Enable()
            f.MythicBolster:Enable()
        end
    end
    mod:RegisterMessage('Create')
    HAS_ENABLED=true
end
local function DisableAll()
    for _,f in addon:Frames() do
        if f.MythicAuras then
            f.MythicAuras:Disable()
            f.MythicBolster:Disable()
        end
    end
    mod:UnregisterMessage('Create')
end

function mod:Create(f)
    assert(not f.MythicAuras)

    local mythic = f.handler:CreateAuraFrame({
        max = 2,
        size = 32,
        squareness = 1,
        timer_threshold = 10,
        pulsate = false,
        y_spacing = 1,
        point = {'BOTTOMLEFT','LEFT','RIGHT'},
        rows = 2,
        filter = 'HELPFUL',
        whitelist = {
            [226510] = true, -- Mythic Plus Affix: Sanguine
            [277242] = true, -- BfA Season 1: Symbiote of G'huun
            [260805] = true, -- Waycrest Manor: Focusing Iris
            [264027] = true, -- Waycrest Manor: Warding Candles
            [263246] = true, -- Temple of Sethralis: Lightning Shield
            [257597] = true, -- MOTHERLODE: Azerite Infusion
        },
    })
    mythic:SetFrameLevel(0)
    mythic:SetWidth(32)
    mythic:SetHeight(32)
    mythic:SetPoint('BOTTOMRIGHT',f,'TOPRIGHT',0,10)
    f.MythicAuras = mythic

    -- also create a frame to track stacks of bolstering...
    -- (XXX oops legacy auras - would this still work?)
    local bolster = f.handler:CreateAuraFrame({
        id = 'Custom_Bolster',
        max = 1,
        size = 24,
        squareness = 1,
        timer_threshold = 10,
        pulsate = false,
        point = {'BOTTOMRIGHT','RIGHT','LEFT'},
        rows = 1,
        filter = 'HELPFUL',
        whitelist = { [209859] = true }
    })
    bolster:SetFrameLevel(0)
    bolster:SetWidth(24)
    bolster:SetHeight(24)
    bolster:SetPoint('BOTTOMLEFT',mythic,'BOTTOMRIGHT',1,0)
    f.MythicBolster = bolster
end
function mod:PLAYER_ENTERING_WORLD()
    if IsInInstance() then
        local instance_type,difficulty = select(2,GetInstanceInfo())
        if instance_type == 'party' then
            local show_mythic = select(6,GetDifficultyInfo(difficulty))
            if show_mythic then
                EnableAll()
                return
            end
        end
    end
    if HAS_ENABLED then
        DisableAll()
    end
end
function mod:Initialise()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('UPDATE_INSTANCE_INFO','PLAYER_ENTERING_WORLD')
    self:AddCallback('Auras','PostDisplayAuraButton',PostDisplayAuraButton)
end
