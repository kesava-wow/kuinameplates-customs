--[[
-- Kui_Nameplates
-- By Kesava at curse.com
--
-- changes colour of health bars based on health percentage
]]
local addon = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = addon:NewModule('LowHealthColours', 'AceEvent-3.0')

mod.uiName = 'Low health colour'

local LOW_HEALTH_COLOR, PRIORITY

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

function mod:PostCreate(msg, frame)
    frame.oldHealth:HookScript('OnValueChanged',OnHealthValueChanged)
end

mod.configChangedFuncs = { runOnce = {} }
mod.configChangedFuncs.runOnce.colour = function(v)
    LOW_HEALTH_COLOR = v
end
mod.configChangedFuncs.runOnce.priority = function(v)
    PRIORITY = v and 15 or 5
end

function mod:GetOptions()
    return {
        enabled = {
            name = 'Colour health bars at low health',
            desc = 'Change the colour of low health units\' health bars',
            type = 'toggle',
            width = 'double',
            order = 10
        },
        priority = {
            name = 'Override tank mode',
            desc = 'When using tank mode, allow the low health colour to override tank mode colouring',
            type = 'toggle',
            order = 20
        },
        colour = {
            name = 'Low health colour',
            desc = 'The colour to use',
            type = 'color',
            order = 30
        }
    }
end

function mod:OnInitialize()
    self.db = addon.db:RegisterNamespace(self.moduleName, {
        profile = {
            enabled = true,
            priority = false,
            colour = { 1, 1, .85 }
        }
    })

    addon:InitModuleOptions(self)

    LOW_HEALTH_COLOR = self.db.profile.colour
    PRIORITY = self.db.profile.priority and 15 or 5

    self:SetEnabledState(self.db.profile.enabled)
end

function mod:OnEnable()
    self:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')
end
function mod:OnDisable()
    self:UnregisterMessage('KuiNameplates_PostCreate', 'PostCreate')
end

