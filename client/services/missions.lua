local function ResetNpcTask()
    Taxi.mission.current = nil
    Taxi.mission.last = nil
    Taxi.mission.blip = nil
    Taxi.mission.active = false
    Taxi.mission.countdown = 180

    Taxi.mission.npc.current = nil
    Taxi.mission.npc.last = nil
    Taxi.mission.npc.blip = nil

    Taxi.mission.npc.pickup = nil
    Taxi.mission.npc.pickup = false
    Taxi.mission.npc.pickup = false

    Taxi.mission.npc.dropoff = nil
    Taxi.mission.npc.dropoff = false
end

local function ItsJustTheTipBaby()
    local found = false
    for level, info in next, Config.bonus.levels do
        exports["mz-skills"]:CheckSkill("Besturen", info.experiance, function(hasSkillLevel)
            if not hasSkillLevel then return end
            found = true
            TriggerServerEvent('qb-taxijob:server:its-just-the-tip-baby', level)
            Wait(1500)
            Taxi.Info(Config.bonus.messages[math.random(1, #Config.bonus.messages)])
        end)
        if found then break end
    end
end

local function GetDeliveryLocation()

    Taxi.mission.current = math.random(1, #Config.missions.dropoff)

    if Taxi.mission.last ~= nil then
        while Taxi.mission.last == Taxi.mission.current do
            Taxi.mission.current = math.random(1, #Config.missions.dropoff)
        end
    end

    if Taxi.mission.blip ~= nil then
        RemoveBlip(Taxi.mission.blip)
    end

    local location = Config.missions.dropoff[Taxi.mission.current]

    Taxi.mission.blip = AddBlipForCoord(location.x, location.y, location.z)

    SetBlipColour(Taxi.mission.blip, 3)
    SetBlipRoute(Taxi.mission.blip, true)
    SetBlipRouteColour(Taxi.mission.blip, 3)

    Taxi.mission.last = Taxi.mission.current

    if not Config.UseTarget then -- added checks to disable distance checking if polyzone option is used
        CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = #(pos - vector3(location.x, location.y, location.z))
                if dist < 20 then
                    DrawMarker(2, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 5 then
                        Taxi.Methods.DrawText3D(location.x, location.y, location.z, Lang:t("info.drop_off_npc"))
                        if IsControlJustPressed(0, 38) then
                            local veh = GetVehiclePedIsIn(ped, 0)
                            TaskLeaveVehicle(Taxi.mission.npc.ped, veh, 0)
                            SetEntityAsMissionEntity(Taxi.mission.npc.ped, false, true)
                            SetEntityAsNoLongerNeeded(Taxi.mission.npc.ped)
                            local targetCoords = Config.missions.pickup[Taxi.mission.npc.last]
                            TaskGoStraightToCoord(Taxi.mission.npc.ped, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                            SendNUIMessage({
                                action = "toggleMeter"
                            })
                            TriggerServerEvent('qb-taxi:server:NpcPay', Taxi.meter.data.currentFare)
                            Taxi.meter.active = false
                            SendNUIMessage({
                                action = "resetMeter"
                            })
                            Taxi.Success(Lang:t("info.person_was_dropped_off"))
                            if Taxi.mission.blip ~= nil then
                                RemoveBlip(Taxi.mission.blip)
                            end
                            Wait(200)
                            if Config.mzskills then
                                local BetterXP = math.random(Config.DriverXPlow, Config.DriverXPhigh)
                                local xpmultiple = math.random(1, 4)
                                if xpmultiple >= 3 then
                                    chance = BetterXP
                                elseif xpmultiple < 3 then
                                    chance = Config.DriverXPlow
                                end
                                exports["mz-skills"]:UpdateSkill("Besturen", chance)
                                Wait(1000)
                                if Config.bonus.chance >= math.random(1, 100) then
                                    -- Skill check call for config.menu prices on items
                                    ItsJustTheTipBaby()
                                end
                            end
                            local RemovePed = function(p)
                                SetTimeout(60000, function()
                                    DeletePed(p)
                                end)
                            end
                            RemovePed(Taxi.mission.npc.ped)
                            ResetNpcTask()
                            break
                        end
                    end
                end
                Wait(1)
            end
        end)
    end
end

-- Events
RegisterNetEvent('qb-taxi:client:DoTaxiNpc', function()
    if Taxi.Methods.IsPlayerInsideTaxi() then
        if not Taxi.mission.active then
            TriggerEvent('qb-taxi:client:Cooldown')
            Taxi.mission.npc.current = math.random(1, #Config.missions.pickup)
            if Taxi.mission.npc.last ~= nil then
                while Taxi.mission.npc.last ~= Taxi.mission.npc.current do
                    Taxi.mission.npc.current = math.random(1, #Config.missions.pickup)
                end
            end

            local peds = Config.missions.pedestrians
            local gender = math.random(1, 2)
            local model = GetHashKey(peds[gender][math.random(1, #peds[gender])])

            RequestModel(model)

            while not HasModelLoaded(model) do
                Wait(0)
            end

            local location = Config.missions.pickup[Taxi.mission.npc.current]

            Taxi.mission.npc.ped = CreatePed(3, model, location.x, location.y, location.z - 0.98, location.w, false, true)

            PlaceObjectOnGroundProperly(Taxi.mission.npc.ped)
            FreezeEntityPosition(Taxi.mission.npc.ped, true)

            if Taxi.mission.npc.blip ~= nil then
                RemoveBlip(Taxi.mission.npc.blip)
            end
            Taxi.Success(Lang:t("info.npc_on_gps"))
           -- added checks to disable distance checking if polyzone option is used
            if Config.UseTarget then
                createNpcPickUpLocation()
            end
            Taxi.mission.npc.blip = AddBlipForCoord(location.x, location.y, location.z)
            SetBlipColour(Taxi.mission.npc.blip, 3)
            SetBlipRoute(Taxi.mission.npc.blip, true)
            SetBlipRouteColour(Taxi.mission.npc.blip, 3)
            Taxi.mission.npc.last = Taxi.mission.npc.current
            Taxi.mission.active = true
            -- added checks to disable distance checking if polyzone option is used
            if not Config.UseTarget then
                CreateThread(function()
                    while not Taxi.mission.pickup.done do
                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local dist = #(pos - vector3(location.x, location.y, location.z))
                        if dist < 20 then
                            DrawMarker(2, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                            if dist < 5 then
                                Taxi.Methods.DrawText3D(location.x, location.y, location.z, Lang:t("info.call_npc"))
                                if IsControlJustPressed(0, 38) then
                                    local veh = GetVehiclePedIsIn(ped, 0)
                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                                    for i=maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(veh, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end
                                    Taxi.meter.open = true
                                    Taxi.meter.active = true
                                    Taxi.meter.start = GetEntityCoords(PlayerPedId())
                                    SendNUIMessage({
                                        action = "openMeter",
                                        toggle = true,
                                        data = Config.Meter
                                    })
                                    SendNUIMessage({
                                        action = "toggleMeter"
                                    })
                                    ClearPedTasksImmediately(Taxi.mission.npc.ped)
                                    FreezeEntityPosition(Taxi.mission.npc.ped, false)
                                    TaskEnterVehicle(Taxi.mission.npc.ped, veh, -1, freeSeat, 1.0, 0)
                                    Taxi.Info(Lang:t("info.go_to_location"))
                                    if Taxi.mission.npc.blip ~= nil then
                                        RemoveBlip(Taxi.mission.npc.blip)
                                    end
                                    GetDeliveryLocation()
                                    Taxi.mission.pickup.done = true
                                end
                            end
                        end
                        Wait(1)
                    end
                end)
            end
        else
            Taxi.Error(Lang:t("error.already_mission"))
        end
    else
        Taxi.Error(Lang:t("error.not_in_taxi"))
    end
end)

function createNpcPickUpLocation()
    local pickup = Config.missions.pickup[Taxi.mission.npc.current]
    Taxi.mission.pickup.zone = Taxi.Methods.CreateBoxZone(pickup)
    Taxi.mission.pickup.zone:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside then
            if Taxi.Methods.IsPlayerInsideTaxi() and not Taxi.mission.pickup.arrived and not Taxi.mission.pickup.done then
                Taxi.mission.pickup.arrived = true
                exports['qb-core']:DrawText(Lang:t("info.call_npc"), Config.DefaultTextLocation)
                callNpcPoly()
            end
        else
            Taxi.mission.pickup.arrived = false
        end
    end)
end

function createNpcDelieveryLocation()
    local drop = Config.missions.dropoff[Taxi.mission.current]
    Taxi.mission.dropoff.zone = Taxi.Methods.CreateBoxZone(drop)
    Taxi.mission.dropoff.zone:onPlayerInOut(function(isPlayerInside)
        if isPlayerInside then
            if Taxi.Methods.IsPlayerInsideTaxi() and not Taxi.mission.dropoff.arrived and Taxi.mission.pickup.done then
                Taxi.mission.dropoff.arrived = true
                exports['qb-core']:DrawText(Lang:t("info.drop_off_npc"), Config.DefaultTextLocation)
                dropNpcPoly()
            end
        else
            Taxi.mission.dropoff.arrived = false
        end
    end)
end

function callNpcPoly()
    CreateThread(function()
        while not Taxi.mission.pickup.done do
            local ped = PlayerPedId()
            if Taxi.mission.pickup.arrived then
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:KeyPressed()
                    local veh = GetVehiclePedIsIn(ped, 0)
                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                    for i=maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(veh, i) then
                            freeSeat = i
                            break
                        end
                    end

                    Taxi.meter.open = true
                    Taxi.meter.active = true
                    Taxi.meter.start = GetEntityCoords(PlayerPedId())
                    SendNUIMessage({
                        action = "openMeter",
                        toggle = true,
                        data = Config.Meter
                    })
                    SendNUIMessage({
                        action = "toggleMeter"
                    })
                    ClearPedTasksImmediately(Taxi.mission.npc.ped)
                    FreezeEntityPosition(Taxi.mission.npc.ped, false)
                    TaskEnterVehicle(Taxi.mission.npc.ped, veh, -1, freeSeat, 1.0, 0)
                    Taxi.Info(Lang:t("info.go_to_location"))
                    if Taxi.mission.npc.blip ~= nil then
                        RemoveBlip(Taxi.mission.npc.blip)
                    end
                    GetDeliveryLocation()
                    Taxi.mission.pickup.done = true
                    createNpcDelieveryLocation()
                    Taxi.mission.pickup.zone:destroy()
                end
            end
            Wait(1)
        end
    end)
end

function dropNpcPoly()
    CreateThread(function()
        while Taxi.mission.pickup.done do
            local ped = PlayerPedId()
            if Taxi.mission.dropoff.arrived then
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:KeyPressed()
                    local veh = GetVehiclePedIsIn(ped, 0)
                    TaskLeaveVehicle(Taxi.mission.npc.ped, veh, 0)
                    SetEntityAsMissionEntity(Taxi.mission.npc.ped, false, true)
                    SetEntityAsNoLongerNeeded(Taxi.mission.npc.ped)
                    local targetCoords = Config.missions.pickup[Taxi.mission.npc.last]
                    TaskGoStraightToCoord(Taxi.mission.npc.ped, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                    SendNUIMessage({
                        action = "toggleMeter"
                    })
                    TriggerServerEvent('qb-taxi:server:NpcPay', Taxi.meter.data.currentFare)
                    Taxi.meter.active = false
                    SendNUIMessage({
                        action = "resetMeter"
                    })
                    Taxi.Success(Lang:t("info.person_was_dropped_off"))
                    if Taxi.mission.blip ~= nil then
                        RemoveBlip(Taxi.mission.blip)
                    end
                    Wait(200)
                    if Config.mzskills then
                        local BetterXP = math.random(Config.DriverXPlow, Config.DriverXPhigh)
                        local xpmultiple = math.random(1, 4)
                        if xpmultiple >= 3 then
                            chance = BetterXP
                        elseif xpmultiple < 3 then
                            chance = Config.DriverXPlow
                        end
                        exports["mz-skills"]:UpdateSkill("Besturen", chance)
                        Wait(1000)
                        if Config.bonus.chance >= math.random(1, 100) then
                            ItsJustTheTipBaby()
                        end
                    end
                    local RemovePed = function(p)
                        SetTimeout(60000, function()
                            DeletePed(p)
                        end)
                    end
                    RemovePed(Taxi.mission.npc.ped)
                    ResetNpcTask()
                    Taxi.mission.dropoff.zone:destroy()
                    break
                end
            end
            Wait(1)
        end
    end)

end
