local menu
local display = false
local menuOpen
local coords = true
_Pool = NativeUI.CreatePool()
local id = PlayerId()
local playerPed = PlayerPedId()
local money
local balance

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(3000)
    TriggerServerEvent('bank:pull_money')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local player = GetPlayerName(PlayerId())
        local money = GetConvar("money"..player, "Fehler beim abrufen des Kontostandes")
        local color = {
            r = 255,
            g = 255,
            b = 255,
            a = 255
        }
        SetTextFont(1)
        SetTextScale(0.7, 0.7)
        SetTextColour(color.r, color.b, color.g, color.a)
        SetTextEntry("STRING")
        AddTextComponentString("Bargeld: "..money.."$")
        DrawText(0.85, 0.01)
    end
end)

function SetDisplay(bool)
    display = bool
    local player = GetPlayerName(PlayerId())
    local balance = GetConvar("balance"..player, "Fehler beim abrufen des Kontostandes")
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
        balance = balance
    })
end

for i=1, #Config.Atms, 1 do
    local blip = AddBlipForCoord(Config.Atms[i].x, Config.Atms[i].y, Config.Atms[i].z)
    SetBlipSprite(blip, 500)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bankautomat")
    EndTextCommandSetBlipName(blip)
end

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
    ShowNotification(data.error)
end)

RegisterNUICallback("out", function(data)
    id = GetPlayerServerId(PlayerId())
    TriggerServerEvent('bank:deduct', id, data.amount)
end)

RegisterNUICallback("in", function(data)
    id = GetPlayerServerId(PlayerId())
    TriggerServerEvent('bank:deposit', id, data.amount)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        _Pool:ProcessMenus()
        if IsControlJustReleased(0, 288) then
            openMenu()
        end
    end
end)

RegisterCommand('register', function(source, args, raw)
    TriggerServerEvent('bank:register')
end)

RegisterCommand('fetch', function(source, args, raw)
    TriggerServerEvent('bank:pull_money')
end)

RegisterNetEvent('bank:close')
AddEventHandler('bank:close', function(msg)
    if msg == nil then
        SetDisplay(false)
        TriggerServerEvent('bank:pull_money')
    else
        SetDisplay(false)
        ShowNotification(msg)
        TriggerServerEvent('bank:pull_money')
    end
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
        local color = {
            r = 255,
            g = 255,
            b = 255,
            a = 255
        }
        for i=1, #Config.Atms, 1 do
            if GetDistanceBetweenCoords(Config.Atms[i].x, Config.Atms[i].y, Config.Atms[i].z, playerCoords) < 1.0 then
                SetTextFont(0)
                SetTextScale(0.3, 0.3)
                SetTextColour(color.r, color.b, color.g, color.a)
                SetTextEntry("STRING")
                AddTextComponentString("Drücke E um den Automaten zu benutzen.")
                DrawText(0.005, 0.01)
                DrawRect(150, 100, 0.43, 0.10, 40, 40, 40, 155)
                openBank()
            end
        end
    end
end)

function openBank()
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            menuOpen = true
            SetDisplay(true)
        end
    end)
end

RegisterCommand('money', function(source, args, raw)
    local playerPed = PlayerPedId()
    SetPedMoney(playerPed, 1000)
end)

function openMenu()
    local playerPed = PlayerPedId()
    menu = NativeUI.CreateMenu('Bankverwaltung', 'Aktion auswählen:')
    _Pool:Add(menu)
    _Pool:MouseControlsEnabled (false)
    _Pool:MouseEdgeEnabled (false)
    _Pool:ControlDisablingEnabled(false)

    local item1 = NativeUI.CreateItem('Automaten hinzufügen', 'Fügt diesen Koordinaten einen Trigger für einen Bankautomaten hinzu.')
    local item2 = NativeUI.CreateItem('Koordinaten anzeigen', 'Blendet deine aktuellen Koordinaten ein.')

    menu:AddItem(item1)
    menu:AddItem(item2)

    item1.Activated = function(sender, index)
        if SaveResourceFile(GetCurrentResourceName(), 'config.json', json.encode('test'), -1) == true then
            print('hat geklappt')
        else
            print('hat nicht geklappt')
        end
    end

    item2.Activated = function(sender, index)
        local playerCoords = GetEntityCoords(playerPed)
        local rotation = GetEntityRotation(playerPed)
        --local cam = GetCamRot(playerPed)
        local cam = GetGameplayCamRot()
        print("Koordinaten: "..playerCoords)
        print("Ausrichtung: "..rotation)
        print("Kamera: "..cam)
    end

    menu:Visible(true)
end