QBCore = exports['qb-core']:GetCoreObject()

Taxi = {
    cfg = Config,
    nui = {
        open = false,
        active = false,
    },
    meter = {
        open = false,
        active = false,
        start = nil,
        data = {
            fareAmount = 6,
            currentFare = 0,
            distanceTraveled = 0,
        }
    },
    player = {
        job = {}
    },
    mission = {
        current = nil,
        last = nil,
        blip = nil,
        active = false,
        countdown = 180,
        npc = {
            current = nil,
            last = nil,
            blip = nil,
            ped = nil
        },
        pickup = {
            zone = nil,
            arrived = false,
            done = false
        },
        dropoff = {
            zone = nil,
            arrived = false
        }
    }
}

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(data)
    Taxi.player.job = data
end)

local function Notify(type, message, duration)
    print(("[taxi:%s] %s"):format(type, message))
    duration = duration or 5000
    if Config.NotifyType == 'qb' then
        QBCore.Functions.Notify(message, type, duration)
    elseif Config.NotifyType == "okok" then
        exports['okokNotify']:Alert('TAXI JOB', message, duration, type)
    end
end

function Taxi.Info(message, duration)
    duration = duration or 5000
    Notify(Config.NotifyType == 'qb' and 'primary' or 'info', message, duration)
end

function Taxi.Error(message, duration)
    duration = duration or 5000
    Notify('error', message, duration)
end

function Taxi.Success(message, duration)
    duration = duration or 5000
    Notify('success', message, duration)
end

Taxi.Methods = {}
Taxi.Services = {}
