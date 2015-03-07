--[[
-- Kui_Nameplates
-- By Kesava at curse.com
--
-- changes colour of health bars based on health percentage
]]
local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('LowHealthColours', 'AceEvent-3.0')

local LOW_HEALTH_COLOR = { 1, .3, .5 }
local PRIORITY = 5 -- set above 10 to override tank mode colour

local function OnHealthValueChanged(oldHealth,current)
    local frame = oldHealth:GetParent():GetParent().kui
    local percent = frame.health.percent

    if percent <= 20 then
        frame:SetHealthColour(PRIORITY, unpack(LOW_HEALTH_COLOR))
        frame.stuckLowHealth = true
    elseif frame.stuckLowHealth then
        frame:SetHealthColour(false)
        frame.stuckLowHealth = nil
    end
end

---------------------------------------------------------------------- Create --
function mod:PostCreate(msg, frame)
    frame.oldHealth:HookScript('OnValueChanged',OnHealthValueChanged)
end

function mod:GetOptions()
    return {
        enabled = {
            name = 'Colour health bars at low health',
            desc = 'Change the colour of low health units\' health bars',
            type = 'toggle',
            width = 'double',
            order = 10
        }
    }
end

function mod:OnInitialize()
    self.db = addon.db:RegisterNamespace(self.moduleName, {
        profile = {
            enabled = true
        }
    })

    addon:InitModuleOptions(self)
    self:SetEnabledState(self.db.profile.enabled)
end

function mod:OnEnable()
    self:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')
end
function mod:OnDisable()
    self:UnregisterMessage('KuiNameplates_PostCreate', 'PostCreate')
end
