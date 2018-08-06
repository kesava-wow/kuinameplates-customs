-- simple-ish modifications for auras
-- configuration ###############################################################
--local AURAS_VERTICAL_OFFSET = -5    -- move aura frame down by 5 pixels

-- If you want to be able to modify CD text through OmniCC,
-- uncomment both of these variables:
--local ADD_COOLDOWN_SPIRAL = true    -- add a cooldown spiral to icons
--local HIDE_CD_TEXT = true           -- hide KNP's CD text

-- Variables after this point obviously won't change anything if you've
-- enabled "HIDE_CD_TEXT":
--local CENTRE_CD_TEXT = true         -- move cooldown text to centre
--local CD_TEXT_VERTICAL_OFFSET = 8   -- move cooldown text up by 8 pixels
local CD_TEXT_SIZE_MOD = 2            -- modify cooldown text size
local COUNT_TEXT_SIZE_MOD = 0         -- modify count text size

-- delete or comment out any of the above lines (like this - notice the two
-- dashes at the start) to disable the modification.

-- below lines should be left alone ############################################
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('SimpleAuraMods',101)

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
    if CENTRE_CD_TEXT then
        -- centre cd text using the callback
        button.cd:ClearAllPoints()

        if CD_TEXT_VERTICAL_OFFSET then
            button.cd:SetPoint('CENTER',0,core.profile.text_vertical_offset+CD_TEXT_VERTICAL_OFFSET+1)
        else
            button.cd:SetPoint('CENTER',0,core.profile.text_vertical_offset+1)
        end
    elseif CD_TEXT_VERTICAL_OFFSET then
        -- move aura text using callback
        button.cd:ClearAllPoints()
        button.cd:SetPoint('TOPLEFT',-2,2+core.profile.text_vertical_offset+CD_TEXT_VERTICAL_OFFSET)
    end

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

function mod:Show(f)
    if AURAS_VERTICAL_OFFSET then
        -- move aura frame whenever the nameplate is shown
        -- we're executed after the layout, so this overrides the repositioning it
        -- does when frames change sizes
        local af = f.Auras.frames.core_dynamic
        af:SetPoint(
            'BOTTOMLEFT',f.bg,'TOPLEFT',
            floor((f.bg:GetWidth() - af.__width) / 2),
            15+AURAS_VERTICAL_OFFSET
        )
    end
end

function mod:Initialise()
    print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')

    self:AddCallback('Auras','PostCreateAuraButton',PostCreateAuraButton)

    if AURAS_VERTICAL_OFFSET then
        self:RegisterMessage('Show')
    end

    if CD_TEXT_SIZE_MOD or COUNT_TEXT_SIZE_MOD then
        -- modify text size by "overloading" the SetFont helper in core
        local old_sf = core.AurasButton_SetFont
        core.AurasButton_SetFont = function(button)
            old_sf(button)

            local f,s,t = button.cd:GetFont()
            button.cd:SetFont(f,s+CD_TEXT_SIZE_MOD,t)

            f,s,t = button.count:GetFont()
            button.count:SetFont(f,s+COUNT_TEXT_SIZE_MOD,t)
        end
    end
end
