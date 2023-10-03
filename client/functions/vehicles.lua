function Taxi.Methods.IsPlayerDriving()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

function Taxi.Methods.EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}
	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end
	for k, entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))
		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
		end
	end
	return nearbyEntities
end

function Taxi.Methods.GetVehiclesInArea(coords, maxDistance) -- Vehicle inspection in designated area
	return Taxi.Methods.EnumerateEntitiesWithinDistance(GetGamePool('CVehicle'), false, coords, maxDistance)
end

function Taxi.Methods.IsSpawnPointClear(coords, maxDistance) -- Check the spawn point to see if it's empty or not:
	return #Taxi.Methods.GetVehiclesInArea(coords, maxDistance) == 0
end

function Taxi.Methods.IsPlayerInsideTaxi()
    local ped = PlayerPedId()
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false
    for i = 1, #Config.garage.vehicles, 1 do
        if veh == GetHashKey(Config.garage.vehicles[i].model) then
            retval = true
        end
    end
    if veh == GetHashKey("dynasty") then
        retval = true
    end
    return retval
end

function Taxi.Methods.GeneratePlate()
    return "TAXI" .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)
end

function Taxi.Methods.SpawnVehicle(model, location)
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local vehicle = NetToVeh(netId)
        local plate = Taxi.Methods.GeneratePlate()
        SetVehicleNumberPlateText(vehicle, plate)
        exports['ps-fuel']:SetFuel(vehicle, 100.0)
        Taxi.Services.Garage.Close()
        SetEntityHeading(vehicle, location.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
        SetVehicleEngineOn(vehicle, true, true)
    end, model, location.xyz, true)
end
