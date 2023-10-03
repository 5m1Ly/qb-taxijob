Taxi.Services.Meter = {}

function Taxi.Services.Meter.Toggle()

end

-- Taxi.Meter.Reset()
function Taxi.Services.Meter.Reset()
    Taxi.meter.data = {
        fareAmount = 6,
        currentFare = 0,
        distanceTraveled = 0,
    }
end

-- Taxi.Meter.CalculateFareAmount()
function Taxi.Services.Meter.CalculateFareAmount()
    if Taxi.meter.open and Taxi.meter.active then
        local pos = GetEntityCoords(PlayerPedId())
        if Taxi.meter.start ~= pos then
            local distance = #(Taxi.meter.start - pos)
            Taxi.meter.start = pos
            Taxi.meter.data.distanceTraveled += distance

            print("distance", distance)
            print("traveled", Taxi.meter.data['distanceTraveled'])
            local fareAmount = (Taxi.meter.data.distanceTraveled / 100.00) * Taxi.meter.data.fareAmount
            Taxi.meter.data.currentFare = math.ceil(fareAmount)

            SendNUIMessage({
                action = "updateMeter",
                data = Taxi.meter.data
            })
        end
    end
end

RegisterNetEvent('qb-taxi:client:toggleMeter', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        if Taxi.Methods.IsPlayerInsideTaxi() then
            if not Taxi.meter.open and Taxi.Methods.IsPlayerDriver() then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    data = Config.meter
                })
                Taxi.meter.open = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                Taxi.meter.open = false
            end
        else
            Taxi.Error(Lang:t("error.missing_meter"))
        end
    else
        Taxi.Error(Lang:t("error.not_in_taxi"))
    end
end)

RegisterNetEvent('qb-taxi:client:enableMeter', function()
    if Taxi.meter.open then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        Taxi.Error(Lang:t("error.missing_meter"))
    end
end)

RegisterNetEvent('qb-taxi:client:toggleMuis', function()
    Wait(400)
    if Taxi.meter.open then
        Taxi.Methods.NUI.EnableMouse()
    else
        Taxi.Error(Lang:t("error.missing_meter"))
    end
end)

RegisterNUICallback('enableMeter', function(data, cb)
    Taxi.meter.active = data.enabled
    if not Taxi.meter.active then Taxi.Services.Meter.Reset() end
    Taxi.meter.start = GetEntityCoords(PlayerPedId())
    cb('ok')
end)

RegisterNUICallback('hideMouse', function(_, cb)
    SetNuiFocus(false, false)
    Taxi.nui.active = false
    cb('ok')
end)

CreateThread(function()
    while true do
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if Taxi.meter.open then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                Taxi.meter.open = false
            end
        end
        Wait(200)
    end
end)