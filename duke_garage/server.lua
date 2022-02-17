SetConvarReplicated("segewgewge", {"random", "bullshit"})

RegisterServerEvent("loadVehicles")
AddEventHandler("loadVehicles", function(player)
    local license = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @license', { ['@license'] = license }, function(result)
        TriggerClientEvent("loadVehiclesCallback", player, result)
    end)
end)

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

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

-- RegisterServerEvent('SaveVehicleToServer')
-- AddEventHandler('SaveVehicleToServer', function(data)
--     vehicles = GetConvar("vehicles", "nil")
--     table.insert(vehicles, data)
--     SetConvarReplicated("vehicles", vehicles)
-- end)

RegisterServerEvent('SpawnVehicle')
AddEventHandler('SpawnVehicle', function(id, player, slot)
    local license = GetPlayerIdentifier(player, 0)
    local slot = FilterVehicles(slot)
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @license AND id = @id', { ['@license'] = license, ['@id'] = id }, function(result)
        if result[1] == nil then
            msg = "Dieses Fahrzeug wurde nicht gefunden"
            TriggerClientEvent('SpawnVehicleCallback', msg)
        else
            msg = result[1].manifacturer.." "..result[1].displayName.." ausgeparkt"
            TriggerClientEvent('SpawnVehicleCallback', player, msg)
            TriggerClientEvent('SpawnVehicle', player, result, slot)
            -- local ModelHash = GetHashKey(result[1].name)
            -- --if not IsModelInCdimage(ModelHash) then return end
            --     --RequestModel(ModelHash)
            -- --while not HasModelLoaded(ModelHash) do
            --     --Citizen.Wait(10)
            -- --end
            -- Vehicle = CreateVehicle(ModelHash, slot.x, slot.y, slot.z, slot.h, true, false)
            -- config = json.decode(result[1].config)
            -- r1, g1, b1 = hex2rgb(config[1])
            -- r2, g2, b2 = hex2rgb(config[2])
            -- SetVehicleCustomPrimaryColour(Vehicle, r1, bg1, b1)
            -- SetVehicleCustomSecondaryColour(Vehicle, r2, g2, b2)
            -- if config[3] ~= "default" then
            --     SetVehicleModKit(0)
            --     for i = 1, #config[3] do
            --         SetVehicleMod(Vehicle, config[3][i][1], config[3][i][2])
            --     end
            -- end
            -- tab = {
            --     veh = Vehicle,
            --     owner = GetPlayerName(player)
            -- }
            -- table.insert(vehicles, tab)
        end
    end)
end)

RegisterCommand("convar", function()
    vehs = GetConvar("segewgewge", "nil")
    for i = 1, #vehs do
        print(vehs[i])
    end
end)