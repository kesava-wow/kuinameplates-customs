-- automagically disable friendly nameplates upon entering an instance
--
-- problems include and are probably not limited to:
-- * gets confused if you set the combat toggle dropdowns to anything other
--   than "do nothing"
-- * gets confused if another addon or bossmods toggles friendly nameplates
--   (for whatever reason that might be)
-- * won't reset the cvar to the correct value if you reload the UI after it
--   disables friendlies (they'll stay disabled upon leaving the instance)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('HideFriendlyInInstances',101)

local was_in_instance
function mod:PLAYER_ENTERING_WORLD()
    if IsInInstance() then
        if not was_in_instance and
           not GetCVarBool('nameplateShowFriends')
        then
            return
        end

        SetCVar('nameplateShowFriends',false)
        was_in_instance = true
    elseif was_in_instance then
        SetCVar('nameplateShowFriends',true)
        was_in_instance = nil
    end
end
function mod:Initialise()
    print('|cff9966ffKui Nameplates|r: |cffff6666You are using Kui_Nameplates_Custom which is not updated by the Curse package.|r If you experience errors, check the repository on GitHub for updates.')
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end
