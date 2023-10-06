function Taxi.Methods.EnableMouse()
    SetNuiFocus(true, true)
    Taxi.nui.active = true
end

function Taxi.Methods.DisableMouse()
    SetNuiFocus(false, false)
    Taxi.nui.active = false
end

function Taxi.Methods.TriggerNuiEvent(event, data)
    SendNUIMessage({
        name = event,
        data = data
    })
end
