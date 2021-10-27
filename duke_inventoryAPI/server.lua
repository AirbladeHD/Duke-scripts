RegisterServerEvent('inv:refresh_inventory')
AddEventHandler('inv:refresh_inventory', function(player)
    local identifier = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT inventory, username FROM users WHERE license = @license', { 
        ['@license'] = identifier },
    function(result)
        local inventory = result[1].inventory
        local user = result[1].username
        SetConvarReplicated("inventory"..user, inventory)
    end)
end)

RegisterServerEvent('inv:registerItem')
AddEventHandler('inv:registerItem', function(item, desc, handler)
    MySQL.Async.fetchAll('SELECT name FROM items WHERE name = @item', {
        ['@item'] = item
    },
    function(result)
        if #result == 0 then
            if handler == nil then
                MySQL.Async.execute('INSERT INTO items (name, description) VALUES (@item, @desc)',
                { 
                    ['item'] = item,
                    ['desc'] = desc,
                },
                function(affectedRows)
                    print(item.." registriert")
                end)
            else
                MySQL.Async.execute('INSERT INTO items (name, description, handler) VALUES (@item, @desc, @handler)',
                { 
                    ['item'] = item,
                    ['desc'] = desc,
                    ['handler'] = handler,
                },
                function(affectedRows)
                    print(item.." als nutzbares Item registriert")
                end)
            end
        end
    end)
end)

function RegisterItem(item, desc, handler)
    MySQL.Async.fetchAll('SELECT name FROM items WHERE name = @item', {
        ['@item'] = item
    },
    function(result)
        if #result == 0 then
            if handler == nil then
                MySQL.Async.execute('INSERT INTO items (name, description) VALUES (@item, @desc)',
                { 
                    ['item'] = item,
                    ['desc'] = desc,
                },
                function(affectedRows)
                    print(item.." registriert")
                end)
            else
                MySQL.Async.execute('INSERT INTO items (name, description, handler) VALUES (@item, @desc, @handler)',
                { 
                    ['item'] = item,
                    ['desc'] = desc,
                    ['handler'] = handler,
                },
                function(affectedRows)
                    print(item.." als nutzbares Item registriert")
                end)
            end
        end
    end)
end

RegisterServerEvent('inv:addItem')
AddEventHandler('inv:addItem', function(item, amount, user)
    local inInv = false
    MySQL.Async.fetchAll('SELECT name FROM items WHERE name = @item', {
        ['@item'] = item
    },
    function(result)
        local license = GetPlayerIdentifier(user, 0)
        if result[1] == nil then
            local msg = "Dieses Item existiert nicht!"
            TriggerClientEvent('inv:callback', user, nil, msg)
        else
            MySQL.Async.fetchAll('SELECT inventory FROM users WHERE license = @license', {
                ['@license'] = license },
            function(result)
                local inventory = json.decode(result[1].inventory)
                for i = 1, #inventory, 1 do
                    if inventory[i].name == item then
                        inInv = true
                    end
                end
                if inInv == false then
                    table.insert(inventory, {name = item, amount = amount})
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                        ['@inventory'] = json.encode(inventory),
                        ['@license'] = license,
                        },
                    function(affectedRows)
                        local msg = item.." ("..amount..") hinzugefügt"
                        TriggerClientEvent('inv:callback', user, item, msg)
                    end)
                else
                    for i = 1, #inventory, 1 do
                        if inventory[i].name == item then
                            old_amount = inventory[i].amount
                        end
                    end
                    local new_amount = old_amount + amount
                    for i = 1, #inventory, 1 do
                        if inventory[i].name == item then
                            inventory[i].amount = math.ceil(new_amount)
                        end
                    end
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                        ['@inventory'] = json.encode(inventory),
                        ['@license'] = license,
                        },
                    function(affectedRows)
                        local msg = item.." ("..amount..") hinzugefügt"
                        TriggerClientEvent('inv:callback', user, item, msg)
                    end)
                end
            end)
        end
    end)
end)

