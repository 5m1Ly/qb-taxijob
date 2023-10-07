local QBCore = exports['qb-core']:GetCoreObject()

local function NearDropoffLocation(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.missions.dropoff) do
        local dist = #(coords - vector3(v.x, v.y, v.z))
        if dist < 20 then
            return true
        end
    end
end

local function NoExploit(src, cb, ...)
    local player = QBCore.Functions.GetPlayer(src)
    if player.PlayerData.job.name == "taxi" then
        if NearDropoffLocation(src) then
            cb(src, player, ...)
        else
            DropPlayer(src, 'Attempting To Exploit')
        end
    else
        DropPlayer(src, 'Attempting To Exploit')
    end
end

RegisterNetEvent('qb-taxi:server:NpcPay', function(payment)
    NoExploit(source, function(src, player)
        local randomAmount = math.random(1, 5)
        local r1, r2 = math.random(1, 5), math.random(1, 5)
        if randomAmount == r1 or randomAmount == r2 then
            payment += math.random(10, 20)
        end
        local precent = payment / 100
        local taxi_payment = precent * 10
        local player_payment = precent * 90
        exports['qb-management']:AddMoney("taxi", taxi_payment)
        player.Functions.AddMoney('cash', player_payment)
        if math.random(1, 5) == 1 then
            player.Functions.AddItem(Config.rareitem, 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.rareitem], "add")
        end
    end)
end)

RegisterNetEvent('qb-taxijob:server:its-just-the-tip-baby', function(level)
    NoExploit(source, function(_, player)
        local info = Config.bonus.levels[level]
        local bonus = math.random(info.low, info.high)
        player.Functions.AddMoney('cash', bonus)
    end)
end)
