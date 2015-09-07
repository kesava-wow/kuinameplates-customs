local kn = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = kn:NewModule('CustomInjector', 'AceEvent-3.0')
local function abbreviated_SetName(self)
    self:orig_SetName()

    if not self.name.text:match(' %(%*%)$') then
        self.name.abbreviated = self.name.text:gsub('(%S+) ', function(t)
            return t:sub(1,1)..'.'
        end)
        self.name:SetText(self.name.abbreviated)
    end
end
function mod:PostCreate(msg,f)
    f.orig_SetName = f.SetName
    f.SetName = abbreviated_SetName
end
mod:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')
