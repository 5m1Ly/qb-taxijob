Config = Config or {}

Config.production = false                    -- Set to true to enable debuggers (should be false in production)

Config.NotifyType = 'qb'                    -- notification type: 'qb' for qb-core standard notifications, 'okok' for okokNotify notifications
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- set this to false if you want to use distance checks
Config.DefaultTextLocation = "left"         -- Set to either "left", "right" or "top"
Config.mzskills = true                      -- Set to 'false' if you do not wish to use mz-skills XP integration

-- if Config.mzskills = true, then the following parameters apply:
Config.DriverXPlow = 7                      -- Lowest possible XP given from successful NPC drop.
Config.DriverXPhigh = 13                     -- Highest possible XP given from successful NPC drop.

-- Rare item drop parameters
Config.rareitem = 'cryptostick'             -- Rare item received by player
Config.rarechance = 0                      -- Percentage chance of additional player drop upon completion of client taxi mission (set to 0 to disable)

Config.BossMenu = vector3(903.32, -170.55, 74.0)

