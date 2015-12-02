
local DEFAULT_AGGRO_RANGE = 300
local DEFAULT_RESPAWN_TIME = 20
local DEFAULT_LEASH_RANGE = 1000

local leashRange = DEFAULT_LEASH_RANGE
local spawnPos = 0
local name = 0
local tick = 0


function SpawnAIInit()
	local needsSpawn = false
	if thisEntity:GetAbsOrigin().x == 0 and thisEntity:GetAbsOrigin().y == 0 and thisEntity:GetAbsOrigin().z == 0 then
		needsSpawn = true
		spawnPos = Vector(0,0,0)
	else
		spawnPos = thisEntity:GetAbsOrigin()
	end
	name = thisEntity:GetUnitName()
	thisEntity:SetContextThink( "Periodic", Periodic, needsSpawn and 0.03 or math.random())
end

function Periodic()
	if spawnPos == Vector(0,0,0) then
		spawnPos = thisEntity:GetAbsOrigin()
	end
	name = thisEntity:GetUnitName()
	if thisEntity:IsAlive() then
		if thisEntity:GetAggroTarget() == nil or (spawnPos - thisEntity:GetAbsOrigin()):Length() > leashRange then
			thisEntity:MoveToPosition(spawnPos)
		end
	else
		tick = tick + 1
		if tick > DEFAULT_RESPAWN_TIME then
			CreateUnitByName(name, spawnPos, true, nil, nil, DOTA_TEAM_NEUTRALS) 
			return nil
		end
	end
	return 1
end
SpawnAIInit()