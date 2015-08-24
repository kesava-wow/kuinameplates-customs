-- Kui_Nameplates_OffTankThreat
-- By Michael

local addon = LibStub('AceAddon-3.0'):GetAddon('KuiNameplates')
local mod = addon:NewModule('OffTankThreat', 'AceEvent-3.0')

mod.uiName = 'Threat offtank'

local next = next
local unpack = unpack
local UnitGUID = UnitGUID
local UnitIsUnit = UnitIsUnit
local UnitThreatSituation = UnitThreatSituation
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local threat_active
local offthreats = {}
local offtanks_units = {} -- guid => unit
local offtanks_guids = {} -- unit => guid

-- Configuration interface
function mod:GetOptions()
	return {
		offtankcolour = {
			name = 'Off Tank colour',
			desc = 'The bar colour to use when another tank has threat.',
			type = 'color',
			order = 1
		},
	}
end

-- Module initialization
function mod:OnInitialize()
	self.db = addon.db:RegisterNamespace(self.moduleName, {
		profile = {	offtankcolour = { 0, .75, 1} }
	})
	addon:InitModuleOptions(self)
	mod:SetEnabledState(true)
end

--- TankMode:Update() Hook, because we need to enable/disable our stuff just after TankMode is enabled/disabled
do 
	local TankMode = addon:GetModule('TankMode') 
	local prev = TankMode.Update
	TankMode.Update = function(self)
		prev(self)
		if addon.TankMode then
			mod:RegisterEvent('GROUP_ROSTER_UPDATE', 'UpdateOffTanks')
			mod:RegisterEvent('PARTY_MEMBERS_CHANGED', 'UpdateOffTanks')
			mod:RegisterEvent('PLAYER_REGEN_ENABLED')
			mod:RegisterEvent('PLAYER_REGEN_DISABLED')
			mod:UpdateOffTanks()
		else
			mod:UnregisterEvent('GROUP_ROSTER_UPDATE')
			mod:UnregisterEvent('PARTY_MEMBERS_CHANGED')	
			mod:UnregisterEvent('PLAYER_REGEN_ENABLED')
			mod:UnregisterEvent('PLAYER_REGEN_DISABLED')
			if threat_active then mod:PLAYER_REGEN_ENABLED() end
		end	
	end
end

-- Enable threat detection/colorization code when combat start
function mod:PLAYER_REGEN_DISABLED()
	if next(offtanks_units) then
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE')
		threat_active = true
	end	
end

-- Disable threat detection/colorization code when combat end
function mod:PLAYER_REGEN_ENABLED()
	wipe(offthreats)
	self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	self:UnregisterEvent('UNIT_THREAT_SITUATION_UPDATE')
	threat_active = false
end

-- Looking for offtanks in party or raid
do
	local group_units = { [true] = {}, [false] = { 'player', 'party1', 'party2', 'party3', 'party4' } }
	for i=1,MAX_RAID_MEMBERS do table.insert( group_units[true], 'raid'..i ) end
	function mod:UpdateOffTanks()
		wipe(offtanks_units)
		wipe(offtanks_guids)
		local m = GetNumGroupMembers()
		if m>1 then
			local units = group_units[IsInRaid()]
			for i=1,m do
				local unit = units[i]
				if (UnitGroupRolesAssigned(unit) == 'TANK') and (not UnitIsUnit(unit,'player')) then
					local guid = UnitGUID(unit)
					offtanks_units[ guid ] = unit
					offtanks_guids[ unit ] = guid
				end
			end
		end
	end
end

-- Heuristic threat detection using combat log attacks
do
	local combat_events = { 
		SPELL_DAMAGE = true, SPELL_MISSED = true, 
		SWING_DAMAGE = true, SWING_MISSED = true, 
		RANGE_DAMAGE = true, RANGE_MISSED = true,
	}
	function mod:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, _, srcGUID, _, _, _, dstGUID)
		if combat_events[event] then
			offthreats[srcGUID or 0] = offtanks_units[dstGUID or 0]
		end
	end
end

-- More heuristic threat detection 
do
	local targets = setmetatable( {}, { __index = function(t,k) local v = k..'target'; t[k] = v; return v end } )
	function mod:UNIT_THREAT_SITUATION_UPDATE(_, unit)
		if unit then
			local target = targets[unit]
			local guid = UnitGUID(target)
			if guid and (UnitThreatSituation(unit, target) or 0)>1 then
				offthreats[guid] = offtanks_guids[unit]
			end
		end	
	end
end

--- mod:PostCreate() & OffTank threat colorization code 
do
	local units= { 'mouseover', 'target', 'boss1', 'boss2', 'boss3', 'boss4' }
	local function FindUnit(guid)
		for i=1,#units do
			local unit = units[i]
			if guid == UnitGUID(unit) then
				return unit
			end
		end
	end
	local prevUpdate
	local function Update(self)
		prevUpdate(self)
		if threat_active and (not self.friend) then
			local guid = self.guid
			if guid and (not self.hasThreat) then
				local punit = FindUnit(guid)
				if punit then -- Check offtanks threats on the unit
					for unit in next,offtanks_guids do
						if (UnitThreatSituation(unit, punit) or 0)>1 then
							self:SetHealthColour(10, unpack(mod.db.profile.offtankcolour) )	
							return
						end
					end
				elseif offthreats[guid] then -- No unit for this guid, using combatlog attack info
					self:SetHealthColour(10, unpack(mod.db.profile.offtankcolour) )
				end
			end
		end
	end
	function mod:PostCreate(msg, frame)
		-- Hook to inject code in Kui_Nameplates 
		if not prevUpdate then prevUpdate = frame.UpdateFrameCritical	end	
		frame.UpdateFrameCritical = Update
	end
	mod:RegisterMessage('KuiNameplates_PostCreate', 'PostCreate')	
end