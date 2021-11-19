RegisterServerEvent('bank:deduct')
AddEventHandler('bank:deduct', function(id, amount)
    local license = GetPlayerIdentifier(id, 0)
    MySQL.Async.fetchAll('SELECT balance FROM users WHERE license = @license', { 
        ['@license'] = license },
    function(result)
        balance = tonumber(string.sub(json.encode(result), string.find(json.encode(result), "%d"), string.find(json.encode(result), "}")-1))
        if balance < tonumber(amount) then
            TriggerClientEvent('bank:close', id, "Dein Guthaben ist zu niedrig!")
        else
            MySQL.Async.execute('UPDATE users SET balance = balance - @amount WHERE license = @license', { 
                ['@amount'] = tonumber(amount),
                ['@license'] = license },
            function(result)
                MySQL.Async.execute('UPDATE users SET money = money + @amount WHERE license = @license', { 
                    ['@amount'] = tonumber(amount),
                    ['@license'] = license },
                function(result)
                    TriggerClientEvent('bank:close', id, "Umsatz gebucht")
                end)
            end)
        end
    end)
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(id, amount)
    local license = GetPlayerIdentifier(id, 0)
    MySQL.Async.fetchAll('SELECT money FROM users WHERE license = @license', { 
        ['@license'] = license },
    function(result)
        money = tonumber(string.sub(json.encode(result), string.find(json.encode(result), "%d"), string.find(json.encode(result), "}")-1))
        if money < tonumber(amount) then
            TriggerClientEvent('bank:close', id, "Dein Bargeld ist zu niedrig!")
        else
            MySQL.Async.execute('UPDATE users SET balance = balance + @amount WHERE license = @license', { 
                ['@amount'] = tonumber(amount),
                ['@license'] = license },
            function(result)
                MySQL.Async.execute('UPDATE users SET money = money - @amount WHERE license = @license', { 
                    ['@amount'] = tonumber(amount),
                    ['@license'] = license },
                function(result)
                    TriggerClientEvent('bank:close', id, "Umsatz gebucht")
                end)
            end)
        end
    end)
end)

RegisterServerEvent('bank:pull_money')
AddEventHandler('bank:pull_money', function()
    for _, playerId in ipairs(GetPlayers()) do
        local license = GetPlayerIdentifier(playerId, 0)
        local name = GetPlayerName(playerId)
        MySQL.Async.fetchAll('SELECT money FROM users WHERE license = @license', { 
            ['@license'] = license },
        function(result)
            local money = json.encode(result)
            MySQL.Async.fetchAll('SELECT balance FROM users WHERE license = @license', { 
                ['@license'] = license },
            function(result)
                local balance = json.encode(result)               
                SetConvarReplicated("money"..name, string.sub(money, string.find(money, "%d"), string.find(money, "}")-1))
                SetConvarReplicated("balance"..name, string.sub(balance, string.find(balance, "%d"), string.find(balance, "}")-1))
            end)
        end)
    end
end)

--[[local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local identifier = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', { 
        ['@license'] = identifier },
    function(result)
        local users = json.encode(result)
        if not next(result) then
            MySQL.Async.execute('INSERT INTO users (username, license) VALUES (@username, @license)', {
                ['@username'] = name,
                ['@license'] = identifier,
            },
            function(affectedRows)
               print(affectedRows.." Zeile eingefügt. "..name.." registriert.")
               MySQL.Async.fetchAll('SELECT money FROM users WHERE license = @license', { 
                    ['@license'] = identifier 
                },
                function(result)
                    local money = json.encode(result)
                    MySQL.Async.fetchAll('SELECT balance FROM users WHERE license = @license', { 
                        ['@license'] = identifier 
                    },
                    function(result)
                        local balance = json.encode(result)               
                        SetConvarReplicated("money"..name, string.sub(money, string.find(money, "%d"), string.find(money, "}")-1))
                        SetConvarReplicated("balance"..name, string.sub(balance, string.find(balance, "%d"), string.find(balance, "}")-1))
                    end)
                end)
            end)
        else
            MySQL.Async.fetchAll('SELECT money FROM users WHERE license = @license', { 
                ['@license'] = identifier },
            function(result)
                local money = json.encode(result)
                MySQL.Async.fetchAll('SELECT balance FROM users WHERE license = @license', { 
                    ['@license'] = identifier },
                function(result)
                    local balance = json.encode(result)               
                    SetConvarReplicated("money"..name, string.sub(money, string.find(money, "%d"), string.find(money, "}")-1))
                    SetConvarReplicated("balance"..name, string.sub(balance, string.find(balance, "%d"), string.find(balance, "}")-1))
                end)
            end)
        end
    end)
end

AddEventHandler("playerConnecting", OnPlayerConnecting)]]--