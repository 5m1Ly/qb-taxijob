Config = Config or {}

--------------
--QB-TAXIJOB--
--------------

Config.NotifyType = 'qb'                    -- notification type: 'qb' for qb-core standard notifications, 'okok' for okokNotify notifications
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- set this to false if you want to use distance checks
Config.DefaultTextLocation = "left"         -- Set to either "left", "right" or "top"

-- todo: change back to true
Config.mzskills = false                      -- Set to 'false' if you do not wish to use mz-skills XP integration

-- if Config.mzskills = true, then the following parameters apply:
Config.DriverXPlow = 7                      -- Lowest possible XP given from successful NPC drop.
Config.DriverXPhigh = 13                     -- Highest possible XP given from successful NPC drop.

Config.Meter = {
    ["defaultPrice"] = 200.00  -- dit maal bedrag wordt gedeeld door 2 dus als je 100 wilt als prijs moet je hier 200 instellen!!
}

-- Rare item drop parameters
Config.rareitem = 'cryptostick'             -- Rare item received by player
Config.rarechance = 0                      -- Percentage chance of additional player drop upon completion of client taxi mission (set to 0 to disable)

-- if Config.mzskills = true, then the following bonus payment parameters apply:
------------------
-- BONUS PAYMENT--
------------------
Config.bonus = {
    chance = 20,                    -- Percentage chance that the client pays the driver a bonus (to disable set to 0).
    levels = {
        { low = 1, high = 5, experiance = 0 },
        { low = 3, high = 8, experiance = 200 },
        { low = 5, high = 12, experiance = 400 },
        { low = 8, high = 16, experiance = 800 },
        { low = 10, high = 18, experiance = 1600 },
        { low = 13, high = 22, experiance = 3200 },
        { low = 15, high = 26, experiance = 6400 },
        { low = 18, high = 30, experiance = 12800 }
    },
    messages = {
        'Beste service die ik heb gehad, neem mijn geld!',
        'Je zou de hele dag weg kunnen komen van de politie door zo te rijden!',
        'Hé, mag ik je nummer? Je hebt me hier snel slim gebracht!',
        'Hé, dat waardeer ik, dankjewel! Neem iets extra\'s alstublieft...',
        'Lekker gereden, bedankt! Hier is een kleine tip...'
    }
}

Config.AllowedVehicles = {
    [1] = { model = "taxi", label = "taxi" },
}

Config.BossMenu = vector3(903.32, -170.55, 74.0)

Config.Location = vector4(909.5, -177.35, 74.22, 238.5)

