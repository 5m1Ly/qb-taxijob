RegisterNetEvent('qb-taxijob:client:requestcab', function()
    Taxi.Services.Garage.Open()
end)

RegisterNetEvent("qb-taxi:client:TakeVehicle", function(data)
    Taxi.Services.Garage.SpawnVehicle(data.model)
end)
