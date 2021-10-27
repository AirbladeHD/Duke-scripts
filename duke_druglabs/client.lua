display = false

function SetDisplay(bool)
    local player = PlayerId()
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
        inventory = GetConvar("inventory"..GetPlayerName(player), "Abrufen des Inventars fehlgeschlagen")
    })
end

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    ShowNotification(data.error)
end)

RegisterNUICallback("msg", function(data)
    print(data.msg)
end)

RegisterNUICallback("addItem", function(data)
    local id = GetPlayerServerId(PlayerId())
    --TriggerServerEvent('inv:additem', data.item, id, data.amount)
end)

RegisterNUICallback("rmvItem", function(data)
    local id = GetPlayerServerId(PlayerId())
    local Items = json.decode(data.items)
    local logtable = {Trauben = 1}
    for i = 1, #Items, 1 do
        if logtable[Items[i]] == nil then
            print("Item existiert noch nicht")
        else
            print("Item existiert schon")
        end
    end

    for i = 1, #logtable, 1 do
        print(logtable[i])
    end
    --for i = 1, #Items, 1 do
        --TriggerServerEvent('inv:removeitem', "Trauben", id, 10)
    --end
    --TriggerServerEvent('inv:refresh_inventory')
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for i=1, #Config.cook, 1 do
            if GetDistanceBetweenCoords(Config.cook[i].x, Config.cook[i].y, Config.cook[i].z, playerCoords) < 1.0 then
                SetTextFont(0)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextEntry("STRING")
                AddTextComponentString("Drücke E um das Labor zu öffnen.")
                DrawText(0.005, 0.01)
                DrawRect(150, 100, 0.35, 0.10, 40, 40, 40, 155)
                openCook()
            end
            DrawMarker(1, Config.cook[i].x, Config.cook[i].y, Config.cook[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, nil, nil, false)
            DrawMarker(29, Config.cook[i].x, Config.cook[i].y, Config.cook[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 120, 255, 120, 100, false, true, 2, true, nil, false)
        end
    end
end)

function openCook()
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            SetDisplay(true)
        end
    end)
end