Config.NPCLocations = {
    TakeLocations = {
        [1] = vector4(257.61, -380.57, 44.71, 340.5),
        [2] = vector4(-48.58, -790.12, 44.22, 340.5),
        [3] = vector4(240.06, -862.77, 29.73, 341.5),
        [4] = vector4(826.0, -1885.26, 29.32, 81.5),
        [5] = vector4(350.84, -1974.13, 24.52, 318.5),
        [6] = vector4(-229.11, -2043.16, 27.75, 233.5),
        [7] = vector4(-1053.23, -2716.2, 13.75, 329.5),
        [8] = vector4(-774.04, -1277.25, 5.15, 171.5),
        [9] = vector4(-1184.3, -1304.16, 5.24, 293.5),
        [10] = vector4(-1321.28, -833.8, 16.95, 140.5),
        [11] = vector4(-1613.99, -1015.82, 13.12, 342.5),
        [12] = vector4(-1392.74, -584.91, 30.24, 32.5),
        [13] = vector4(-515.19, -260.29, 35.53, 201.5),
        [14] = vector4(-760.84, -34.35, 37.83, 208.5),
        [15] = vector4(-1284.06, 297.52, 64.93, 148.5),
        [16] = vector4(-808.29, 828.88, 202.89, 200.5),
    },
    DeliverLocations = {
        [1] = vector4(-1074.39, -266.64, 37.75, 117.5),
        [2] = vector4(-1412.07, -591.75, 30.38, 298.5),
        [3] = vector4(-679.9, -845.01, 23.98, 269.5),
        [4] = vector4(-158.05, -1565.3, 35.06, 139.5),
        [5] = vector4(442.09, -1684.33, 29.25, 320.5),
        [6] = vector4(1120.73, -957.31, 47.43, 289.5),
        [7] = vector4(1238.85, -377.73, 69.03, 70.5),
        [8] = vector4(922.24, -2224.03, 30.39, 354.5),
        [9] = vector4(1920.93, 3703.85, 32.63, 120.5),
        [10] = vector4(1662.55, 4876.71, 42.05, 185.5),
        [11] = vector4(-9.51, 6529.67, 31.37, 136.5),
        [12] = vector4(-3232.7, 1013.16, 12.09, 177.5),
        [13] = vector4(-1604.09, -401.66, 42.35, 321.5),
        [14] = vector4(-586.48, -255.96, 35.91, 210.5),
        [15] = vector4(23.66, -60.23, 63.62, 341.5),
        [16] = vector4(550.3, 172.55, 100.11, 339.5),
        [17] = vector4(-1048.55, -2540.58, 13.69, 148.5),
        [18] = vector4(-9.55, -544.0, 38.63, 87.5),
        [19] = vector4(-7.86, -258.22, 46.9, 68.5),
        [20] = vector4(-743.34, 817.81, 213.6, 219.5),
        [21] = vector4(218.34, 677.47, 189.26, 359.5),
        [22] = vector4(263.2, 1138.81, 221.75, 203.5),
        [23] = vector4(220.64, -1010.81, 29.22, 160.5),
    }
}

