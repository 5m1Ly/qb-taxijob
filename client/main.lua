RegisterNetEvent('qb-taxijob:client:requestcab', function()
    Taxi.Services.Garage.Open()
end)

RegisterNetEvent("qb-taxi:client:TakeVehicle", function(data)
    local spawn = Taxi.Services.Garage.GetSpawnPoint()
    if spawn and Taxi.Methods.IsSpawnPointClear(vector3(spawn.x, spawn.y, spawn.z), 2.0) then
        Taxi.Methods.SpawnVehicle(data.model, spawn)
    else
        Taxi.Error(Lang:t("error.no_spawn_point"))
    end
end)
