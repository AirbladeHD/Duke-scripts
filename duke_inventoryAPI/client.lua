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
AddEventHandler('inv:additem_callback', function(item, quant, msg)
    local id = GetPlayerServerId(PlayerId())
    if item == nil then
        ShowNotification(msg)
        TriggerServerEvent('inv:refresh_inventory', id)
    else
        ShowNotification(item.." ("..quant..") hinzugefügt")
        TriggerServerEvent('inv:refresh_inventory', id)
    end
end)

RegisterNetEvent('inv:removeitem_callback')
AddEventHandler('inv:removeitem_callback', function(item, quant, msg)
    local id = GetPlayerServerId(PlayerId())
    if item == nil then
        ShowNotification(msg)
        TriggerServerEvent('inv:refresh_inventory', id)
    else
        ShowNotification(item.." ("..quant..") entfernt")
        TriggerServerEvent('inv:refresh_inventory', id)
    end
end)

RegisterCommand("reload", function()
    local inventory = {{name = "Trauben", quant = 10}}
    print(json.encode(inventory))
    SetInventoryData(json.encode(inventory), "Airblade")
end)

RegisterCommand('additem', function(source, args, raw)
    local id = GetPlayerServerId(PlayerId())
    if args[2] == nil then
        ShowNotification("Du musst eine Menge angeben")
    elseif tonumber(args[2]) < 0 then
        ShowNotification("Die Menge muss größer als 0 sein")
    else
        TriggerServerEvent('inv:addItem', args[1], args[2], id)
    end
end)

RegisterCommand('rmvitem', function(source, args, raw)
    local id = GetPlayerServerId(PlayerId())
    if args[2] == nil then
        ShowNotification("Du musst eine Menge angeben")
    elseif tonumber(args[2]) < 0 then
        ShowNotification("Die Menge muss größer als 0 sein")
    else
        TriggerServerEvent('inv:removeItem', args[1], args[2], id)
    end
end)