_Pool = NativeUI.CreatePool()
playerPed = PlayerPedId()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsControlJustReleased(0, 289) then
            openInventory()
        end
        _Pool:ProcessMenus()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        local player = PlayerId()
        local id = GetPlayerServerId(PlayerId())
        TriggerServerEvent('inv:refresh_inventory', id)
        local inventory = GetConvar("inventory"..GetPlayerName(player), "Abrufen des Inventars fehlgeschlagen")
        inventory = json.decode(inventory)
        if inventory ~= "{}" then
            for i = 1, #inventory, 1 do
                TriggerServerEvent('inv:GetInfo', inventory[i].name, GetPlayerServerId(PlayerId()))
            end
        end
    end
end)

RegisterCommand('regitem', function(source, args, raw)
    TriggerEvent('inv:RegisterItem', args[1])
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

RegisterNetEvent('inv:callback')
AddEventHandler('inv:callback', function(item, msg)
    local id = GetPlayerServerId(PlayerId())
    ShowNotification(msg)
    TriggerServerEvent('inv:refresh_inventory', id)
end)

RegisterNetEvent('inv:additem_callback')
AddEventHandler('inv:additem_callback', function(item, amount, msg)
    local id = GetPlayerServerId(PlayerId())
    if item == nil then
        ShowNotification(msg)
        TriggerServerEvent('inv:refresh_inventory', id)
    else
        ShowNotification(item.." ("..amount..") hinzugefügt")
        TriggerServerEvent('inv:refresh_inventory', id)
    end
end)

RegisterNetEvent('inv:removeitem_callback')
AddEventHandler('inv:removeitem_callback', function(item, amount, msg)
    local id = GetPlayerServerId(PlayerId())
    if item == nil then
        ShowNotification(msg)
        TriggerServerEvent('inv:refresh_inventory', id)
    else
        ShowNotification(item.." ("..amount..") entfernt")
        TriggerServerEvent('inv:refresh_inventory', id)
    end
end)

RegisterCommand('refresh_inventory', function(source, args, raw)
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent('inv:refresh_inventory', id)
end)

RegisterCommand('additem', function(source, args, raw)
    local id = GetPlayerServerId(PlayerId())
    if args[2] == nil then
        ShowNotification("Du musst eine Menge angeben")
    elseif tonumber(args[2]) < 0 then
        ShowNotification("Die Menge muss größer als 0 sein")
    else
        TriggerServerEvent('inv:additem', args[1], args[2], id)
    end
    --local inventory = {Trauben = {name = "Trauben", amount = 10}, Apfel = {name = "Apfel", amount = 20}}
    --local tab = {name = "Trauben", amount = 10}
    --tab.group = 8
    --print(inventory[2])
end)

RegisterCommand('rmvitem', function(source, args, raw)
    local id = GetPlayerServerId(PlayerId())
    if args[2] == nil then
        ShowNotification("Du musst eine Menge angeben")
    elseif tonumber(args[2]) < 0 then
        ShowNotification("Die Menge muss größer als 0 sein")
    else
        TriggerServerEvent('inv:removeitem', args[1], args[2], id)
    end
end)

function openInventory()
    local player = PlayerId()
    local playerPed = PlayerPedId()
    local id = GetPlayerServerId(player)
    menu = NativeUI.CreateMenu('Inventar', 'Item auswählen:')
    _Pool:Add(menu)
    _Pool:MouseControlsEnabled (false)
    _Pool:MouseEdgeEnabled (false)
    _Pool:ControlDisablingEnabled(false)
    local inventory = GetConvar("inventory"..GetPlayerName(player), "Abrufen des Inventars fehlgeschlagen")
    if inventory == "{}" then
        local item = NativeUI.CreateItem('Leer', 'Du hast nichts in deinem Inventar')
        menu:AddItem(item)
    else
        local inventory = json.decode(inventory)
        for i = 1, #inventory, 1 do
            TriggerServerEvent('inv:GetInfo', inventory[i].name, GetPlayerServerId(PlayerId()))
            local desc = GetConvar(inventory[i].name.."Desc", "No Desc")
            local item = NativeUI.CreateItem(inventory[i].name.." ("..inventory[i].amount..")", GetConvar(inventory[i].name.."Desc", "No Desc"))
            menu:AddItem(item)
            item.Activated = function(sender, index)
                local handler = GetConvar(inventory[i].name.."Handler", "No Handler")
                if handler ~= "No Handler" then
                    local func = load(handler)
                    func()
                end
            end
        end
    end
    menu:Visible(true)
end