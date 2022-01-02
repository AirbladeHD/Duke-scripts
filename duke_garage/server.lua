RegisterServerEvent("loadVehicles")
AddEventHandler("loadVehicles", function(player)
    local license = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @license', { ['@license'] = license }, function(result)
        TriggerClientEvent("loadVehiclesCallback", player, result)
    end)
end)

RegisterServerEvent('SpawnVehicle')
AddEventHandler('SpawnVehicle', function(id, player, slot)
    local license = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE owner = @license AND id = @id', { ['@license'] = license, ['@id'] = id }, function(result)
        if result[1] == nil then
            msg = "Dieses Fahrzeug wurde nicht gefunden"
            TriggerClientEvent('SpawnVehicleCallback', msg)
        else
            msg = result[1].manifacturer.." "..result[1].displayName.." ausgeparkt"
            TriggerClientEvent('SpawnVehicleCallback', player, msg)
            TriggerClientEvent('SpawnVehicle', player, result, slot)
        end
    end)
end)