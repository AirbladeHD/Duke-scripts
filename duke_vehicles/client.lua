DealerOpen = false
display = false
SetEntityVisible(PlayerPedId(), true)
SetEntityCollision(PlayerPedId(), true, true)
FreezeEntityPosition(PlayerPedId(), false)
currentCategorie = 1
default_pr = 0
default_pg = 0
default_pb = 0
default_sr = 0
default_sg = 0
default_sb = 0

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

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function switchVehicle(direction, currentVehicle)
    if(direction == "right") then
        currentVehicle = currentVehicle + 1
        if currentVehicle > #Config.Categories[currentCategorie].vehicles then
            currentVehicle = 1
        end
        CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[currentVehicle].name)
        modCount = {}
        for i = 1, #Config.Categories[currentCategorie].vehicles[currentVehicle].mods, 1 do
            count = GetNumVehicleMods(Vehicle, Config.Categories[currentCategorie].vehicles[currentVehicle].mods[i]) - 1
            table.insert(modCount, count)
        end
        SendNUIMessage({
            type = "update",
            num = currentVehicle,
            price = Config.Categories[currentCategorie].vehicles[currentVehicle].price,
            hp = Config.Categories[currentCategorie].vehicles[currentVehicle].hp,
            turbo = Config.Categories[currentCategorie].vehicles[currentVehicle].turbo,
            traktion = Config.Categories[currentCategorie].vehicles[currentVehicle].traktion,
            handling = Config.Categories[currentCategorie].vehicles[currentVehicle].handling,
            name = Config.Categories[currentCategorie].vehicles[currentVehicle].name,
            mods = Config.Categories[currentCategorie].vehicles[currentVehicle].mods,
            modCount = modCount,
            brand = Config.Categories[currentCategorie].vehicles[currentVehicle].brand,
            displayName = Config.Categories[currentCategorie].vehicles[currentVehicle].displayName
        })
    end
    if(direction == "left") then
        currentVehicle = currentVehicle - 1
        if currentVehicle < 1 then
            currentVehicle = #Config.Categories[currentCategorie].vehicles
        end
        CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[currentVehicle].name)
        modCount = {}
        for i = 1, #Config.Categories[currentCategorie].vehicles[currentVehicle].mods, 1 do
            count = GetNumVehicleMods(Vehicle, Config.Categories[currentCategorie].vehicles[currentVehicle].mods[i]) - 1
            table.insert(modCount, count)
        end
        SendNUIMessage({
            type = "update",
            num = currentVehicle,
            price = Config.Categories[currentCategorie].vehicles[currentVehicle].price,
            hp = Config.Categories[currentCategorie].vehicles[currentVehicle].hp,
            turbo = Config.Categories[currentCategorie].vehicles[currentVehicle].turbo,
            traktion = Config.Categories[currentCategorie].vehicles[currentVehicle].traktion,
            handling = Config.Categories[currentCategorie].vehicles[currentVehicle].handling,
            name = Config.Categories[currentCategorie].vehicles[currentVehicle].name,
            mods = Config.Categories[currentCategorie].vehicles[currentVehicle].mods,
            modCount = modCount,
            brand = Config.Categories[currentCategorie].vehicles[currentVehicle].brand,
            displayName = Config.Categories[currentCategorie].vehicles[currentVehicle].displayName
        })
    end
    if direction == "reload" then
        CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[currentVehicle].name)
        modCount = {}
        for i = 1, #Config.Categories[currentCategorie].vehicles[currentVehicle].mods, 1 do
            count = GetNumVehicleMods(Vehicle, Config.Categories[currentCategorie].vehicles[currentVehicle].mods[i]) - 1
            table.insert(modCount, count)
        end
        SendNUIMessage({
            type = "update",
            num = currentVehicle,
            price = Config.Categories[currentCategorie].vehicles[currentVehicle].price,
            hp = Config.Categories[currentCategorie].vehicles[currentVehicle].hp,
            turbo = Config.Categories[currentCategorie].vehicles[currentVehicle].turbo,
            traktion = Config.Categories[currentCategorie].vehicles[currentVehicle].traktion,
            handling = Config.Categories[currentCategorie].vehicles[currentVehicle].handling,
            name = Config.Categories[currentCategorie].vehicles[currentVehicle].name,
            mods = Config.Categories[currentCategorie].vehicles[currentVehicle].mods,
            modCount = modCount,
            brand = Config.Categories[currentCategorie].vehicles[currentVehicle].brand,
            displayName = Config.Categories[currentCategorie].vehicles[currentVehicle].displayName,
            reset = 0
        })
    end
end

function SetDisplay(bool, num)
    currentCategorie = 1
    currentVehicle = 1
    display = bool
    SetNuiFocus(bool, bool)
    modCount = {}
    for i = 1, #Config.Categories[1].vehicles[1].mods, 1 do
        count = GetNumVehicleMods(Vehicle, Config.Categories[1].vehicles[1].mods[i]) - 1
        table.insert(modCount, count)
    end
    SendNUIMessage({
        type = "ui",
        display = bool,
        price = Config.Categories[1].vehicles[1].price,
        name = Config.Categories[1].vehicles[1].name,
        brand = Config.Categories[1].vehicles[1].brand,
        hp = Config.Categories[1].vehicles[1].hp,
        turbo = Config.Categories[1].vehicles[1].turbo,
        traktion = Config.Categories[1].vehicles[1].traktion,
        handling = Config.Categories[1].vehicles[1].handling,
        mods = Config.Categories[1].vehicles[1].mods,
        modCount = modCount,
        displayName = Config.Categories[1].vehicles[1].displayName,
        num = num,
    })
