Taxi.Services.Missions = {}

function Taxi.Services.Missions.GetPlayerPos()
    return GetEntityCoords(PlayerPedId())
end

function Taxi.Services.Missions.GetDistance(x, y, z)
    return #(Taxi.Services.Missions.GetPlayerPos() - vector3(x, y, z))
end

function Taxi.Services.Missions.SetRandomMissionPed(recursed)
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
    recursed = not not recursed
    if not recursed and Taxi.mission.pickup.current ~= nil then
        Taxi.mission.pickup.last = Taxi.mission.pickup.current
    end
    Taxi.mission.pickup.current = math.random(1, #Config.missions.pickup)
    local vec = Config.missions.pickup[Taxi.mission.pickup.current]
    local pos = Taxi.Services.Missions.GetPlayerPos()
    if #(pos - vector3(vec.x, vec.y, vec.z)) <= 150 then
        return Taxi.Services.Missions.NewPickupLocation(true)
    end
    if Taxi.mission.pickup.last ~= nil then
        if Taxi.mission.pickup.current == Taxi.mission.pickup.last then
            return Taxi.Services.Missions.NewPickupLocation(true)
        end
        local last = Config.missions.pickup[Taxi.mission.pickup.last]
        local curr = Config.missions.pickup[Taxi.mission.pickup.current]
        if #(vector3(last.x, last.y, last.z) - vector3(curr.x, curr.y, curr.z)) <= 50 then
            return Taxi.Services.Missions.NewPickupLocation(true)
        end
    end
    return Taxi.mission.pickup.current
end

function Taxi.Services.Missions.SetRandomDropoffLocation(recursed)
    recursed = not not recursed
    if not recursed and Taxi.mission.dropoff.current ~= nil then
        Taxi.mission.dropoff.last = Taxi.mission.dropoff.current
    end
    Taxi.mission.dropoff.current = math.random(1, #Config.missions.dropoff)
    local vec = Config.missions.dropoff[Taxi.mission.dropoff.current]
    local pos = Taxi.Services.Missions.GetPlayerPos()
    if #(pos - vector3(vec.x, vec.y, vec.z)) <= 150 then
        return Taxi.Services.Missions.NewPickupLocation(true)
    end
    if Taxi.mission.dropoff.last ~= nil then
        if Taxi.mission.dropoff.current == Taxi.mission.dropoff.last then
            return Taxi.Services.Missions.NewPickupLocation(true)
        end
        local last = Config.missions.dropoff[Taxi.mission.dropoff.last]
        local curr = Config.missions.dropoff[Taxi.mission.dropoff.current]
        if #(vector3(last.x, last.y, last.z) - vector3(curr.x, curr.y, curr.z)) <= 50 then
            return Taxi.Services.Missions.NewPickupLocation(true)
        end
    end
    return Taxi.mission.dropoff.current
end

function Taxi.Services.Missions.LoadCurrentMissionPad()
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

function Taxi.Services.Missions.SetMissionBlip(vec)
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

function Taxi.Services.Missions.StartMission()
    if not Taxi.Methods.IsPlayerInsideTaxi() then
        Taxi.Error(Lang:t("error.not_in_taxi"))
    end
    if Taxi.mission.active then
        Taxi.Error(Lang:t("error.already_mission"))
    end
    Taxi.Services.Missions.SetRandomMissionPed(false)
    Taxi.Services.Missions.LoadCurrentMissionPad()
    Taxi.Services.Missions.SetRandomPickupLocation(false)
    local pickup = Config.missions.pickup[Taxi.mission.pickup.current]
    Taxi.Services.Missions.SetMissionBlip(pickup)
    Taxi.mission.active = true
    Taxi.Success(Lang:t("info.npc_on_gps"))
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
    Taxi.Services.Missions.SetRandomDropoffLocation()

    local location = Config.missions.dropoff[Taxi.mission.current]

    Taxi.Services.Missions.SetMissionBlip(location)

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
                            Taxi.Services.Missions.Reset()
                            break
                        end
                    end
                end
                Wait(1)
            end
        end)
    end
end

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
                    Taxi.Services.Missions.Reset()
                    Taxi.mission.dropoff.zone:destroy()
                    break
                end
            end
            Wait(1)
        end
    end)
end

-- Events
RegisterNetEvent('qb-taxi:client:DoTaxiNpc', function()
    Taxi.Services.Missions.StartMission()

    local location = Config.missions.pickup[Taxi.mission.npc.current]

    CreateThread(function()
        while not Taxi.mission.pickup.done do
            local pos = Taxi.Services.Missions.GetPlayerPos()
            local dist = #(pos - vector3(location.x, location.y, location.z))
            local z = ((location.z * 1000) + 500) / 1000
            if dist < 20 then
                DrawMarker(
                    2,
                    location.x, location.y, z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    0.3, 0.3, 0.3,
                    Config.colors.rgb[1], Config.colors.rgb[2], Config.colors.rgb[3], 200,
                    false, false, false, true, false, false, false
                )
                if dist < 5 then
                    Taxi.Methods.DrawText3D(location.x, location.y, z, Lang:t("info.call_npc"))
                    if IsControlJustPressed(0, 38) then
                        local veh = GetVehiclePedIsIn(ped, 0)
                        local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

                        for i=maxSeats - 1, 0, -1 do
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
end)
