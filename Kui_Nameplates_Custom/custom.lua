--[[
-- Custom code injector template for Kui_Nameplates_Core
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('CustomInjector',101)
if not mod then return end

-- create ######################################################################
function mod:Create(frame)
    -- Place code to be performed after a frame is created here.
end

-- show ########################################################################
function mod:Show(frame)
    -- Place code to be performed after a frame is shown here.
end

-- hide ########################################################################
function mod:Hide(frame)
    -- Place code to be performed after a frame is hidden here.
end

-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Create')
    self:RegisterMessage('Show')
    self:RegisterMessage('Hide')
end