end

RegisterNetEvent('buyVehicleCallback')
AddEventHandler('buyVehicleCallback', function(msg)
    ShowNotification(msg)
end)

RegisterNUICallback("buy", function(data)
    player = GetPlayerServerId(PlayerId())
    DealerOpen = false
    SetDisplay(false)
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCollision(PlayerPedId(), true, true)
    FreezeEntityPosition(PlayerPedId(), false)
    PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.0, 0.0, true)
    Citizen.Wait(100)
    SetCamActive(camSkin, false)
    StopRenderingScriptCamsUsingCatchUp(true)
    EnableControlAction(PlayerPedId(), 23, true)
    if Vehicle then
        DeleteVehicle(Vehicle)
    end
    mods = {}
    for i = 1, #data.mods, 1 do
        if(data.mods[i][2] ~= 0) then
            table.insert(mods, {i-1, data.mods[i][2]-1})
        end
    end
    if #mods == 0 then
        mods = "default"
    end
    conf = {
        data.primary,
        data.secondary,
        mods
    }
    TriggerServerEvent('buyVehicle', player, data.p, data.n, data.m, conf, data.dn)
end)

RegisterNUICallback("reloadMods", function(data)
    CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[data.c].name)
    SetVehicleModKit(Vehicle, 0)
    for i = 1, #data.mods, 1 do
        if(data.mods[i][2] ~= 0) then
            SetVehicleMod(Vehicle, i-1, data.mods[i][2], false)
        end
    end
end)

RegisterNUICallback("switch_mod", function(data)
    SetVehicleModKit(Vehicle, 0)
    SetVehicleMod(Vehicle, data.m, data.c, false)
end)

RegisterNUICallback("switch", function(data)
    switchVehicle(data.d, data.c)
end)

RegisterNUICallback("switch_cat", function(data)
    if currentCategorie == data.cat then
        return
    end
    currentCategorie = data.cat
    currentVehicle = 1
    CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[currentVehicle].name)
    modCount = {}
    for i = 1, #Config.Categories[currentCategorie].vehicles[currentVehicle].mods, 1 do
        count = GetNumVehicleMods(Vehicle, Config.Categories[currentCategorie].vehicles[currentVehicle].mods[i]) - 1
        table.insert(modCount, count)
    end
    SendNUIMessage({
        type = "update",
        num = currentVehicle,
        price = Config.Categories[currentCategorie].vehicles[currentVehicle].price,
        hp = Config.Categories[currentCategorie].vehicles[currentVehicle].hp,
        turbo = Config.Categories[currentCategorie].vehicles[currentVehicle].turbo,
        traktion = Config.Categories[currentCategorie].vehicles[currentVehicle].traktion,
        handling = Config.Categories[currentCategorie].vehicles[currentVehicle].handling,
        name = Config.Categories[currentCategorie].vehicles[currentVehicle].name,
        brand = Config.Categories[currentCategorie].vehicles[currentVehicle].brand,
        mods = Config.Categories[currentCategorie].vehicles[currentVehicle].mods,
        modCount = modCount,
    })
end)

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

RegisterNUICallback("exit", function()
    DealerOpen = false
    SetDisplay(false)
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCollision(PlayerPedId(), true, true)
    FreezeEntityPosition(PlayerPedId(), false)
    PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.0, 0.0, true)
    Citizen.Wait(100)
    SetCamActive(camSkin, false)
    StopRenderingScriptCamsUsingCatchUp(true)
    EnableControlAction(PlayerPedId(), 23, true)
    if Vehicle then
        DeleteVehicle(Vehicle)
    end
end)

RegisterNUICallback("primary", function(data)
    local r, g, b = hex2rgb(data.color)
    SetVehicleCustomPrimaryColour(Vehicle, r, g, b)
end)

RegisterNUICallback("secondary", function(data)
    local r, g, b = hex2rgb(data.color)
    SetVehicleCustomSecondaryColour(Vehicle, r, g, b)
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
    SetVehicleModKit(Vehicle, 0)
    SetModelAsNoLongerNeeded(ModelHash)
    SetEntityCollision(Vehicle, false, false)
    FreezeEntityPosition(Vehicle, true)
    SetVehicleColours(Vehicle, 0, 0)
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
            SetEntityVisible(PlayerPedId(), false)
            SetEntityCollision(PlayerPedId(), false, false)
            FreezeEntityPosition(PlayerPedId(), true)
            CreateNoclipVehicle(Config.Categories[currentCategorie].vehicles[1].name)
            SetDisplay(true, 1)
            camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1265.507, -352.0551, 37.50749, 0.00, 0.00, 0.00, 19.0, true, 2)
            PointCamAtEntity(camSkin, Vehicle, 0.0, 0.0, 0.0, true)
            SetCamActive(camSkin, true)
            RenderScriptCams(true, false, 0, true, true)
        end
    end)
end