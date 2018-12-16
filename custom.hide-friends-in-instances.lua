-- automagically disable friendly nameplates upon entering an instance
--
-- problems include and are probably not limited to:
-- * gets confused if you set the combat toggle dropdowns to anything other
--   than "do nothing"
-- * gets confused if another addon or bossmods toggles friendly nameplates
--   (for whatever reason that might be)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore

local mod = addon:NewPlugin('HideFriendlyInInstances',101,4)
if not mod then return end

function mod:PLAYER_ENTERING_WORLD()
    local was_in_instance = KuiNameplatesCoreCharacterSaved.HideFriendlyInInstances_hidden
    local in_instance,instance_type = IsInInstance()
    if  in_instance and (
        instance_type == 'party' or
        instance_type == 'raid' or
        instance_type == 'scenario')
    then
        -- in instance;
        if not was_in_instance and
           not GetCVarBool('nameplateShowFriends')
        then
            -- don't do anything if they're already disabled
            return
        end

        SetCVar('nameplateShowFriends',false)
        KuiNameplatesCoreCharacterSaved.HideFriendlyInInstances_hidden = true
    elseif was_in_instance then
        -- out of instance; unhide
        SetCVar('nameplateShowFriends',true)
        KuiNameplatesCoreCharacterSaved.HideFriendlyInInstances_hidden = nil
    end
end
function mod:Initialise()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end
