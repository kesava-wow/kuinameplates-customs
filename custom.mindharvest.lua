--[[
-- custom.lua for Kui_Nameplates
-- By Kesava at curse.com
-- mind harvest module test
]]
local addon = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = addon:NewModule('CustomInjector', 'AceEvent-3.0')

local MIND_HARVEST_GLYPH_ID = 1202
local MIND_HARVEST_KNOWN

local MIND_HARVEST_USED = {}
local usedIndex = {}

function mod:COMBAT_LOG_EVENT_UNFILTERED(event,...)
    local sourceGUID = select(4,...)
    if sourceGUID ~= UnitGUID('player') then return end

    local log_event = select(2,...)
    if log_event ~= 'SPELL_DAMAGE' then return end

    local spellID = select(12,...)
    if spellID ~= 8092 then return end

    local targetGUID = select(8,...)
    if not MIND_HARVEST_USED[targetGUID] then
        MIND_HARVEST_USED[targetGUID] = true
        tinsert(usedIndex, targetGUID)

        -- purge index over 100
        if #usedIndex > 100 then
            MIND_HARVEST_USED[tremove(usedIndex, 1)] = nil
        end

        local frame = addon:GetNameplate(targetGUID, nil)
        if frame then
            self:HideNotifier(nil, frame)
        end
    end
end

function mod:PLAYER_ENTERING_WORLD()
    self:ScanGlyphs()
end
function mod:GLYPH_ADDED()
    self:ScanGlyphs()
end
function mod:GLYPH_UPDATED()
    self:ScanGlyphs()
end

function mod:ScanGlyphs()
    for i=1,GetNumGlyphSockets() do
        local glyph_id = select(6,GetGlyphSocketInfo(i))
        if glyph_id and glyph_id == MIND_HARVEST_GLYPH_ID then
            MIND_HARVEST_KNOWN = true
            return
        end
    end

    MIND_HARVEST_KNOWN = false
end

function mod:CreateNotifier(msg, frame)
    frame.mindharvest = frame.overlay:CreateTexture(nil, 'ARTWORK')
    local mh = frame.mindharvest
    mh:SetDrawLayer('ARTWORK',2)

    mh:SetTexture('Interface\\AddOns\\Kui_Nameplates\\media\\combopoint-round')
    mh:SetSize(9,9)
    mh:SetVertexColor(1,.4,1)
    mh:Hide()

    mh:SetPoint('LEFT', frame.overlay, 'RIGHT', 2, 0)
end

function mod:HideNotifier(msg, frame)
    frame.mindharvest:Hide()
end

function mod:GUIDStored(msg, f, unit)
    if f.friend then return end
    if MIND_HARVEST_KNOWN and not MIND_HARVEST_USED[f.guid] then
        f.mindharvest:Show()
    end
end

function mod:OnInitialize()
    if select(2,UnitClass('player')) == 'PRIEST' then
        self:RegisterMessage('KuiNameplates_PostCreate', 'CreateNotifier')
        self:RegisterMessage('KuiNameplates_PostHide', 'HideNotifier')
        self:RegisterMessage('KuiNameplates_GUIDStored', 'GUIDStored')

        self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        self:RegisterEvent('PLAYER_ENTERING_WORLD')
        self:RegisterEvent('GLYPH_ADDED')
        self:RegisterEvent('GLYPH_UPDATED')
    end
end

