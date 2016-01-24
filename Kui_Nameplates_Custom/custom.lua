--[[
-- Kui_Nameplates
-- By Kesava at curse.com
-- Some examples of simple modifications can be found at the following URL:
-- https://github.com/kesava-wow/kuinameplates-customs
--
-- Other possible messages include:
-- _PostTarget  - fired when a nameplate becomes the player's target.
-- _GuidStored  - fired when a nameplate's GUID becomes available, through the
--                player targeting or mousing over its frame.
-- _GuidAssumed - fired when a nameplate with an assumed unique name is
--                assigned a GUID.
--
-- To perform some action OnUpdate, you can either overload the frame's
-- :UpdateFrame script, or hook OnUpdate as normal.
-- (as per layout.lua, addon:InitFrame)
--]]
local addon = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = addon:NewModule('CustomInjector', addon.Prototype, 'AceEvent-3.0')
---------------------------------------------------------------------- Create --
function mod:PostCreate(msg, frame)
    -- Place code to be performed after a frame is created here.
end
------------------------------------------------------------------------ Show --
function mod:PostShow(msg, frame)
    -- Place code to be performed after a frame is shown here.
end
------------------------------------------------------------------------ Hide --
function mod:PostHide(msg, frame)
    -- Place code to be performed after a frame is hidden here.
end
-------------------------------------------------------------------- Register --
mod:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')
mod:RegisterMessage('KuiNameplates_PostShow', 'PostShow')
mod:RegisterMessage('KuiNameplates_PostHide', 'PostHide')
