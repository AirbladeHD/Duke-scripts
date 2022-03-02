vehicles = {}
SetConvarReplicated("vehicles", json.encode(vehicles))

RegisterServerEvent("loadVehicles")
AddEventHandler("loadVehicles", function(player)
    local license = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @license', { ['@license'] = license }, function(result)
        vehicles = GetConvar("vehicles", "nil")
        vehicles = json.decode(vehicles)
        vehicles_available = {}
        vehicles_outside = {}
        if(#result > 0) then
            for i = 1, #result do
                inTable = false
                for e = 1, #vehicles do
                    if result[i]["id"] == vehicles[e]["id"] then
                        inTable = true
                        table.insert(result[i], vehicles[e]["veh"])
                    end
                end
                if inTable == false then
                    table.insert(vehicles_available, result[i])
                else

                    table.insert(vehicles_outside, result[i])
                end
            end
        end
        TriggerClientEvent("loadVehiclesCallback", player, vehicles_available, vehicles_outside)
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

RegisterServerEvent('SaveVehicleToServer')
AddEventHandler('SaveVehicleToServer', function(data)
    vehicles = GetConvar("vehicles", "nil")
    vehicles = json.decode(vehicles)
    table.insert(vehicles, data)
    SetConvarReplicated("vehicles", json.encode(vehicles))
end)

RegisterServerEvent('OverwriteVehicleDatabase')
AddEventHandler('OverwriteVehicleDatabase', function(data)
    SetConvarReplicated("vehicles", json.encode(data))
end)

RegisterServerEvent('SpawnVehicle')
AddEventHandler('SpawnVehicle', function(id, player, slot)
    local license = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @license AND id = @id', { ['@license'] = license, ['@id'] = id }, function(result)
        if result[1] == nil then
            msg = "Dieses Fahrzeug wurde nicht gefunden"
            TriggerClientEvent('SpawnVehicleCallback', player, msg)
        else
            msg = result[1].manifacturer.." "..result[1].displayName.." ausgeparkt"
            TriggerClientEvent('SpawnVehicleCallback', player, msg)
            TriggerClientEvent('SpawnVehicle', player, result, slot)
        end
    end)
end)

RegisterServerEvent("FetchVehicles")
AddEventHandler("FetchVehicles", function(player)
    SetConvarReplicated("VehicleCoords", "[]")
    AllVehicles = {}
    TriggerClientEvent("SendVehicleInfo", -1)
    Citizen.Wait(200)
    SetConvarReplicated("VehicleCoords", json.encode(AllVehicles))
    TriggerClientEvent("DataFetched", player, AllVehicles)
end)

RegisterServerEvent("FetchVehiclesCallback")
AddEventHandler("FetchVehiclesCallback", function(data)
    if #data > 0 then
        table.insert(AllVehicles, data)
    end
end)