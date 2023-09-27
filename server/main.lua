local QBCore = exports['qb-core']:GetCoreObject()

local function NearTaxi(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    for _, v in pairs(Config.NPCLocations.DeliverLocations) do
        local dist = #(coords - vector3(v.x, v.y, v.z))
        if dist < 20 then
            return true
        end
    end
end

local function NoExploit(src, cb, ...)
    local player = QBCore.Functions.GetPlayer(src)
    if player.PlayerData.job.name == "taxi" then
        if NearTaxi(src) then
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
            payment = payment + math.random(10, 20)
        end
        player.Functions.AddMoney('cash', payment)
        if math.random(1, 100) == 1 then
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
