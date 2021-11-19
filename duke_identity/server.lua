--[[RegisterServerEvent('register')
AddEventHandler('register', function()
    for _, playerId in ipairs(GetPlayers()) do
        local name = GetPlayerName(playerId)
        local license = GetPlayerIdentifier(playerId, 0)
        MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', { 
            ['@license'] = license },
        function(result)
            local users = json.encode(result)
            if not next(result) then
                MySQL.Async.execute('INSERT INTO users (username, license) VALUES (@username, @license)', {
                    ['@username'] = name,
                    ['@license'] = license,
                },
                function(affectedRows)
                   print(affectedRows.." Zeile eingefügt. "..name.." registriert.")
                end)
            end
        end)
    end
end)]]--

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local name = GetPlayerName(player)
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
                MySQL.Async.fetchAll('SELECT entry, coords, style FROM users WHERE license = @license', { 
                    ['@license'] = identifier },
                function(result)
                    local entry = result[1].entry
                    local coords =  result[1].coords
                    local style =  result[1].style
                    if entry == false then
                        SetConvarReplicated("entry"..name, "0")
                    else
                        SetConvarReplicated("entry"..name, "1")
                        SetConvarReplicated("coords"..name, coords)
                    end
                    if style == false then
                        SetConvarReplicated("style"..name, "0")
                    else
                        SetConvarReplicated("style"..name, style)
                    end
                end)
                print("Nutzerdaten erfasst")
            end)
        else
            MySQL.Async.fetchAll('SELECT entry, coords, style FROM users WHERE license = @license', { 
                ['@license'] = identifier },
            function(result)
                local entry = result[1].entry
                local coords =  result[1].coords
                local style =  result[1].style
                if entry == false then
                    SetConvarReplicated("entry"..name, "0")
                else
                    SetConvarReplicated("entry"..name, "1")
                    SetConvarReplicated("coords"..name, coords)
                end
                if style == false then
                    SetConvarReplicated("style"..name, "0")
                else
                    SetConvarReplicated("style"..name, style)
                end
            end)
            print("Nutzerdaten erfasst")
        end
    end)
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler('playerDropped', function (reason)
    local playerPed = GetPlayerPed(source)
    local player = source
    local name = GetPlayerName(player)
    local lastCoords = GetEntityCoords(playerPed)
    local license = GetPlayerIdentifier(source, 0)
    local x = lastCoords.x
    local y = lastCoords.y
    local z = lastCoords.z
    local coords = {x = lastCoords.x, y = lastCoords.y, z = lastCoords.z}
    MySQL.Async.fetchAll('SELECT coords FROM users WHERE license = @license', {
        ['@license'] = license
    },
    function(result)
        coords = json.encode(coords)
        MySQL.Async.execute('UPDATE users SET coords = @coords WHERE license = @license', {
            ['@coords'] = coords,
            ['@license'] = license
        },
        function(affectedRows)
            print("Koordinaten von "..name.." gespeichert")
        end)
    end)
end)

RegisterServerEvent('identity:saveStyle')
AddEventHandler('identity:saveStyle', function(user, style)
    local license = GetPlayerIdentifier(user, 0)
    local name = GetPlayerName(user)
    local style = json.encode(style)
    MySQL.Async.execute('UPDATE users SET style = @style WHERE license = @license', {
        ['@style'] = style,
        ['@license'] = license
    },
    function(affectedRows)
        print("Aussehen von "..name.." gespeichert")
    end)
end)

RegisterServerEvent('duke:entry')
AddEventHandler('duke:entry', function()
    --[[local name = source
    local identifier = GetPlayerIdentifier(name, 0)
    MySQL.Async.fetchAll('SELECT entry, username FROM users WHERE license = @license', { 
        ['@license'] = identifier },
    function(result)
        local entry = result[1].entry
        local user = result[1].username
        print(user)
        print(entry)
        if entry == 0 then
            SetConvarReplicated("entry"..user, false)
        else
            SetConvarReplicated("entry"..user, true)
        end
    end)]]--
    print("Test")
end)