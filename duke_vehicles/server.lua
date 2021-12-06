RegisterServerEvent('buyVehicle')
AddEventHandler('buyVehicle', function(player, price, vehicleName, vehicleManifacturer, conf, dname)
    license = GetPlayerIdentifier(player, 0)
    MySQL.Async.execute('INSERT INTO vehicles (owner, name, displayName, manifacturer, config) VALUES (@owner, @name, @dname, @manifacturer, @config)',
        { ['owner'] = license, ['name'] = vehicleName, ['dname'] = dname, ['manifacturer'] = vehicleManifacturer, ['config'] = json.encode(conf) },
    function()
        msg = "Fahrzeug gekauft"
        TriggerClientEvent('buyVehicleCallback', player, msg)
    end)
end)