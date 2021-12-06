Config = {}

Config.Dealers = {
    {x = -1264.507, y = -359.0551, z = 36.90749},
}

all = {}

for i = 0, 49, 1 do
    table.insert(all, i)
end

Config.ImportVehicles = {
    
}

Config.Categories = {
    {name = "SUV", vehicles = {
        {name = "Baller", brand = "Gallivanter", price = 240000, hp = 350, turbo = 300, traktion = 500, handling = 900, mods = {1, 2, 3, 4}},
        {name = "BJXL", brand = "Karin", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "VWtoua19cf", displayName = "Touareg 2019 R-Line", brand = "VW", price = 54000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = all},
        {name = "Cavalcade", brand = "Albany", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Contender", brand = "Vapid", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Dubsta", brand = "Benefactor", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "FQ2", brand = "Fathom", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Granger", brand = "Declasse", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Gresley", brand = "Bravado", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Habanero", brand = "Emperor", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Huntley", brand = "Enus", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Landstalker", brand = "Dundreary", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Mesa", brand = "Canis", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
        {name = "Patriot", brand = "Mammoth", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {1, 2, 3, 4}},
    }},
    {name = "Supersport", vehicles = {
        {name = "Adder", brand = "Truffade", price = 240000, hp = 350, turbo = 300, traktion = 500, handling = 900, mods = {0, 1, 2, 3, 4}},
        {name = "Autarch", brand = "Överflöd", price = 200000, hp = 554, turbo = 500, traktion = 300, handling = 700, mods = {0, 1, 3, 7, 9, 15, 23}},
        {name = "Zentorno", brand = "Pegassi", price = 2400000, hp = 600, turbo = 550, traktion = 400, handling = 1000, mods = {0, 1, 3, 7, 9, 15, 23}},
        {name = "Prior", brand = "Tesla", price = 20000, hp = 900, turbo = 0, traktion = 800, handling = 750, mods = all},
        {name = "bolide", displayName = "Bolide", brand = "Bugatti", price = 20000, hp = 540, turbo = 300, traktion = 200, handling = 210, mods = all},
        {name = "benze55", displayName = "E55 AMG", brand = "Mercedes-Benz", price = 340000, hp = 540, turbo = 300, traktion = 200, handling = 210, mods = all},
        {name = "Bullet", brand = "Vapid", price = 2400000, hp = 230, turbo = 500, traktion = 600, handling = 500, mods = {0, 1, 2, 3, 4}}}
    }
}