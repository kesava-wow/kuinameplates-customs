-- listen for power events and dispatch to nameplates
local addon = KuiNameplates
-- XXX element when merged (no max_minor)
local ele = addon:NewPlugin('AbsorbBar',101,1)
-- prototype additions #########################################################
function addon.Nameplate.UpdateAbsorb(f)
    f = f.parent
    f.state.absorbs = UnitGetTotalAbsorbs(f.unit) or 0

    if f.elements.AbsorbBar and f.state.health_max then
        if f.AbsorbBar.spark then
            if f.state.absorbs > f.state.health_max then
                f.AbsorbBar.spark:Show()
            else
                f.AbsorbBar.spark:Hide()
            end
        end

        f.AbsorbBar:SetMinMaxValues(0,f.state.health_max)
        f.AbsorbBar:SetValue(f.state.absorbs)

        -- re-set the texture to fix tiling
        f.AbsorbBar:SetStatusBarTexture(f.AbsorbBar:GetStatusBarTexture())
    end
end
-- messages ####################################################################
function ele:Show(f)
    f.handler:UpdateAbsorb()
end
function ele:Create(f)
    -- not using CreateStatusBar as we don't want a background
    local bar = CreateFrame('StatusBar',nil,f.HealthBar)
    bar:SetStatusBarTexture('interface/addons/kui_media/t/stippled-bar')
    bar:SetAllPoints(f.HealthBar)
    bar:SetFrameLevel(0)
    bar:SetStatusBarColor(.3,.7,1)
    bar:SetAlpha(.5)

    local t = bar:GetStatusBarTexture()
    t:SetDrawLayer('ARTWORK',1)
    t:SetHorizTile(true)
    t:SetVertTile(true)

    -- spark for over-absorb highlighting
    local spark = bar:CreateTexture(nil,'ARTWORK',nil,7)
    spark:SetTexture('interface/addons/kui_media/t/spark')
    spark:SetWidth(8)
    spark:SetPoint('TOP',bar,'TOPRIGHT',-1,4)
    spark:SetPoint('BOTTOM',bar,'BOTTOMRIGHT',-1,-4)
    spark:SetVertexColor(.3,.7,1)
    bar.spark = spark

    -- XXX inherit config for animation
    f.handler:SetBarAnimation(bar,'smooth')

    f.handler:RegisterElement('AbsorbBar',bar)
end
-- events ######################################################################
function ele:AbsorbEvent(event,f)
    f.handler:UpdateAbsorb()
end
-- register ####################################################################
function ele:OnEnable()
    self:RegisterMessage('Show')

    -- XXX creating the bar here for testing
    self:RegisterMessage('Create')

    self:RegisterUnitEvent('UNIT_MAXHEALTH','AbsorbEvent')
    self:RegisterUnitEvent('UNIT_ABSORB_AMOUNT_CHANGED','AbsorbEvent')
end
function ele:Initialise()
end
