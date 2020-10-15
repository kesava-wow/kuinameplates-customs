local AURAS = {
  [980] = true,
}
-- below lines should be left alone ############################################
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('HideAuraCount',101,5)
if not mod then return end

local function PostDisplayAuraButton(frame,button)
    if AURAS[button.spellid] then
        button.count:Hide()
    end
end

function mod:Initialise()
    self:AddCallback('Auras','PostDisplayAuraButton',PostDisplayAuraButton)
end
