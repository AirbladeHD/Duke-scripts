GarageOpen = false

function SetDisplay(bool, vehicles)
    display = bool
    SetNuiFocus(bool, bool)
    if vehicles then
        SendNUIMessage({
            type = "ui",
            display = bool,
            vehicles = vehicles,
        })
    else
        SendNUIMessage({
            type = "ui",
            display = bool,
        })
    end
end

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

for i=1, #Config.Garages, 1 do
    local blip = AddBlipForCoord(Config.Garages[i].x, Config.Garages[i].y, Config.Garages[i].z)
    SetBlipSprite(blip, 50)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Garage")
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for i=1, #Config.Garages, 1 do
            if GetDistanceBetweenCoords(Config.Garages[i].x, Config.Garages[i].y, Config.Garages[i].z, playerCoords) < 1.0 and GarageOpen == false then
                SetTextFont(0)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextEntry("STRING")
                AddTextComponentString("Drücke E um die Garage zu öffnen.")
                DrawText(0.005, 0.01)
                DrawRect(150, 100, 0.37, 0.10, 40, 40, 40, 155)
                openGarage(i)
            end
            DrawMarker(1, Config.Garages[i].x, Config.Garages[i].y, Config.Garages[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, nil, nil, false)
        end
    end
end)

function openGarage(i)
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            GarageOpen = true
            local player = GetPlayerServerId(PlayerId())
            TriggerServerEvent("loadVehicles", player)
            currentGarage = i
        end
    end)
end

RegisterCommand("convar", function()
    vehs = GetConvar("vehicles", "nil")
    print("Laenge: "..#vehs)
    for i = 1, #vehs do
        print(vehs[i])
    end
end)

RegisterNUICallback("error", function(data)
    print(data.error)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
    GarageOpen = false
end)

RegisterNUICallback('out', function(data)
    SetDisplay(false)
    GarageOpen = false
    vehicles = GetConvar("vehicles", "nil")
    slot = findSlot(currentGarage)
    if slot ~= 0 then
        local player = GetPlayerServerId(PlayerId())
        TriggerServerEvent('SpawnVehicle', data.id, player, slot)
    else
        ShowNotification("Kein Parkplatz gefunden")
    end
end)

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function FilterVehicles(potential)
    local indexes = {}
    print(#vehicles)
    for i = 1, #vehicles do
        vehCoords = GetEntityCoords(vehicles[i].veh)
        for p = 1, #potential do
            local distance = Vdist(vehCoords.x, vehCoords.y, vehCoords.z, potential[p].x, potential[p].y, potential[p].z)
            if distance < 3 and table.contains(indexes, p) == false then
                table.insert(indexes, p)
            end
        end
    end
    for i = 1, #indexes do
        potential[indexes[i]] = 0
    end
    new = {}
    for i = 1, #potential do
        if potential[i] ~= 0 then
            table.insert(new, potential[i])
        end
    end
    return new
end

function FilterPeds(potential)
    players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        tab = {
            x = targetCoords.x,
            y = targetCoords.y,
            z = targetCoords.z
        }
        table.insert(players, tab)
    end
    indexes = {}
    for i = 1, #potential do
        for l = 1, #players do
            local dist = Vdist(players[l].x, players[l].y, players[l].z, potential[i].x, potential[i].y, potential[i].z)
            if dist < 3 then
                table.insert(indexes, i)
            end
        end
    end
    for i = 1, #indexes do
        table.remove(potential, indexes[i])
    end
    return potential
end

function FilterExistingVehicles(potential)
    for i = 1, #potential do
        veh = GetClosestVehicle(potential[i].x, potential[i].y, potential[i].z, 3.00, 0)
        if veh == 0 then
            return potential[i]
        end
    end
end

function findSlot(lot)
    local potential = {}
    for f = 1, #Config.ParkingLots[lot].slots do
        tab = {
            x = Config.ParkingLots[lot].slots[f].x,
            y = Config.ParkingLots[lot].slots[f].y,
            z = Config.ParkingLots[lot].slots[f].z,
            h = Config.ParkingLots[lot].slots[f].h,
            id = Config.ParkingLots[lot].slots[f].id
        }
        table.insert(potential, tab)
    end
    local potential = FilterVehicles(potential)
    local potential = FilterPeds(potential)
    local slot = FilterExistingVehicles(potential)
    if slot ~= nil then
        return slot
    else
        return 0
    end
end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(2000)
--         if #vehicles == 0 then return end
--         for i = 1, #vehicles do
--             vehCoords = GetEntityCoords(vehicles[i].veh)
--             if vehCoords.x == 0 and vehCoords.y == 0 and vehCoords.z == 0 then
--                 DeleteVehicle(vehicles[i].veh)
--                 table.remove(vehicles, i)
--             end
--         end
--     end
-- end)

RegisterCommand('delete', function()
    if #vehicles == 0 then return end
    for i = 1, #vehicles do
        DeleteVehicle(vehicles[i].veh)
        table.remove(vehicles, i)
    end
    local targetCoords = GetEntityCoords(PlayerPedId())
    veh = GetClosestVehicle(targetCoords.x, targetCoords.y, targetCoords.z, 3.00, 0)
    print(veh)
    DeleteVehicle(veh)
end)

RegisterCommand("slot", function()
    slot = findSlot(1)
    print(slot.id)
end)

RegisterCommand("spawn", function()
    MyPed = PlayerPedId()
    local ModelHash = GetHashKey("Adder")
    if not IsModelInCdimage(ModelHash) then return end
        RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    Vehicle = CreateVehicle(ModelHash, GetEntityCoords(MyPed), GetEntityHeading(MyPed), true, false)
    tab = {
        veh = Vehicle,
        owner = GetPlayerName(PlayerId())
    }
    table.insert(vehicles, tab)
end)

RegisterCommand("vehicles", function()
    print(GetAllVehicles())
end)

RegisterNetEvent("loadVehiclesCallback")
AddEventHandler("loadVehiclesCallback", function(vehicles)
    for i = 1, #vehicles, 1 do
        config = json.decode(vehicles[i]["config"])
        vehicles[i].config = config
    end
    SetDisplay(true, vehicles)
end)

RegisterNetEvent("SpawnVehicleCallback")
AddEventHandler("SpawnVehicleCallback", function(msg)
    ShowNotification(msg)
end)

RegisterNetEvent("SpawnVehicle")
AddEventHandler("SpawnVehicle", function(result, slot)
    local ModelHash = GetHashKey(result[1].name)
    if not IsModelInCdimage(ModelHash) then return end
        RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    Vehicle = CreateVehicle(ModelHash, slot.x, slot.y, slot.z, slot.h, true, false)
    config = json.decode(result[1].config)
    r1, g1, b1 = hex2rgb(config[1])
    r2, g2, b2 = hex2rgb(config[2])
    SetVehicleCustomPrimaryColour(Vehicle, r1, bg1, b1)
    SetVehicleCustomSecondaryColour(Vehicle, r2, g2, b2)
    if config[3] ~= "default" then
        SetVehicleModKit(0)
        for i = 1, #config[3] do
            SetVehicleMod(Vehicle, config[3][i][1], config[3][i][2])
        end
    end
    tab = {
        veh = Vehicle,
        owner = GetPlayerName(PlayerId())
    }
    TriggerServerEvent("SaveVehicleToServer", tab)
end)