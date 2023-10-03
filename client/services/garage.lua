Taxi.Services.Garage = {}

function Taxi.Services.Garage.Open()
    local menu = Taxi.Methods.CreateMenu()

    menu.setHeader(Lang:t("menu.taxi_menu_header"))

    for i = 1, #Config.garage.vehicles do
        local vehicle = Config.garage.vehicles[i]
        menu.setOption(vehicle.label, "", {
            event = "qb-taxi:client:TakeVehicle",
            args = {
                model = vehicle.model
            }
        })
    end

    if Taxi.player.job.name == "taxi" and Taxi.player.job.isboss and Config.UseTarget then
        menu.setOption(Lang:t("menu.boss_menu"), "", {
            event = "qb-bossmenu:client:forceMenu"
        })
    end

    menu.build()
end

function Taxi.Services.Garage.Close()
    Taxi.Methods.CloseMenu()
end

function Taxi.Services.Garage.GetSpawnPoint(i)
    local i = i or 1
    if i > #Config.garage.parking then return nil end
    local current = math.random(1, #Config.garage.parking)
    local spawn = Config.garage.parking[current]
    if not Taxi.Methods.IsSpawnPointClear(spawn, 2.5) then
        return Taxi.Services.Garage.GetSpawnPoint(i + 1)
    end
	return current ~= nil and Config.garage.parking[current] or nil
end
