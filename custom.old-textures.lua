local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('OldTextures',101,3)
if not mod then return end

local OLD_TARGET_ARROWS = true
local OLD_THREAT_BRACKETS = true

local TARGET_ARROW = 'interface/addons/kui_nameplates_oldtextures/target-arrow'
local THREAT_BRACKET = 'interface/addons/kui_nameplates_oldtextures/threat-bracket'
local TB_POINTS = {
    { 'BOTTOMLEFT', 'TOPLEFT', 0, 1 },
    { 'BOTTOMRIGHT', 'TOPRIGHT', 0, 1 },
    { 'TOPLEFT', 'BOTTOMLEFT', 0, -1 },
    { 'TOPRIGHT', 'BOTTOMRIGHT', 0, -1 },
}
-- show ########################################################################
function mod:Show(frame)
    if OLD_TARGET_ARROWS and frame.TargetArrows and not frame.TargetArrows._old_textures then
        frame.TargetArrows.r:SetBlendMode('BLEND')
        frame.TargetArrows.r:SetTexture(TARGET_ARROW)

        frame.TargetArrows.l:SetBlendMode('BLEND')
        frame.TargetArrows.l:SetTexture(TARGET_ARROW)

        frame.TargetArrows._old_textures = true
    end
    if OLD_THREAT_BRACKETS and frame.ThreatBrackets and not frame.ThreatBrackets._old_textures then
        for i,texture in ipairs(frame.ThreatBrackets.textures) do
            texture:SetBlendMode('BLEND')
            texture:SetTexture(THREAT_BRACKET)
            texture:ClearAllPoints()
            texture:SetPoint(unpack(TB_POINTS[i]))
        end

        frame.ThreatBrackets._old_textures = true
    end
end
-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Show')
end
