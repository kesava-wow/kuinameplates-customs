-- README
--
-- By default, this enables OmniCC-like addons on aura buttons. There are
--  rendering issues with aura cooldown frames, which is why it's not included
--  in KNP.
--
-- configuration ###############################################################

local ADD_COOLDOWN_SPIRAL = true -- add a cooldown spiral to icons
local HIDE_CD_TEXT = true        -- hide KNP's CD text

-- delete or comment out any of the above lines (like this - notice the two
-- dashes at the start) to disable the modification.

-- below lines should be left alone ############################################
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('SimpleAuraMods',101,3)
if not mod then return end

local button_UpdateCooldown
local function button_UpdateCooldown(self,duration,expiration)
    if HIDE_CD_TEXT then
        self.cd:Hide()
    else
        button_old_UpdateCooldown(self,duration,expiration)
    end

    if ADD_COOLDOWN_SPIRAL then
        -- update cooldown spiral
        if duration and expiration then
            self.sam_cdf:SetCooldown(expiration-duration,duration)
            self.sam_cdf:Show()
        else
            self.sam_cdf:SetCooldown(0,0)
            self.sam_cdf:Hide()
        end
    end
end

local function PostCreateAuraButton(frame,button)
    if ADD_COOLDOWN_SPIRAL then
        -- name for OmniCC rule matching:
        -- KuiNameplate%d+AuraButton%d+CDF
        local cdf = CreateFrame('Cooldown',
            button.parent.parent:GetName()..'AuraButton'..(#button.parent.buttons+1)..'CDF',
            button,'CooldownFrameTemplate')
        cdf:SetDrawBling(false)
        cdf:SetReverse(true)
        cdf:SetAllPoints(button)
        button.sam_cdf = cdf

        if not HIDE_CD_TEXT then
            cdf:SetHideCountdownNumbers(true)
            cdf.noCooldownCount = true
        end

        button.cd:SetParent(cdf)

        button_old_UpdateCooldown = button.UpdateCooldown
        button.UpdateCooldown = button_UpdateCooldown
    end
end

function mod:Initialise()
    self:AddCallback('Auras','PostCreateAuraButton',PostCreateAuraButton)
end
