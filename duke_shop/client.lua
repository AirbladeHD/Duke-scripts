display = false
id = PlayerId()
playerPed = PlayerPedId()
playeranim = nil
status = false

RequestAnimDict("amb@medic@standing@tendtodead@idle_a")
--idle_c
RequestAnimDict("mini@cpr@char_a@cpr_def")
--cpr_pumpchest_idle
RequestAnimDict("mini@cpr@char_a@cpr_str")
--cpr_pumpchest
RequestAnimDict("mini@repair")
--fixing_a_player
RequestAnimDict("amb@world_human_stand_fishing@idle_a")

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
    })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for i=1, #Config.Shops, 1 do
            if GetDistanceBetweenCoords(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z, playerCoords) < 1.0 then
                SetTextFont(0)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextEntry("STRING")
                AddTextComponentString("Drücke E um den Shop zu öffnen.")
                DrawText(0.005, 0.01)
                DrawRect(150, 100, 0.35, 0.10, 40, 40, 40, 155)
                openShop()
            end
            DrawMarker(1, Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, nil, nil, false)
            DrawMarker(29, Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 120, 255, 120, 100, false, true, 2, true, nil, false)
        end
    end
end)

for i=1, #Config.Shops, 1 do
    local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)
    SetBlipSprite(blip, 52)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Shop")
    EndTextCommandSetBlipName(blip)
end

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("buy", function(data)
    SetDisplay(false)
    if data.medkits == 0 and data.repairkits == 0 then
        ShowNotification("Dein Warenkorb ist leer")
    else
        local id = GetPlayerServerId(PlayerId())
        if data.medkits ~= 0 then
            TriggerServerEvent('shop:buy', id, "Medkits", data.medkits*400, data.medkits)
            TriggerServerEvent('bank:pull_money')
        end
        if data.repairkits ~= 0 then
            TriggerServerEvent('shop:buy', id, "Reperaturkits", data.repairkits*1000, data.repairkits)
            TriggerServerEvent('bank:pull_money')
        end
    end
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
    ShowNotification(data.error)
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function openShop()
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            menuOpen = true
            SetDisplay(true)
        end
    end)
end

function animation(anim, animname)
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, anim, animname, 1.8, 1.0, 15000, 1, 3, true, true, true)
end

function startEmote(anim)
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, anim, 0, true)
end

RegisterCommand('rmh', function(source, args, raw)
    local playerPed = PlayerPedId()
    local health = GetPedMaxHealth(playerPed)
    SetEntityHealth(playerPed, health/2)
end)

RegisterCommand('emote', function(source, args, raw)
    local playerPed = PlayerPedId()
    RequestAnimDict("amb@medic@standing@tendtodead@idle_a")
    TaskPlayAnim(playerPed, "amb@medic@standing@tendtodead@idle_a", "idle_c", 1.8, 1.0, 15000, 1, 3, true, true, true)
end)

RegisterNetEvent('shop:msg', function(msg)
    ShowNotification(msg)
end)