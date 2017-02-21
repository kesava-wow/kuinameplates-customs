-- simple-ish modifications for auras
-- configuration ###############################################################
local CENTRE_CD_TEXT = true          -- move cooldown text to centre
--local AURA_TEXT_SIZE_MOD = 5       -- increase text size by 5 units

-- changing cooldown text colour:
local AURA_TEXT_COLOUR_S = {1,0,1}   -- short (<5s) (purple... technically)
local AURA_TEXT_COLOUR_M = {1,.8,1} -- medium (<20s) (bright pink)
local AURA_TEXT_COLOUR_L = {1,1,1}   -- long (>20s) (white)

-- comment out any of the above lines (like this - notice the two dashes at the
-- start) to disable the modification.

-- below lines should be left alone ############################################
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('SimpleAuraMods',101)

local button_UpdateCooldown
local button_old_UpdateCooldown
do
    local old_ou
    local function button_OnUpdate(self,...)
        -- OnUpdate is killed when necessary by the original function
        old_ou(self,...)

        local remaining = self.expiration - GetTime()

        if remaining <= 5 then
            if AURA_TEXT_COLOUR_S then
                self.cd:SetTextColor(unpack(AURA_TEXT_COLOUR_S))
            end
        elseif remaining <= 20 then
            if AURA_TEXT_COLOUR_M then
                self.cd:SetTextColor(unpack(AURA_TEXT_COLOUR_M))
            end
        else
            if AURA_TEXT_COLOUR_L then
                self.cd:SetTextColor(unpack(AURA_TEXT_COLOUR_L))
            end
        end
    end

    function button_UpdateCooldown(self,duration,expiration)
        button_old_UpdateCooldown(self,duration,expiration)

        if expiration and expiration > 0 then
            if not old_ou then
                old_ou = self:GetScript('OnUpdate')
            end

            self:SetScript('OnUpdate',button_OnUpdate)
        end
    end
end

local function PostCreateAuraButton(frame,button)
    if CENTRE_CD_TEXT then
        -- centre cd text using the callback
        button.cd:ClearAllPoints()
        button.cd:SetPoint('CENTER',0,core.profile.text_vertical_offset+1)
    end

    if AURA_TEXT_COLOUR_S or AURA_TEXT_COLOUR_M or AURA_TEXT_COLOUR_L then
        -- modify text colour by "overloading" OnUpdate on visible buttons
        -- (ok, this one isn't so simple until i make this just use a variable)
        button_old_UpdateCooldown = button.UpdateCooldown
        button.UpdateCooldown = button_UpdateCooldown
    end
end

function mod:Initialise()
    self:AddCallback('Auras','PostCreateAuraButton',PostCreateAuraButton)

    if AURA_TEXT_SIZE_MOD then
        -- modify text size by "overloading" the SetFont helper in core
        local old_sf = core.AurasButton_SetFont
        core.AurasButton_SetFont = function(button)
            old_sf(button)

            local f,s,t = button.cd:GetFont()
            button.cd:SetFont(f,s+AURA_TEXT_SIZE_MOD,t)

            f,s,t = button.count:GetFont()
            button.count:SetFont(f,s+AURA_TEXT_SIZE_MOD,t)
        end
    end
end
