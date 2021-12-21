RegisterServerEvent('buyVehicle')
AddEventHandler('buyVehicle', function(player, price, vehicleName, vehicleManifacturer, conf, dname, categorie)
    license = GetPlayerIdentifier(player, 0)
    MySQL.Async.execute('INSERT INTO vehicles (owner, name, displayName, manifacturer, categorie, config) VALUES (@owner, @name, @dname, @manifacturer, @categorie, @config)',
        { ['owner'] = license, ['name'] = vehicleName, ['dname'] = dname, ['manifacturer'] = vehicleManifacturer, ['categorie'] = categorie, ['config'] = json.encode(conf) },
    function()
        msg = "Fahrzeug gekauft"
        TriggerClientEvent('buyVehicleCallback', player, msg)
    end)
end)

RegisterServerEvent("getowner")
AddEventHandler("getowner", function(vehicle)
    TriggerClientEvent("delete", -1, vehicle)
end)