Config.PZLocations = {

    TakeLocations = {
        [1] = {
            coord = vector3(258.98, -377.9, 44.7),
            height = 17.6,
            width = 4.2,
            heading=69,
            --debugPoly=true,
            minZ=43.75,
            maxZ=45.55
        },
        [2] = {
            coord = vector3(-50.06, -784.57, 44.16),
            height = 17.6,
            width = 4.2,
            heading=62,
            --debugPoly=true,
            minZ=43.21,
            maxZ=45.01
        },
        [3] = {
            coord = vector3(238.93, -858.91, 29.67),
            height = 17.6,
            width = 4.2,
            heading=71,
            --debugPoly=true,
            minZ=28.72,
            maxZ=30.52
        },
        [4] = {
            coord = vector3(823.4, -1882.96, 29.29),
            height = 17.6,
            width = 4.2,
            heading=167,
            --debugPoly=true,
            minZ=28.34,
            maxZ=30.14
        },
        [5] = {
            coord = vector3(354.05, -1971.57, 24.43),
            height = 17.6,
            width = 4.2,
            heading=236,
            --debugPoly=true,
            minZ=23.48,
            maxZ=25.28
        },
        [6] = {
            coord = vector3(-225.61, -2043.63, 27.62),
            height = 17.6,
            width = 4.2,
            heading=143,
            --debugPoly=true,
            minZ=26.67,
            maxZ=28.47
        },
        [7] = {
              coord = vector3(-1048.72, -2714.2, 13.76),
            height = 17.6,
            width = 4.2,
            heading=240,
            --debugPoly=true,
            minZ=12.81,
            maxZ=14.61
        },
        [8] = {
            coord = vector3(-776.15, -1280.37, 5.0),
            height = 17.6,
            width = 4.2,
            heading=261,
            --debugPoly=true,
            minZ=4.05,
            maxZ=5.85
        },
        [9] = {
            coord = vector3(-1180.3, -1304.22, 5.15),
            height = 17.6,
            width = 4.2,
            heading=205,
            --debugPoly=true,
            minZ=4.2,
            maxZ=6.0
        },
        [10] = {
            coord = vector3(-1326.52, -833.32, 16.85),
            height = 17.6,
            width = 4.2,
            heading=225,
            --debugPoly=true,
            minZ=15.9,
            maxZ=17.7
        },
        [11] = {
            coord = vector3(-1610.24, -1015.33, 13.07),
            height = 17.6,
            width = 4.2,
            heading=227,
            --debugPoly=true,
            minZ=12.12,
            maxZ=13.92
        },
        [12] = {
            coord = vector3(-1396.85, -583.72, 30.08),
            height = 17.6,
            width = 4.2,
            heading=299,
            --debugPoly=true,
            minZ=29.13,
            maxZ=30.93
        },
        [13] = {
            coord = vector3(-513.06, -263.2, 35.43),
            height = 17.6,
            width = 4.2,
            heading=293,
            --debugPoly=true,
            minZ=34.48,
            maxZ=36.28
        },
        [14] = {
            coord = vector3(-756.46, -35.84, 37.69),
            height = 17.6,
            width = 4.2,
            heading=297,
            --debugPoly=true,
            minZ=36.74,
            maxZ=38.54
        },
        [15] = {
            coord = vector3(-1285.33, 293.67, 64.83),
            height = 17.6,
            width = 4.2,
            heading=241,
            --debugPoly=true,
            minZ=63.88,
            maxZ=65.68
        },
        [16] = {
            coord = vector3(-806.68, 825.2, 202.81),
            height = 21.2,
            width = 4.2,
            heading=276,
            --debugPoly=true,
            minZ=200.46,
            maxZ=204.66
        },
    },

    DropLocations = {
        [1] = {
            coord = vector3(-1073.21, -265.35, 37.35),
            height = 21.2,
            width = 4.2,
            heading=296,
            --debugPoly=true,
            minZ=35.0,
            maxZ=39.2
        },
        [2] = {
            coord = vector3(-1411.45, -590.98, 29.99),
            height = 21.2,
            width = 4.2,
            heading=299,
            --debugPoly=true,
            minZ=27.64,
            maxZ=31.84
        },
        [3] = {
            coord = vector3(-678.68, -845.54, 23.53),
            height = 21.2,
            width = 4.2,
            heading=269,
            --debugPoly=true,
            minZ=21.18,
            maxZ=25.38
        },
        [4] = {
            coord = vector3(-159.11, -1565.46, 34.69),
            height = 21.2,
            width = 4.2,
            heading=321,
            --debugPoly=true,
            minZ=32.34,
            maxZ=36.54
        },
        [5] = {
            coord = vector3(442.12, -1685.31, 28.85),
            height = 21.2,
            width = 4.2,
            heading=321,
            --debugPoly=true,
            minZ=26.5,
            maxZ=30.7
        },
        [6] = {
            coord = vector3(1120.51, -958.97, 46.83),
            height = 21.2,
            width = 4.2,
            heading=286,
            --debugPoly=true,
            minZ=44.48,
            maxZ=48.68
        },
        [7] = {
            coord = vector3(1240.79, -377.77, 68.61),
            height = 21.2,
            width = 4.2,
            heading=249,
            --debugPoly=true,
            minZ=66.26,
            maxZ=70.46
        },
        [8] = {
            coord = vector3(923.66, -2226.07, 29.98),
            height = 21.2,
            width = 4.2,
            heading=354,
            --debugPoly=true,
            minZ=27.63,
            maxZ=31.83
        },
        [9] = {
            coord = vector3(1920.15, 3701.6, 32.26),
            height = 21.2,
            width = 4.2,
            heading=299,
            --debugPoly=true,
            minZ=29.91,
            maxZ=34.11
        },
        [10] = {
            coord = vector3(1661.91, 4875.87, 41.66),
            height = 21.2,
            width = 4.2,
            heading=8,
            --debugPoly=true,
            minZ=39.31,
            maxZ=43.51
        },
        [11] = {
            coord = vector3(-9.46, 6529.92, 30.95),
            height = 21.2,
            width = 4.2,
            heading=314,
            --debugPoly=true,
            minZ=28.6,
            maxZ=32.8
        },
        [12] = {
            coord = vector3(-3233.12, 1010.33, 11.72),
            height = 21.2,
            width = 4.2,
            heading=357,
            --debugPoly=true,
            minZ=9.37,
            maxZ=13.57
        },
        [13] = {
            coord = vector3(-1604.11, -401.71, 41.95),
            height = 21.2,
            width = 4.2,
            heading=322,
            --debugPoly=true,
            minZ=39.6,
            maxZ=43.8
        },
        [14] = {
            coord = vector3(-586.48, -255.96, 36.53),
            height = 21.2,
            width = 4.2,
            heading=31,
            --debugPoly=true,
            minZ=34.68,
            maxZ=37.48
        },
        [15] = {
            coord = vector3(23.51, -60.47, 63.2),
            height = 21.2,
            width = 4.2,
            heading=156,
            --debugPoly=true,
            minZ=60.55,
            maxZ=65.75
        },
        [16] = {
            coord = vector3(550.26, 172.54, 99.71),
            height = 21.2,
            width = 4.2,
            heading=161,
            --debugPoly=true,
            minZ=98.51,
            maxZ=100.91
        },
        [17] = {
            coord = vector3(-1048.62, -2540.53, 13.3),
            height = 21.2,
            width = 4.2,
            heading=151,
            --debugPoly=true,
            minZ=12.9,
            maxZ=14.9
        },
        [18] = {
            coord = vector3(-10.06, -544.39, 38.28),
            height = 21.2,
            width = 4.2,
            heading=91,
            --debugPoly=true,
            minZ=36.28,
            maxZ=39.88
        },
        [19] = {
            coord = vector3(-7.91, -258.19, 46.49),
            height = 21.2,
            width = 4.2,
            heading=71,
            --debugPoly=true,
            minZ=45.29,
            maxZ=47.69
        },
        [20] = {
            coord = vector3(-743.03, 818.9, 213.16),
            height = 21.2,
            width = 4.2,
            heading=38,
            --debugPoly=true,
            minZ=211.96,
            maxZ=214.36
        },
        [21] = {
            coord = vector3(218.25, 677.55, 188.87),
            height = 21.2,
            width = 4.2,
            heading=163,
            --debugPoly=true,
            minZ=187.67,
            maxZ=190.07
        },
        [22] = {
            coord = vector3(264.47, 1138.41, 221.36),
            height = 21.2,
            width = 4.2,
            heading=203,
            --debugPoly=true,
            minZ=220.16,
            maxZ=222.56
        },
        [23] = {
            coord = vector3(220.47, -1010.7, 28.82),
            height = 21.2,
            width = 4.2,
            heading=158,
            --debugPoly=true,
            minZ=28.02,
            maxZ=30.42
        },

    }
}