RegisterServerEvent('inv:removeItem')
AddEventHandler('inv:removeItem', function(item, amount, user)
    local inInv = false
    MySQL.Async.fetchAll('SELECT name FROM items WHERE name = @item', {
        ['@item'] = item
    },
    function(result)
        local license = GetPlayerIdentifier(user, 0)
        if result[1] == nil then
            local msg = "Dieses Item existiert nicht!"
            TriggerClientEvent('inv:callback', user, nil, msg)
        else
            MySQL.Async.fetchAll('SELECT inventory FROM users WHERE license = @license', {
                ['@license'] = license },
            function(result)
                local inventory = json.decode(result[1].inventory)
                for i = 1, #inventory, 1 do
                    if inventory[i].name == item then
                        inInv = true
                    end
                end
                if inInv == false then
                    local msg = "Du hast nichts von diesem Item!"
                    TriggerClientEvent('inv:callback', user, nil, msg)
                else
                    for i = 1, #inventory, 1 do
                        if inventory[i].name == item then
                            old_amount = inventory[i].amount
                            index = i
                        end
                    end
                    local new_amount = old_amount - amount
                    if new_amount < 0 then
                        local msg = "Du hast nicht genug von diesem Item!"
                        TriggerClientEvent('inv:callback', user, nil, msg)
                        return
                    end
                    if new_amount == 0 then
                        table.remove(inventory, index)
                        MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                            ['@inventory'] = json.encode(inventory),
                            ['@license'] = license,
                            },
                        function(affectedRows)
                            local msg = item.." ("..amount..") entfernt!"
                            TriggerClientEvent('inv:removeitem_callback', user, item, amount, msg)
                        end)
                        return
                    end
                    inventory[index].amount = math.ceil(new_amount)
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                        ['@inventory'] = json.encode(inventory),
                        ['@license'] = license,
                        },
                    function(affectedRows)
                        local msg = item.." ("..amount..") entfernt!"
                        TriggerClientEvent('inv:removeitem_callback', user, item, amount, msg)
                    end)
                    return
                end
            end)
        end
    end)
end)

RegisterServerEvent('inv:GetInfo', function(item, user)
    MySQL.Async.fetchAll('SELECT handler, description FROM items WHERE name = @item', {
        ['@item'] = item
    },
    function(result)
        if result[1].handler ~= nil then
            SetConvarReplicated(item.."Handler", result[1].handler)
        end
        if result[1].description ~= nil then
            SetConvarReplicated(item.."Desc", result[1].description)
        end
    end)
end)

RegisterServerEvent('inv:RegisterItem', function(item, desc, handler)
    MySQL.Async.fetchAll('SELECT name FROM items WHERE name = @item', {
        ['@item'] = item
    },
    function(result)
        if #result == 0 then
            if handler == nil then
                MySQL.Async.execute('INSERT INTO items (name, description) VALUES (@item, @desc)',
                { 
                    ['item'] = item,
                    ['desc'] = desc,
                },
                function(affectedRows)
                    print(item.." registriert")
                end)
            else
                MySQL.Async.execute('INSERT INTO items (name, description, handler) VALUES (@item, @desc, @handler)',
                { 
                    ['item'] = item,
                    ['desc'] = desc,
                    ['handler'] = handler,
                },
                function(affectedRows)
                    print(item.." als nutzbares Item registriert")
                end)
            end
        end
    end)
end)

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local name = GetPlayerName(player)
    local identifier = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT inventory, username FROM users WHERE license = @license', { 
        ['@license'] = identifier },
    function(result)
        local inventory = result[1].inventory
        local user = result[1].username
        if name ~= user then
            MySQL.Async.execute('UPDATE users SET username = @username WHERE license = @license', {
                ['@license'] = identifier,
                ['@username'] = name },
            function(affectedRows)
                print("Namen aktualisiert")
                user = name
            end)
        end
        SetConvarReplicated("inventory"..user, inventory)
    end)
end

AddEventHandler("playerConnecting", OnPlayerConnecting)