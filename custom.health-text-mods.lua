local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local kui = LibStub('Kui-1.0')
local mod = addon:NewPlugin('HealthTextMods',101)

-- (percent) show a percent symbol
local PERCENT_SYMBOL = true
-- (percent) percentage of health under which decimals should be displayed
local DECIMAL_THRESHOLD = 1
-- (percent) decimal places to show when below DECIMAL_THRESHOLD
local DECIMAL_PLACES = 1

-- #############################################################################
local function UpdateHealthText(f,...)
    f:healthtextmods_UpdatehealthText(...)
    if not f.HealthText:IsShown() or f.HealthText:GetText() == '' then return end

    -- determine what key is currently displayed
    -- (1=cur,2=max,3=per,4=deficit,5=blank)
    local key
    if f.state.friend then
        if f.state.health_cur ~= f.state.health_max then
            key = core.profile.health_text_friend_dmg
        else
            key = core.profile.health_text_friend_max
        end
    elseif f.state.health_cur ~= f.state.health_max then
        key = core.profile.health_text_hostile_dmg
    else
        key = core.profile.health_text_hostile_max
    end

    -- modify display
    if key == 3 then
        local v = f.state.health_per
        if  DECIMAL_THRESHOLD and DECIMAL_PLACES and
            v < DECIMAL_THRESHOLD and DECIMAL_PLACES > 0
        then
            v = string.format('%.'..DECIMAL_PLACES..'f',f.state.health_per)
        else
            v = ceil(f.state.health_per)
        end

        if PERCENT_SYMBOL then
            v = v..'%'
        end

        f.HealthText:SetText(v)
    end
end

function mod:Create(f)
    f.healthtextmods_UpdatehealthText = f.UpdateHealthText
    f.UpdateHealthText = UpdateHealthText
end
function mod:Initialise()
    if not KUINAMEPLATESCUSTOMWARNING then
        KUINAMEPLATESCUSTOMWARNING = true
        print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')
    end

    PERCENT_SYMBOL = PERCENT_SYMBOL and true or false
    DECIMAL_THRESHOLD = tonumber(DECIMAL_THRESHOLD)
    DECIMAL_PLACES = tonumber(DECIMAL_PLACES)

    self:RegisterMessage('Create')
end
