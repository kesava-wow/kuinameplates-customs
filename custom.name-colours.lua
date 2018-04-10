-- change name colours in bar mode (NOT NAME-ONLY)
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('NameColourMods',101)
local plugin_hb

-- un/comment out any setting to un/ignore those frames

local PLAYER_FRIENDLY = { .6,.7,1 } -- class coloured by default
local PLAYER_HOSTILE = { 1,0,0 } -- white by default
--local NPCS_INHERIT_REACTION = true -- nil by default

-- below options only relevant if MOBS_INHERIT_REACTION is nil;
local HOSTILE_NPC = { 1,.7,.6 } -- light red
local NEUTRAL_NPC = { 1,.9,.7 } -- light yellow
local FRIENDLY_NPC = { .8,1,.8 } -- light green

-- hooks #######################################################################
local function UpdateNameText(f)
    f:namecolours_UpdateNameText()
    if f.IN_NAMEONLY then return end

    if UnitIsPlayer(f.unit) then
        -- players
        if PLAYER_FRIENDLY and f.state.friend then
            f.NameText:SetTextColor(unpack(PLAYER_FRIENDLY))
        elseif PLAYER_HOSTILE and not f.state.friend then
            f.NameText:SetTextColor(unpack(PLAYER_HOSTILE))
        end
    else
        -- NPCs
        local ct
        if not UnitCanAttack('player',f.unit) and f.state.reaction >= 4 then
            ct = NPCS_INHERIT_REACTION and plugin_hb.colours.friendly or FRIENDLY_NPC
        else
            if f.state.reaction == 4 then
                ct = NPCS_INHERIT_REACTION and plugin_hb.colours.neutral or NEUTRAL_NPC
            else
                ct = NPCS_INHERIT_REACTION and plugin_hb.colours.hated or HOSTILE_NPC
            end
        end

        if ct then
            f.NameText:SetTextColor(unpack(ct))
        end
    end
end
function mod:UpdateNameTextOverload(f)
    f.namecolours_UpdateNameText = f.UpdateNameText
    f.UpdateNameText = UpdateNameText
end
-- initialise ##################################################################
function mod:Initialise()
    plugin_hb = addon:GetPlugin('HealthBar')
    self:RegisterMessage('Create','UpdateNameTextOverload')
end
