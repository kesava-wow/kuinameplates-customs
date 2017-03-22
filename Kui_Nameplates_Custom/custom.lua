--[[
-- Custom code injector template for Kui_Nameplates_Core
-- By Kesava at curse.com
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('CustomInjector',101)
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
    print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')

    self:RegisterMessage('Create')
    self:RegisterMessage('Show')
    self:RegisterMessage('Hide')
end