Config.NpcSkins = {
    [1] = {
        'a_f_m_skidrow_01',
        'a_f_m_soucentmc_01',
        'a_f_m_soucent_01',
        'a_f_m_soucent_02',
        'a_f_m_tourist_01',
        'a_f_m_trampbeac_01',
        'a_f_m_tramp_01',
        'a_f_o_genstreet_01',
        'a_f_o_indian_01',
        'a_f_o_ktown_01',
        'a_f_o_salton_01',
        'a_f_o_soucent_01',
        'a_f_o_soucent_02',
        'a_f_y_beach_01',
        'a_f_y_bevhills_01',
        'a_f_y_bevhills_02',
        'a_f_y_bevhills_03',
        'a_f_y_bevhills_04',
        'a_f_y_business_01',
        'a_f_y_business_02',
        'a_f_y_business_03',
        'a_f_y_business_04',
        'a_f_y_eastsa_01',
        'a_f_y_eastsa_02',
        'a_f_y_eastsa_03',
        'a_f_y_epsilon_01',
        'a_f_y_fitness_01',
        'a_f_y_fitness_02',
        'a_f_y_genhot_01',
        'a_f_y_golfer_01',
        'a_f_y_hiker_01',
        'a_f_y_hipster_01',
        'a_f_y_hipster_02',
        'a_f_y_hipster_03',
        'a_f_y_hipster_04',
        'a_f_y_indian_01',
        'a_f_y_juggalo_01',
        'a_f_y_runner_01',
        'a_f_y_rurmeth_01',
        'a_f_y_scdressy_01',
        'a_f_y_skater_01',
        'a_f_y_soucent_01',
        'a_f_y_soucent_02',
        'a_f_y_soucent_03',
        'a_f_y_tennis_01',
        'a_f_y_tourist_01',
        'a_f_y_tourist_02',
        'a_f_y_vinewood_01',
        'a_f_y_vinewood_02',
        'a_f_y_vinewood_03',
        'a_f_y_vinewood_04',
        'a_f_y_yoga_01',
        'g_f_y_ballas_01',
    },
    [2] = {
        'ig_barry',
        'ig_bestmen',
        'ig_beverly',
        'ig_car3guy1',
        'ig_car3guy2',
        'ig_casey',
        'ig_chef',
        'ig_chengsr',
        'ig_chrisformage',
        'ig_clay',
        'ig_claypain',
        'ig_cletus',
        'ig_dale',
        'ig_dreyfuss',
        'ig_fbisuit_01',
        'ig_floyd',
        'ig_groom',
        'ig_hao',
        'ig_hunter',
        'csb_prolsec',
        'ig_joeminuteman',
        'ig_josef',
        'ig_josh',
        'ig_lamardavis',
        'ig_lazlow',
        'ig_lestercrest',
        'ig_lifeinvad_01',
        'ig_lifeinvad_02',
        'ig_manuel',
        'ig_milton',
        'ig_mrk',
        'ig_nervousron',
        'ig_nigel',
        'ig_old_man1a',
        'ig_old_man2',
        'ig_oneil',
        'ig_orleans',
        'ig_ortega',
        'ig_paper',
        'ig_priest',
        'ig_prolsec_02',
        'ig_ramp_gang',
        'ig_ramp_hic',
        'ig_ramp_hipster',
        'ig_ramp_mex',
        'ig_roccopelosi',
        'ig_russiandrunk',
        'ig_siemonyetarian',
        'ig_solomon',
        'ig_stevehains',
        'ig_stretch',
        'ig_talina',
        'ig_taocheng',
        'ig_taostranslator',
        'ig_tenniscoach',
        'ig_terry',
        'ig_tomepsilon',
        'ig_tylerdix',
        'ig_wade',
        'ig_zimbor',
        's_m_m_paramedic_01',
        'a_m_m_afriamer_01',
        'a_m_m_beach_01',
        'a_m_m_beach_02',
        'a_m_m_bevhills_01',
        'a_m_m_bevhills_02',
        'a_m_m_business_01',
        'a_m_m_eastsa_01',
        'a_m_m_eastsa_02',
        'a_m_m_farmer_01',
        'a_m_m_fatlatin_01',
        'a_m_m_genfat_01',
        'a_m_m_genfat_02',
        'a_m_m_golfer_01',
        'a_m_m_hasjew_01',
        'a_m_m_hillbilly_01',
        'a_m_m_hillbilly_02',
        'a_m_m_indian_01',
        'a_m_m_ktown_01',
        'a_m_m_malibu_01',
        'a_m_m_mexcntry_01',
        'a_m_m_mexlabor_01',
        'a_m_m_og_boss_01',
        'a_m_m_paparazzi_01',
        'a_m_m_polynesian_01',
        'a_m_m_prolhost_01',
        'a_m_m_rurmeth_01',
    }
}

Config.CabSpawns = {
    -- left front
    vector4(908.61, -183.26, 73.77, 57.62),
    vector4(906.82, -186.06, 73.64, 58.57),
    vector4(905.22, -188.93, 73.45, 59.83),
    vector4(903.58, -191.52, 73.41, 57.3),

    -- left back
    vector4(897.6, -183.4, 73.38, 236.88),
    vector4(899.27, -180.37, 73.44, 238.41),

    -- right back
    vector4(911.43, -163.61, 73.96, 191.44),
    vector4(913.77, -159.84, 74.38, 190.57),

    -- right front
    vector4(920.23, -163.82, 74.42, 98.04),
    vector4(918.3, -167.28, 74.21, 103.19),
    vector4(916.28, -170.96, 74.04, 102.68)
}
