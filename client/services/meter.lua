Taxi.Services.Meter = {}

-- methods
function Taxi.Services.Meter.Reset()
    Taxi.meter.data.fareAmount = 6
    Taxi.meter.data.currentFare = 0
    Taxi.meter.data.distanceTraveled = 0
    Taxi.meter.data.defaultPrice = Config.meter.defaultPrice
    Taxi.Services.Meter.Update()
end

function Taxi.Services.Meter.Open()
    Taxi.Debug("opening taxi meter")
    Taxi.Services.Meter.Update()
    Taxi.Methods.TriggerNuiEvent("meter:open")
    Taxi.meter.open = true
end

function Taxi.Services.Meter.Close()
    Taxi.Debug("opening taxi meter")
    Taxi.Methods.TriggerNuiEvent("meter:close")
    Taxi.meter.open = false
end

function Taxi.Services.Meter.Update()
    Taxi.Methods.TriggerNuiEvent("meter:update", Taxi.meter.data)
end

function Taxi.Services.Meter.Toggle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        if Taxi.Methods.IsPlayerInsideTaxi() then
            if not Taxi.meter.open and Taxi.Methods.IsPlayerDriving() then
                Taxi.Services.Meter.Open()
            else
                Taxi.Services.Meter.Close()
            end
        else
            Taxi.Error(Lang:t("error.missing_meter"))
        end
    else
        Taxi.Error(Lang:t("error.not_in_taxi"))
    end
end

function Taxi.Services.Meter.Enable()
    if Taxi.meter.open then
        SendNUIMessage({
            action = "toggleMeter",
            data = Taxi.meter.data
        })
    else
        Taxi.Error(Lang:t("error.missing_meter"))
    end
end

function Taxi.Services.Meter.EnableMouse()
    Wait(400)
    if Taxi.meter.open then
        Taxi.Methods.EnableMouse()
    else
        Taxi.Error(Lang:t("error.missing_meter"))
    end
end

function Taxi.Services.Meter.CalculateFareAmount()
    if Taxi.meter.open and Taxi.meter.active then
        local pos = GetEntityCoords(PlayerPedId())
        if Taxi.meter.start ~= pos then
            local distance = #(Taxi.meter.start - pos)
            Taxi.meter.start = pos
            Taxi.meter.data.distanceTraveled += distance
            local fareAmount = (Taxi.meter.data.distanceTraveled / 100.00) * Taxi.meter.data.fareAmount
            Taxi.meter.data.currentFare = math.ceil(fareAmount)
            Taxi.Services.Meter.Update()
        end
    end
end

-- events
RegisterNetEvent('qb-taxi:client:toggleMeter', Taxi.Services.Meter.Toggle)
RegisterNetEvent('qb-taxi:client:enableMeter', Taxi.Services.Meter.Enable)
RegisterNetEvent('qb-taxi:client:toggleMuis', Taxi.Services.Meter.EnableMouse)

-- nui callbacks
RegisterNUICallback('enableMeter', function(data, cb)
    Taxi.meter.active = data.enabled
    if not Taxi.meter.active then
        Taxi.Services.Meter.Reset()
    end
    Taxi.meter.start = GetEntityCoords(PlayerPedId())
    cb('ok')
end)

RegisterNUICallback('hideMouse', function(_, cb)
    Taxi.Methods.DisableMouse()
    cb('ok')
end)

-- threads
CreateThread(function()
    while true do
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if Taxi.meter.open then
                Taxi.Services.Meter.Close()
            end
        end
        Wait(200)
    end
end)
