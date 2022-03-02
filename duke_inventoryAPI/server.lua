function ReloadInventory(inventory, name)
    if inventory ~= "{}" then
        MySQL.Async.fetchAll("SELECT * FROM items", {}, 
        function(result)
            inventory = json.decode(inventory)
            inventoryData = {}
            for i = 1, #inventory do
                for e = 1, #result do
                    if inventory[i].name == result[e].name then
                        tab = {
                            name = inventory[i].name,
                            quant = inventory[i].quant,
                            desc = result[e].description,
                            handler = result[e].handler
                        }
                        table.insert(inventoryData, tab)
                    end
                end
            end
            SetConvarReplicated("inventory"..name, json.encode(inventoryData))
        end)
        return true
    else 
        SetConvarReplicated("inventory"..name, inventory) 
        return true
    end
end

RegisterServerEvent('refreshInventorys')
AddEventHandler('refreshInventorys', function()
    for _, playerId in ipairs(GetPlayers()) do
        local license = GetPlayerIdentifier(playerId, 0)
        local name = GetPlayerName(playerId)
         MySQL.Async.fetchAll('SELECT inventory FROM users WHERE license = @license', {
        ['@license'] = license
        },
        function(result)
            local inventory = result[1].inventory
            inventory = ReloadInventory(inventory, name)
        end)
    end
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
AddEventHandler('inv:addItem', function(item, quant, user)
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
                    table.insert(inventory, {name = item, quant = quant})
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                        ['@inventory'] = json.encode(inventory),
                        ['@license'] = license,
                        },
                    function(affectedRows)
                        local msg = item.." ("..quant..") hinzugefügt"
                        TriggerClientEvent('inv:callback', user, item, msg)
                    end)
                else
                    for i = 1, #inventory, 1 do
                        if inventory[i].name == item then
                            old_quant = inventory[i].quant
                        end
                    end
                    local new_quant = old_quant + quant
                    for i = 1, #inventory, 1 do
                        if inventory[i].name == item then
                            inventory[i].quant = math.ceil(new_quant)
                        end
                    end
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                        ['@inventory'] = json.encode(inventory),
                        ['@license'] = license,
                        },
                    function(affectedRows)
                        local msg = item.." ("..quant..") hinzugefügt"
                        TriggerClientEvent('inv:callback', user, item, msg)
                    end)
                end
            end)
        end
    end)
end)

RegisterServerEvent('inv:removeItem')
AddEventHandler('inv:removeItem', function(item, quant, user)
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
                            old_quant = inventory[i].quant
                            index = i
                        end
                    end
                    local new_quant = old_quant - quant
                    if new_quant < 0 then
                        local msg = "Du hast nicht genug von diesem Item!"
                        TriggerClientEvent('inv:callback', user, nil, msg)
                        return
                    end
                    if new_quant == 0 then
                        table.remove(inventory, index)
                        MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                            ['@inventory'] = json.encode(inventory),
                            ['@license'] = license,
                            },
                        function(affectedRows)
                            local msg = item.." ("..quant..") entfernt!"
                            TriggerClientEvent('inv:removeitem_callback', user, item, quant, msg)
                        end)
                        return
                    end
                    inventory[index].quant = math.ceil(new_quant)
                    MySQL.Async.execute('UPDATE users SET inventory = @inventory WHERE license = @license', {
                        ['@inventory'] = json.encode(inventory),
                        ['@license'] = license,
                        },
                    function(affectedRows)
                        local msg = item.." ("..quant..") entfernt!"
                        TriggerClientEvent('inv:removeitem_callback', user, item, quant, msg)
                    end)
                    return
                end
            end)
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