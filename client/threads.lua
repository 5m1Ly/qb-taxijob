CreateThread(function()
    Taxi.Methods.CreateBlip(
        "Downtown Cab Co.",
        198,
        4,
        0.6,
        true,
        Config.garage.location.x,
        Config.garage.location.y,
        Config.garage.location.z
    )
end)

CreateThread(function()
    while true do
        Wait(2000)
        if Taxi.mission.active then
            Taxi.Services.Meter.CalculateFareAmount()
        end
    end
end)

CreateThread(function()
    while true do
        if not Config.UseTarget then
            local inRange = false
            if LocalPlayer.state.isLoggedIn then
                local Player = QBCore.Functions.GetPlayerData()
                if Player.job.name == "taxi" then
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    local garage = Config.garage.location
                    local vehDist = #(pos - vector3(garage.x, garage.y, garage.z))
                    if vehDist < 30 then
                        inRange = true
                        local rgb = Config.colors.rgb
                        DrawMarker(
                            36, -- type
                            garage.x, garage.y, garage.z, -- pos
                            0.0, 0.0, 0.0, -- dir
                            0.0, 0.0, 0.0, -- rot
                            0.6, 1.0, 0.6, -- scale
                            rgb[1], rgb[2], rgb[3], 200, -- color
                            false, false, false, true, false, false, false
                        )
                        if vehDist < 1.5 then
                            if Taxi.Methods.IsPlayerInsideTaxi() then
                                Taxi.Methods.DrawText3D(garage.x, garage.y, garage.z + 0.3, Lang:t("info.vehicle_parking"))
                                if IsControlJustReleased(0, 38) then
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                    end
                                end
                            else
                                Taxi.Methods.DrawText3D(garage.x, garage.y, garage.z + 0.3, Lang:t("info.job_vehicles"))
                                if IsControlJustReleased(0, 38) then
                                    Taxi.Services.Garage.Open()
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                Wait(3000)
            end
        end
        Wait(3)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if Taxi.player.job.name == "taxi" and Taxi.player.job.isboss and not Config.UseTarget then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - Config.BossMenu) < 2.0 then
                sleep = 7
                Taxi.Methods.DrawText3D(Config.BossMenu.x, Config.BossMenu.y,Config.BossMenu.z, "~g~[E]~w~ - Boss Menu")
                if IsControlJustReleased(0, 38) then
                   TriggerEvent('qb-bossmenu:client:OpenMenu')
                end
            end
        end
        Wait(sleep)
    end
end)
