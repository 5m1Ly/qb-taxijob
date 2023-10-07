Taxi.Services.Missions = {}

function Taxi.Services.Missions.GetPlayerPos()
    return GetEntityCoords(PlayerPedId())
end

function Taxi.Services.Missions.GetDistance(x, y, z)
    return #(Taxi.Services.Missions.GetPlayerPos() - vector3(x, y, z))
end

function Taxi.Services.Missions.SetRandomMissionPed(recursed)
    Taxi.Debug("selecting random ped for mission")
    if not recursed and Taxi.mission.npc.current ~= nil then
        Taxi.mission.npc.last = Taxi.mission.npc.current
    end
    local peds = Config.missions.pedestrians
    local gender = math.random(1, 2)
    Taxi.mission.npc.current = GetHashKey(peds[gender][math.random(1, #peds[gender])])
    if Taxi.mission.npc.current == Taxi.mission.npc.last then
        return Taxi.Services.Missions.SetRandomMissionPed(true)
    end
    return Taxi.mission.npc.current
end

function Taxi.Services.Missions.SetRandomPickupLocation(recursed)
    Taxi.Debug("selecting random pickup location for mission")
    recursed = not not recursed
    if not recursed and Taxi.mission.pickup.current ~= nil then
        Taxi.mission.pickup.last = Taxi.mission.pickup.current
    end
    Taxi.mission.pickup.current = math.random(1, #Config.missions.pickup)
    local vec = Config.missions.pickup[Taxi.mission.pickup.current]
    local pos = Taxi.Services.Missions.GetPlayerPos()
    if #(pos - vector3(vec.x, vec.y, vec.z)) <= 150 then
        return Taxi.Services.Missions.SetRandomPickupLocation(true)
    end
    if Taxi.mission.pickup.last ~= nil then
        if Taxi.mission.pickup.current == Taxi.mission.pickup.last then
            return Taxi.Services.Missions.SetRandomPickupLocation(true)
        end
        local last = Config.missions.pickup[Taxi.mission.pickup.last]
        local curr = Config.missions.pickup[Taxi.mission.pickup.current]
        if #(vector3(last.x, last.y, last.z) - vector3(curr.x, curr.y, curr.z)) <= 50 then
            return Taxi.Services.Missions.SetRandomPickupLocation(true)
        end
    end
    Taxi.Debug("selected random pickup location for mission")
    return Taxi.mission.pickup.current
end

function Taxi.Services.Missions.SetRandomDropoffLocation(recursed)
    Taxi.Debug("selecting random dropoff location for mission")
    recursed = not not recursed
    if not recursed and Taxi.mission.dropoff.current ~= nil then
        Taxi.mission.dropoff.last = Taxi.mission.dropoff.current
    end
    Taxi.mission.dropoff.current = math.random(1, #Config.missions.dropoff)
    local vec = Config.missions.dropoff[Taxi.mission.dropoff.current]
    local pos = Taxi.Services.Missions.GetPlayerPos()
    if #(pos - vector3(vec.x, vec.y, vec.z)) <= 150 then
        return Taxi.Services.Missions.SetRandomDropoffLocation(true)
    end
    if Taxi.mission.dropoff.last ~= nil then
        if Taxi.mission.dropoff.current == Taxi.mission.dropoff.last then
            return Taxi.Services.Missions.SetRandomDropoffLocation(true)
        end
        local last = Config.missions.dropoff[Taxi.mission.dropoff.last]
        local curr = Config.missions.dropoff[Taxi.mission.dropoff.current]
        if #(vector3(last.x, last.y, last.z) - vector3(curr.x, curr.y, curr.z)) <= 50 then
            return Taxi.Services.Missions.SetRandomDropoffLocation(true)
        end
    end
    Taxi.Debug("selected random dropoff location for mission")
    return Taxi.mission.dropoff.current
end

function Taxi.Services.Missions.LoadCurrentMissionPed()
    Taxi.Debug("loading ped for mission")
    RequestModel(Taxi.mission.npc.current)
    while not HasModelLoaded(Taxi.mission.npc.current) do
        Wait(0)
    end
    local vec = Config.missions.pickup[Taxi.mission.pickup.current]
    Taxi.mission.npc.ped = CreatePed(
        3,
        Taxi.mission.npc.current,
        vec.x, vec.y, vec.z - 0.98, vec.w,
        false,
        true
    )
    PlaceObjectOnGroundProperly(Taxi.mission.npc.ped)
    FreezeEntityPosition(Taxi.mission.npc.ped, true)
end

function Taxi.Services.Missions.RemoveMissionsPed(ped)
    SetTimeout(20000, function()
        DeletePed(ped)
    end)
end

function Taxi.Services.Missions.SetMissionBlip(vec)
    Taxi.Debug("creating blip for mission")
    if Taxi.mission.blip ~= nil then
        RemoveBlip(Taxi.mission.blip)
    end
    Taxi.mission.blip = AddBlipForCoord(vec.x, vec.y, vec.z)
    SetBlipColour(Taxi.mission.blip, 3)
    SetBlipRoute(Taxi.mission.blip, true)
    SetBlipRouteColour(Taxi.mission.blip, 3)
end

function Taxi.Services.Missions.Reset()
    Taxi.mission.current = nil
    Taxi.mission.last = nil
    Taxi.mission.blip = nil
    Taxi.mission.active = false
    Taxi.mission.countdown = 180

    Taxi.mission.npc.current = nil
    Taxi.mission.npc.last = nil
    Taxi.mission.npc.blip = nil

    Taxi.mission.pickup.current = nil
    Taxi.mission.pickup.last = nil
    Taxi.mission.pickup.zone = nil
    Taxi.mission.pickup.arrived = false
    Taxi.mission.pickup.done = false

    Taxi.mission.dropoff.current = nil
    Taxi.mission.dropoff.last = nil
    Taxi.mission.dropoff.zone = nil
    Taxi.mission.dropoff.arrived = false
end

function Taxi.Services.Missions.CalculateBonus()
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

function Taxi.Services.Missions.MissionDropoffThread()
    local vec = Config.missions.dropoff[Taxi.mission.dropoff.current]
    while true do
        local pos = Taxi.Services.Missions.GetPlayerPos()
        local dist = #(pos - vector3(vec.x, vec.y, vec.z))
        if dist < 20 then
            DrawMarker(2, vec.x, vec.y, vec.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, Config.colors.rgb[1], Config.colors.rgb[2], Config.colors.rgb[3], 255, 0, 0, 0, 1, 0, 0, 0)
            if dist < 5 then
                Taxi.Methods.DrawText3D(vec.x, vec.y, vec.z, Lang:t("info.drop_off_npc"))
                if IsControlJustPressed(0, 38) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    TaskLeaveVehicle(Taxi.mission.npc.ped, veh, 0)
                    SetEntityAsMissionEntity(Taxi.mission.npc.ped, false, true)
                    SetEntityAsNoLongerNeeded(Taxi.mission.npc.ped)
                    local targetCoords = Config.missions.pickup[Taxi.mission.pickup.current]
                    TaskGoStraightToCoord(Taxi.mission.npc.ped, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                    SendNUIMessage({
                        name = "meter:toggle-fare"
                    })
                    TriggerServerEvent('qb-taxi:server:NpcPay', Taxi.meter.data.currentFare)
                    Taxi.meter.active = false
                    Taxi.Services.Meter.Reset()
                    Taxi.Success(Lang:t("info.person_was_dropped_off"))
                    if Taxi.mission.blip ~= nil then
                        RemoveBlip(Taxi.mission.blip)
                    end
                    Wait(200)
                    if Config.mzskills then
                        local points = math.random(Config.DriverXPlow, Config.DriverXPhigh)
                        if math.random(1, 4) == 1 then
                            points += math.random(10, 20)
                        end
                        exports["mz-skills"]:UpdateSkill("Besturen", points)
                        Wait(1000)
                        if math.random(1, 100) >= (100 - Config.bonus.chance) then
                            Taxi.Services.Missions.CalculateBonus()
                        end
                    end
                    Taxi.Services.Missions.RemoveMissionsPed(Taxi.mission.npc.ped)
                    Taxi.Services.Missions.Reset()
                    break
                end
            end
        end
        Wait(1)
    end
end

function Taxi.Services.Missions.StartMissionDropoff()
    Taxi.Services.Missions.SetRandomDropoffLocation()
    local vec = Config.missions.dropoff[Taxi.mission.dropoff.current]
    Taxi.Services.Missions.SetMissionBlip(vec)
    CreateThread(Taxi.Services.Missions.MissionDropoffThread)
end

function Taxi.Services.Missions.MissionPickupThread()
    local vec = Config.missions.pickup[Taxi.mission.pickup.current]
    while not Taxi.mission.pickup.done do
        local pos = Taxi.Services.Missions.GetPlayerPos()
        local dist = #(pos - vector3(vec.x, vec.y, vec.z))
        if dist < 40 then
            DrawMarker(
                2,
                vec.x, vec.y, vec.z  + 1.5,
                0.0, 0.0, 0.0,
                180.0, 0.0, 0.0,
                0.5, 0.5, 0.5,
                Config.colors.rgb[1], Config.colors.rgb[2], Config.colors.rgb[3], 200,
                false, false, false, true, false, false, false
            )
            if dist < 5 then
                Taxi.Methods.DrawText3D(vec.x, vec.y, vec.z, Lang:t("info.call_npc"))
                if IsControlJustPressed(0, 38) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)
                    for i = maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(veh, i) then
                            freeSeat = i
                            break
                        end
                    end
                    Taxi.meter.start = GetEntityCoords(PlayerPedId())
                    Taxi.Services.Meter.Open()
                    Taxi.meter.active = true
                    SendNUIMessage({ name = "meter:toggle-fare" })
                    ClearPedTasksImmediately(Taxi.mission.npc.ped)
                    FreezeEntityPosition(Taxi.mission.npc.ped, false)
                    TaskEnterVehicle(Taxi.mission.npc.ped, veh, -1, freeSeat, 1.0, 0)
                    Taxi.Info(Lang:t("info.go_to_location"))
                    Taxi.mission.pickup.done = true
                    Taxi.Services.Missions.StartMissionDropoff()
                end
            end
        end
        Wait(1)
    end
end

function Taxi.Services.Missions.StartMissionPickup()
    if not Taxi.Methods.IsPlayerInsideTaxi() then
        Taxi.Error(Lang:t("error.not_in_taxi"))
    end
    if Taxi.mission.active then
        Taxi.Error(Lang:t("error.already_mission"))
    end
    Taxi.Debug("starting mission")
    Taxi.Services.Missions.SetRandomMissionPed(false)
    Taxi.Services.Missions.SetRandomPickupLocation(false)
    Taxi.Services.Missions.LoadCurrentMissionPed()
    local pickup = Config.missions.pickup[Taxi.mission.pickup.current]
    Taxi.Services.Missions.SetMissionBlip(pickup)
    Taxi.mission.active = true
    Taxi.Success(Lang:t("info.npc_on_gps"))
    CreateThread(Taxi.Services.Missions.MissionPickupThread)
end

-- Events
RegisterNetEvent('qb-taxi:client:DoTaxiNpc', Taxi.Services.Missions.StartMissionPickup)
