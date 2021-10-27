RegisterServerEvent('shop:buy', function(id, item, cost, amount)
    local license = GetPlayerIdentifier(id, 0)
    MySQL.Async.fetchAll('SELECT money FROM users WHERE license = @license', { 
        ['@license'] = license },
    function(result)
        money = tonumber(string.sub(json.encode(result), string.find(json.encode(result), "%d"), string.find(json.encode(result), "}")-1))
        if money < tonumber(cost) then
            TriggerClientEvent('shop:msg', id, "Dein Bargeld ist zu niedrig!")
        else
            MySQL.Async.execute('UPDATE users SET money = money - @cost WHERE license = @license', { 
                ['@cost'] = tonumber(cost),
                ['@license'] = license },
            function(result)
                TriggerClientEvent('shop:msg', id, math.ceil(cost).."$ gezahlt")
                TriggerEvent('inv:additem', item, id, amount)
            end)
        end
    end)
end)