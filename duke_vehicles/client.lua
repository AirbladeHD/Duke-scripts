menuOpen = false

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
    })
end


function CreateNoclipVehicle()
    local ModelHash = `adder`
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    local MyPed = PlayerPedId()
    local Vehicle = CreateVehicle(ModelHash, GetEntityCoords(MyPed), GetEntityHeading(MyPed), false, false)
    SetModelAsNoLongerNeeded(ModelHash)
    SetEntityNoCollisionEntity(MyPed, Vehicle, false)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetDistanceBetweenCoords(GetEntityCoords(MyPed), GetEntityCoords(Vehicle)) < 10 then
                DisableControlAction(PlayerPedId(), 23, true)
            else
                EnableControlAction(PlayerPedId(), 23, true)
                SetEntityAsMissionEntity(Vehicle, true, true)
                DeleteVehicle(Vehicle)
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for i=1, #Config.Car, 1 do
            if GetDistanceBetweenCoords(Config.Car[i].x, Config.Car[i].y, Config.Car[i].z, playerCoords) < 1.0 then
                SetTextFont(0)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextEntry("STRING")
                AddTextComponentString("Drücke E um den Shop zu öffnen.")
                DrawText(0.005, 0.01)
                DrawRect(150, 100, 0.35, 0.10, 40, 40, 40, 155)
                openShop()
            end
            DrawMarker(1, Config.Car[i].x, Config.Car[i].y, Config.Car[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, nil, nil, false)
        end
    end
end)

function openShop()
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            menuOpen = true

        end
    end)
end

RegisterCommand('dealer', function()
    SetEntityCoords(PlayerPedId(), -1264.507, -359.0551, 36.90749)
end)