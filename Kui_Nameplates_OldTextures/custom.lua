local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('OldTextures',101,4)
if not mod then return end
-- configuration ###############################################################
local OLD_TARGET_ARROWS = true
local OLD_THREAT_BRACKETS = true
local ARROWS_INSET = 3
-- end configuration ###########################################################
local TARGET_ARROW = 'interface/addons/kui_nameplates_oldtextures/target-arrow'
local THREAT_BRACKET = 'interface/addons/kui_nameplates_oldtextures/threat-bracket'
local TB_POINTS = {
    { 'BOTTOMLEFT', 'TOPLEFT', 0, 1.3 },
    { 'BOTTOMRIGHT', 'TOPRIGHT', 0, 1.3 },
    { 'TOPLEFT', 'BOTTOMLEFT', 0, -1.5 },
    { 'TOPRIGHT', 'BOTTOMRIGHT', 0, -1.5 },
}
-- local functions #############################################################
local function ThreatBrackets_SetSize(self,size)
    for k,v in ipairs(self.textures) do
        v:SetSize(size*2,size)

        local p = TB_POINTS[k]
        local x_offset = floor((size * 2) * .28125) - 1
        if k % 2 == 1 then
            x_offset = -x_offset
        end
        v:SetPoint(p[1],v:GetParent().bg,p[2],x_offset,p[4])
    end
end
local function Arrows_UpdatePosition(self)
    local inset = ARROWS_INSET + (self.l:GetHeight() * .12)
    self.l:SetPoint('RIGHT',self.parent.bg,'LEFT',inset,-1)
    self.r:SetPoint('LEFT',self.parent.bg,'RIGHT',-inset,-1)
end
-- show ########################################################################
function mod:Show(frame)
    if OLD_TARGET_ARROWS and frame.TargetArrows then
        if not frame.TargetArrows._old_textures then
            frame.TargetArrows.l:SetBlendMode('BLEND')
            frame.TargetArrows.l:SetTexture(TARGET_ARROW)
            frame.TargetArrows.l:SetTexCoord(0,.72,0,1)

            frame.TargetArrows.r:SetBlendMode('BLEND')
            frame.TargetArrows.r:SetTexture(TARGET_ARROW)
            frame.TargetArrows.r:SetTexCoord(.72,0,0,1)

            frame.TargetArrows.UpdatePosition = Arrows_UpdatePosition
            frame.TargetArrows._old_textures = true
        end

        frame.TargetArrows.l:SetWidth(frame.TargetArrows.l:GetHeight()*.72)
        frame.TargetArrows.r:SetWidth(frame.TargetArrows.r:GetHeight()*.72)
    end
    if OLD_THREAT_BRACKETS and frame.ThreatBrackets then
        if not frame.ThreatBrackets._old_textures then
            for i,texture in ipairs(frame.ThreatBrackets.textures) do
                texture:SetBlendMode('BLEND')
                texture:SetTexture(THREAT_BRACKET)
                texture:ClearAllPoints()
            end

            frame.ThreatBrackets.SetSize = ThreatBrackets_SetSize
            frame.ThreatBrackets._old_textures = true
        end
    end
end
-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Show')
end
