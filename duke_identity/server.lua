function GenerateNumber()
    num = "01525 "
    for i = 1, 5 do
        local r = math.random(1,10)
        num = num..r
    end
    return num
end

colors = {
    white = "\x1B[0m",
    red = "\x1B[31m",
    green = "\x1B[32m",
    yellow = "\x1B[33m",
    blue = "\x1B[36m"
}

SetConvarReplicated("colors", json.encode(colors))

function SetInventoryData(inventory, name)
    if inventory ~= "{}" then
        inventory = json.decode(inventory)
        inventoryData = {}
        MySQL.Async.fetchAll("SELECT * FROM items", {}, 
        function(result)
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
            print(colors.green.."[INFO] Inventar von "..name.." geladen")
        end)
        return true
    else 
        SetConvarReplicated("inventory"..name, inventory) 
        print(colors.green.."[INFO] Inventar von "..name.." ist leer")
        return true
    end
end

RegisterCommand("reloadInv", function()
    RefreshInventorys()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        RefreshInventorys()
    end
end)

RegisterServerEvent("OverwriteEntry")
AddEventHandler("OverwriteEntry", function(player)
    local license = GetPlayerIdentifier(player, 0)
    local name = GetPlayerName(player)
    MySQL.Async.execute('UPDATE users SET entry = 1 WHERE license = @license', {
        ['@license'] = license
    },
    function(affectedRows)
        SetConvarReplicated("entry"..name, "1")
        print(colors.green.."[INFO]"..name.." ist erfolgreich eingereist")
    end)
end)

RegisterServerEvent("SavePlayerData")
AddEventHandler("SavePlayerData", function(player, data)
    local license = GetPlayerIdentifier(player, 0)
    local name = GetPlayerName(player)
    MySQL.Async.execute('UPDATE users SET firstName = @firstName, lastName = @lastName, gender = @gender, family = @family, size = @size, eyeColor = @eyeColor, dob = @dob, formerJob = @formerJob, font = @font, previousHabits =  @previousHabits WHERE license = @license', {
        ['@firstName'] = data.firstName,
        ['@lastName'] = data.lastName,
        ['@gender'] = data.gender,
        ['@family'] = data.family,
        ['@size'] = data.size,
        ['@eyeColor'] = data.eyeColor,
        ['@dob'] = data.dob,
        ['@formerJob'] = data.formerJob,
        ['@font'] = data.font,
        ['@previousHabits'] = json.encode(data.previousHabits),
        ['@license'] = license,
    },
    function(affectedRows)
        print(colors.green.."[INFO]"..affectedRows.." Zeile verändert. Persönliche Daten von "..name.." erfasst.")
        SetConvarReplicated("data"..name, json.encode(data))
    end)
end)

local function OnPlayerConnecting(name, setKickReason, deferrals)
    colors = GetConvar("colors", "error")
    colors = json.decode(colors)
    local player = source
    local name = GetPlayerName(player)
    local identifier = GetPlayerIdentifier(player, 0)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', { 
        ['@license'] = identifier },
    function(result)
        local users = json.encode(result)
        if not next(result) then
            number = GenerateNumber()
            MySQL.Async.execute('INSERT INTO users (username, license, number) VALUES (@username, @license, @number)', {
                ['@username'] = name,
                ['@license'] = identifier,
                ['@number'] = number,
            },
            function(affectedRows)
               print(colors.green.."[INFO] "..affectedRows.." Zeile eingefügt. "..name.." registriert.")
                MySQL.Async.fetchAll('SELECT entry, coords, style, inventory FROM users WHERE license = @license', { 
                    ['@license'] = identifier },
                function(result)
                    local entry = result[1].entry
                    local coords =  result[1].coords
                    local style =  result[1].style
                    local inventory = result[1].inventory
                    if entry == false then
                        SetConvarReplicated("entry"..name, "0")
                    else
                        SetConvarReplicated("entry"..name, "1")
                        SetConvarReplicated("coords"..name, coords)
                        while SetInventoryData(inventory, name) ~= true do
                            Citizen.Wait(1)
                        end
                    end
                    if style == false then
                        SetConvarReplicated("style"..name, "0")
                    else
                        SetConvarReplicated("style"..name, style)
                        while SetInventoryData(inventory, name) ~= true do
                            Citizen.Wait(1)
                        end
                    end
                end)
                print(colors.green.."[INFO] Nutzerdaten erfasst")
            end)
        else
            MySQL.Async.fetchAll('SELECT username, entry, coords, style, inventory FROM users WHERE license = @license', { 
                ['@license'] = identifier },
            function(result)
                local entry = result[1].entry
                local coords =  result[1].coords
                local style =  result[1].style
                local inventory = result[1].inventory
                local user = result[1].username
                if name ~= user then
                    MySQL.Async.execute('UPDATE users SET username = @username WHERE license = @license', {
                        ['@license'] = identifier,
                        ['@username'] = name },
                    function(affectedRows)
                        print(colors.red.."[ERROR] Name von "..user.." stimmt nicht mehr mit der Datenbank überein!")
                        print(colors.green.."[INFO] Namen von "..user.." aktualisiert -> Neuer Name: "..name)
                        user = name
                    end)
                end
                if entry == false then
                    SetConvarReplicated("entry"..name, "0")
                else
                    SetConvarReplicated("entry"..name, "1")
                    SetConvarReplicated("coords"..name, coords)
                    MySQL.Async.fetchAll('SELECT firstName, lastName, gender, family, size, eyeColor, dob, formerJob, font, previousHabits FROM users WHERE license = @license', {
                        ['@license'] = identifier },
                    function(playerData)
                        print(colors.green.."[INFO] Persönliche Daten von "..name.." geladen")
                        SetConvarReplicated("data"..name, json.encode(playerData[1]))
                    end)
                end
                if style == false then
                    SetConvarReplicated("style"..name, "0")
                else
                    SetConvarReplicated("style"..name, style)
                    while SetInventoryData(inventory, name) ~= true do
                        Citizen.Wait(1)
                    end
                end
            end)
            print(colors.green.."[INFO] Nutzerdaten erfasst")
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
    local entry = GetConvar("entry"..name, "error")
    if tonumber(entry) == 1 then
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
                print(colors.green.."[INFO] Koordinaten von "..name.." gespeichert")
            end)
        end)
    end
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
        print(colors.green.."[INFO] Aussehen von "..name.." gespeichert")
        SetConvarReplicated("style"..name, style)
    end)
end)