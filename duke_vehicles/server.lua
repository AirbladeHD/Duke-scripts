RegisterServerEvent('buyVehicle')
AddEventHandler('buyVehicle', function(player, price, vehicleName, vehicleManifacturer, conf)
    license = GetPlayerIdentifier(player, 0)
    MySQL.Async.execute('INSERT INTO vehicles (owner, name, manifacturer, config) VALUES (@owner, @name, @manifacturer, @config)',
        { ['owner'] = license, ['name'] = vehicleName, ['manifacturer'] = vehicleManifacturer, ['config'] = json.encode(conf) },
    function()
        msg = "Fahrzeug gekauft"
        TriggerClientEvent('buyVehicleCallback', player, msg)
    end)
end)