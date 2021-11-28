DealerOpen = false
display = false
SetEntityVisible(PlayerPedId(), true)
currentCategorie = 1

for i=1, #Config.Dealers, 1 do
    local blip = AddBlipForCoord(Config.Dealers[i].x, Config.Dealers[i].y, Config.Dealers[i].z)
    SetBlipSprite(blip, 225)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 0)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Autohandel")
    EndTextCommandSetBlipName(blip)
end

function switchVehicle(direction, currentVehicle)
    if(direction == "right") then
        currentVehicle = currentVehicle + 1
        if currentVehicle > #Config.Categories[currentCategorie].vehicles then
            currentVehicle = 1
        end
        CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[currentVehicle].name)
        SendNUIMessage({
            type = "update",
            num = currentVehicle,
            price = Config.Categories[currentCategorie].vehicles[currentVehicle].price,
            hp = Config.Categories[currentCategorie].vehicles[currentVehicle].hp,
            turbo = Config.Categories[currentCategorie].vehicles[currentVehicle].turbo,
            traktion = Config.Categories[currentCategorie].vehicles[currentVehicle].traktion,
            handling = Config.Categories[currentCategorie].vehicles[currentVehicle].handling,
            name = Config.Categories[currentCategorie].vehicles[currentVehicle].name
        })
    end
    if(direction == "left") then
        currentVehicle = currentVehicle - 1
        if currentVehicle < 1 then
            currentVehicle = #Config.Categories[currentCategorie].vehicles
        end
        CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[currentVehicle].name)
        SendNUIMessage({
            type = "update",
            num = currentVehicle,
            price = Config.Categories[currentCategorie].vehicles[currentVehicle].price,
            hp = Config.Categories[currentCategorie].vehicles[currentVehicle].hp,
            turbo = Config.Categories[currentCategorie].vehicles[currentVehicle].turbo,
            traktion = Config.Categories[currentCategorie].vehicles[currentVehicle].traktion,
            handling = Config.Categories[currentCategorie].vehicles[currentVehicle].handling,
            name = Config.Categories[currentCategorie].vehicles[currentVehicle].name
        })
    end
end

function SetDisplay(bool, num)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
        price = Config.Categories[1].vehicles[1].price,
        name = Config.Categories[1].vehicles[1].name,
        hp = Config.Categories[1].vehicles[1].hp,
        turbo = Config.Categories[1].vehicles[1].turbo,
        traktion = Config.Categories[1].vehicles[1].traktion,
        handling = Config.Categories[1].vehicles[1].handling,
        num = num,
    })
end

RegisterNUICallback("switch", function(data)
    switchVehicle(data.d, data.c)
end)

RegisterNUICallback("exit", function()
    DealerOpen = false
    SetDisplay(false)
    SetEntityVisible(PlayerPedId(), true)
    PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.0, 0.0, true)
    Citizen.Wait(100)
    SetCamActive(camSkin, false)
    StopRenderingScriptCamsUsingCatchUp(true)
    EnableControlAction(PlayerPedId(), 23, true)
    if Vehicle then
        DeleteVehicle(Vehicle)
    end
end)

function CreateNoclipVehicle(model)
    if Vehicle then
        DeleteVehicle(Vehicle)
    end
    local ModelHash = GetHashKey(model)
    if not IsModelInCdimage(ModelHash) then return end
    RequestModel(ModelHash)
    while not HasModelLoaded(ModelHash) do
        Citizen.Wait(10)
    end
    local MyPed = PlayerPedId()
    Vehicle = CreateVehicle(ModelHash, -1255.28, -360.2462, 36.90747, 0, 0, 77.42708, false, false)
    SetModelAsNoLongerNeeded(ModelHash)
    SetEntityCollision(Vehicle, false, false)
    FreezeEntityPosition(Vehicle, true)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetDistanceBetweenCoords(GetEntityCoords(MyPed), GetEntityCoords(Vehicle)) < 15 then
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
        for i=1, #Config.Dealers, 1 do
            if GetDistanceBetweenCoords(Config.Dealers[i].x, Config.Dealers[i].y, Config.Dealers[i].z, playerCoords) < 1.0 and DealerOpen == false then
                SetTextFont(0)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextEntry("STRING")
                AddTextComponentString("Drücke E um den Shop zu öffnen.")
                DrawText(0.005, 0.01)
                DrawRect(150, 100, 0.35, 0.10, 40, 40, 40, 155)
                openShop()
            end
            DrawMarker(1, Config.Dealers[i].x, Config.Dealers[i].y, Config.Dealers[i].z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, nil, nil, false)
        end
    end
end)

function openShop()
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            DealerOpen = true
            SetDisplay(true, 1)
            SetEntityVisible(PlayerPedId(), false)
            CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[1].name)
            camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1265.507, -352.0551, 37.50749, 0.00, 0.00, 0.00, 19.0, true, 2)
            PointCamAtEntity(camSkin, Vehicle, 0.0, 0.0, 0.0, true)
            SetCamActive(camSkin, true)
            RenderScriptCams(true, false, 0, true, true)
        end
    end)
end

RegisterCommand('dealer', function()
    --SetEntityCoords(PlayerPedId(), -1264.507, -359.0551, 36.90749)
    --SetDisplay(true)
    --CreateNoclipVehicle(Config.Categories[currentCategorie][1].name)
    local gameCamRot = GetGameplayCamRot(0)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(PlayerPedId()), gameCamRot.x, gameCamRot.y, gameCamRot.z, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
    local offsetCoords = GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), GetGameplayCamCoord())
    AttachCamToEntity(cam, PlayerPedId(), offsetCoords, false)
    Citizen.CreateThread(function ()
        while IsCamActive(cam) do
            Wait(0)
            local rot = GetGameplayCamRot(0)
            SetCamParams(cam, GetEntityCoords(PlayerPedId()),rot.x, rot.y, rot.z, GetGameplayCamFov())
        end
    end)
end)