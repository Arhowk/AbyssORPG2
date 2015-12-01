
local LOOT_LAST_TIME = 25
local INITIAL_VELOCITY = 22
local VELOCITY_TICK = 0.8

function DeleteItem(item)
	if not item then return end
	if item:GetContainer() then UTIL_RemoveImmediate(item:GetContainer()) end
	UTIL_RemoveImmediate(item) 
end

function _SwirlDown(item)

	if item:GetOwner() then
		return
	end

	local ip = item
	item = item:GetContainer()
	item.SwirlVelocity = (item.SwirlVelocity or (INITIAL_VELOCITY + RandomInt(0, 6) + VELOCITY_TICK)) - VELOCITY_TICK
	item:SetAbsOrigin(Vector(item:GetAbsOrigin().x, item:GetAbsOrigin().y, item:GetAbsOrigin().z + item.SwirlVelocity))
	if item.SwirlVelocity < 0 then
		local theta = math.atan2(item:GetForwardVector().y, item:GetForwardVector().x)
		theta = theta + item.SwirlVelocity / 55
		item:SetForwardVector(Vector(math.cos(theta), math.sin(theta, 0)))
	end

    if item.SwirlVelocity > -40 then
		return 0.01
	else
		DeleteItem(ip)
	end
end

function DropLoot(itemType, loc)
	if not itemType then
		print("[ITEM DROP ERROR] Invalid item type", itemType)
		return
	end

	local newItem = CreateItem(itemType,nil,nil)
	if newItem then
		newItem:SetPurchaseTime( 0 )
		local drop = CreateItemOnPositionSync( loc , newItem)
		if drop then
			drop:SetContainedItem( newItem )
			newItem:LaunchLoot( false, 100, 0.35, loc+ RandomVector( RandomFloat( 50, 150 ) ) )
		else
			DeleteItem(item)
			print("[ITEM DROP ERROR] Invalid item type", itemType)
			return
		end

		Timers:CreateTimer(LOOT_LAST_TIME, function()
			if not (newItem:GetContainer():GetAbsOrigin().x == 0 and newItem:GetContainer():GetAbsOrigin().y == 0 and newItem:GetContainer():GetAbsOrigin().z == 0) then
				Timers:CreateTimer(0.01, function() return _SwirlDown(newItem) end)
			end
		end)
	else
		print("[ITEM DROP ERROR] Invalid item type", itemType)
	end
	return newItem
end