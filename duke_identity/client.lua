local control = false
_Pool = NativeUI.CreatePool()
display = false
officeCoords = {x = -1086.54, y = -2831.38, z = 27.71}
OfficeOpen = false
control = true

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if GetDistanceBetweenCoords(officeCoords.x, officeCoords.y, officeCoords.z, playerCoords) < 1.0 and OfficeOpen == false then
            SetTextFont(0)
            SetTextScale(0.3, 0.3)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString("Drücke E um den Schalter zu öffnen.")
            DrawText(0.005, 0.01)
            DrawRect(150, 100, 0.37, 0.10, 40, 40, 40, 155)
            openOffice()
        end
        DrawMarker(1, officeCoords.x, officeCoords.y, officeCoords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, nil, nil, false)
    end
end)

function openOffice()
    Citizen.CreateThread(function()
        if IsControlJustReleased(0, 38) then
            OfficeOpen = true
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "office"
            })
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local entry = GetConvar("entry"..GetPlayerName(PlayerId()), "error")
        local style = GetConvar("style"..GetPlayerName(PlayerId()), "error")
        local coords = GetEntityCoords(PlayerPedId())
        local dist = Vdist(coords, -1089.38, -2832.42, 27.71)
        if(dist > 80) then
            if tonumber(entry) == 0 and tonumber(style) ~= 0 then
                SetEntityCoords(PlayerPedId(), -1089.38, -2832.42, 27.71, true, false, false, true)
            end
        end
    end
end)

local function setModel(_model)
    local model = _model
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)
        local playerPed = PlayerPedId()
        local variations = {
            face = 0,
            head = 1,
            hair = 2,
            torso = 3,
            legs = 4,
            hands = 5,
            feet = 6,
            eyes = 7,
            accessories = 8,
            tasks = 9,
            textures = 10,
            torso2 = 11,
        }
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _Pool:ProcessMenus()
    end
end)

RegisterCommand('cam', function(source, args, raw)
    camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.9295, -1003.847, -98.00027, 0.00, 0.00, 0.00, 15.0, true, 2)
    PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.6, 0.0, true)
    SetCamActive(camSkin, true)
    RenderScriptCams(true, false, 0, true, true)
end)

RegisterCommand('vanish', function(source, args, raw)
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function()
        SetEntityVisible(playerPed, false)
        while true do
            Citizen.Wait(0)
            SetEntityLocallyVisible(playerPed)
        end
    end)
end)

RegisterCommand('notif', function(source, args, raw)
    ShowDukeNotification(GetPlayerServerId(PlayerId()), "Gehe zum Flughafenschalter, um deinen Personalausweis abzuholen", 4000)
end)

RegisterCommand('control', function(source, args, raw)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -1140.822, -2806.093, 27.70873, true, false, false, true)
    control = true
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCompletelyDisableCollision(PlayerPedId(), true, false)
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "document",
        display = false,
    })
    control = true
    ShowDukeNotification(GetPlayerServerId(PlayerId()), "Gehe zum Flughafenschalter, um deinen Personalausweis abzuholen", 60000)
end)

RegisterNUICallback("submitIdentity", function()
    SetNuiFocus(false, false)
    data = GetConvar("data"..GetPlayerName(PlayerId()), "error")
    if data ~= "error" then
        TriggerServerEvent("OverwriteEntry", GetPlayerServerId(PlayerId()))
        ShowDukeNotification(GetPlayerServerId(PlayerId()), "Deine Einreise ist abgeschlossen. Willkommen auf DukeCity! Bitte warte, bis du teleportiert wirst.", 8000)
        Citizen.Wait(12000)
        SwitchOutPlayer(PlayerPedId(), 0, 1)
        Citizen.Wait(3000)
        SetEntityCoords(PlayerPedId(), 195.06, -931.61, 30.69, true, false, false, true)
        SwitchInPlayer(PlayerPedId())
    else
        ShowNotification("Ein Fehler ist aufgetreten")
    end
end)

RegisterCommand("fadein", function()
    SetWeatherOwnedByNetwork(true)
    SetWeatherTypeNow(0xEFB6EFF6)
end)

RegisterNUICallback("abortIdentity", function()
    SetNuiFocus(false, false)
    OfficeOpen = false
end)

RegisterNUICallback("male", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "gender",
        display = false,
    })
    currentGender = "male"
end)

RegisterNUICallback("female", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "gender",
        display = false,
    })
    setModel("mp_f_freemode_01")
    currentGender = "female"
end)

RegisterNUICallback("no", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "confirm",
        display = false,
    })
end)

RegisterNUICallback("submit", function(data)
    TriggerServerEvent("SavePlayerData", GetPlayerServerId(PlayerId()), data)
    ShowNotification("Deine Daten wurden an das zuständige Einreiseamt übertragen")
    ShowNotification("Du kannst dieses Dokument jetzt schließen")
end)

RegisterNUICallback("yes", function(data)
    editor = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "confirm",
        display = false,
    })
    style = {
        hair = currentHair,
        face = currentFace,
        hairColor = currentHairColor,
        torso = currentTorso,
        undershirt = currentUndershirt,
        leg = currentLeg,
        shoe = currentShoe,
        arms = currentTorso2,
        gender = currentGender
    }
    TriggerServerEvent('identity:saveStyle', GetPlayerServerId(PlayerId()), style)
    SetEntityCoords(PlayerPedId(), -1140.822, -2806.093, 27.70873, true, false, false, true)
    SetEntityVisible(PlayerPedId(), true)
    Citizen.Wait(1000)
    menu:Visible(false)
    SetCamActive(camSkin, false)
    StopRenderingScriptCamsUsingCatchUp(true)
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, true)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "document",
        display = true,
    })
end)

function document()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "document",
        display = true,
    })
end

function start()
    openEditor()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "gender",
        display = true,
    })
end

Citizen.CreateThread(function()
    while true do
        if control == false then
            DisableControlAction(0, 30)
            DisableControlAction(0, 31)
            DisableControlAction(0, 32)
            DisableControlAction(0, 33)
            DisableControlAction(0, 34)
            DisableControlAction(0, 35)
            DisableControlAction(0, 266)
            DisableControlAction(0, 267)
            DisableControlAction(0, 268)
            DisableControlAction(0, 269)
            SetEntityLocallyVisible(PlayerPedId())
            SetEntityCompletelyDisableCollision(PlayerPedId(), true, false)
        else
            SetEntityVisible(PlayerPedId(), true)
        end
        Citizen.Wait(0)
    end
end)

function openEditor()
    style = GetConvar("style"..GetPlayerName(PlayerId()), "Kein Style")
    if tonumber(style) == 0 then
        editor = true
        control = false
            Citizen.CreateThread(function()
                SetEntityVisible(PlayerPedId(), false)
                while control == false do
                    SetEntityLocallyVisible(PlayerPedId())
                    SetEntityCompletelyDisableCollision(PlayerPedId(), true, false)
                    Citizen.Wait(0)
                end
            end)
        camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.9295, -1003.847, -98.00027, 0.00, 0.00, 0.00, 15.0, true, 2)
        PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.6, 0.0, true)
        SetCamActive(camSkin, true)
        RenderScriptCams(true, false, 0, true, true)

        currentHair = 0
        currentFace = 0
        currentHairColor = 0
        currentTorso = 0
        currentUndershirt = 0
        currentLeg = 0
        currentShoe = 0
        currentTorso2 = 0
        SetPedComponentVariation(PlayerPedId(), 0, 0)
        SetPedComponentVariation(PlayerPedId(), 2, 0)
        SetPedComponentVariation(PlayerPedId(), 3, 0)
        SetPedComponentVariation(PlayerPedId(), 4, 0)
        SetPedComponentVariation(PlayerPedId(), 6, 0)
        SetPedComponentVariation(PlayerPedId(), 8, 0)

        menu = NativeUI.CreateMenu('Einreise', 'Wähle eine Kategorie:')
        _Pool:Add(menu)
        _Pool:MouseEdgeEnabled (false)
        _Pool:ControlDisablingEnabled(true)
        _Pool:MouseControlsEnabled(true)
        _Pool:DisableInstructionalButtons(true)

        local faceNum = GetNumberOfPedDrawableVariations(PlayerPedId(), 0)
        counter = 0
        faceList = {}
        while counter <= faceNum do
            table.insert(faceList, counter)
            counter = counter + 1
        end
        for i = 1, #faceList, 1 do
            SetPedPreloadPropData(PlayerPedId(), 0, faceList[i])
        end  
        local face = NativeUI.CreateListItem("Gesicht", faceList, 1)
        menu:AddItem(face)

        local hairNum = GetNumberOfPedDrawableVariations(PlayerPedId(), 2)
        counter = 0
        hairList = {}
        while counter <= hairNum do
            table.insert(hairList, counter)
            counter = counter + 1
        end
        for i = 1, #hairList, 1 do
            SetPedPreloadPropData(PlayerPedId(), 2, hairList[i])
        end  
        local hair = NativeUI.CreateListItem("Haare", hairList, 1)
        menu:AddItem(hair)

        hairColorList = {0,1,2,3,4,5,6}
        local hairColor = NativeUI.CreateSliderItem("Haarfarbe", hairColorList, 1)
        menu:AddItem(hairColor)

        local torsoNum = GetNumberOfPedDrawableVariations(PlayerPedId(), 11)
        counter = 0
        torsoList = {}
        while counter <= torsoNum do
            table.insert(torsoList, counter)
            counter = counter + 1
        end
        for i = 1, #torsoList, 1 do
            SetPedPreloadPropData(PlayerPedId(), 11, torsoList[i])
        end
        local torso = NativeUI.CreateListItem("Oberteil", torsoList, 1)
        menu:AddItem(torso)

        local undershirtNum = GetNumberOfPedDrawableVariations(PlayerPedId(), 8)
        counter = 0
        undershirtList = {}
        while counter <= undershirtNum do
            table.insert(undershirtList, counter)
            counter = counter + 1
        end
        for i = 1, #undershirtList, 1 do
            SetPedPreloadPropData(PlayerPedId(), 8, undershirtList[i])
        end
        local undershirt = NativeUI.CreateListItem("Shirt", undershirtList, 1)
        menu:AddItem(undershirt)

        local legNum = GetNumberOfPedDrawableVariations(PlayerPedId(), 4)
        counter = 0
        legList = {}
        while counter <= legNum do
            table.insert(legList, counter)
            counter = counter + 1
        end
        for i = 1, #legList, 1 do
            SetPedPreloadPropData(PlayerPedId(), 4, legList[i])
        end
        local leg = NativeUI.CreateListItem("Hose", legList, 1)
        menu:AddItem(leg)

        local shoeNum = GetNumberOfPedDrawableVariations(PlayerPedId(), 6)
        counter = 0
        shoeList = {}
        while counter <= shoeNum do
            table.insert(shoeList, counter)
            counter = counter + 1
        end
        for i = 1, #shoeList, 1 do
            SetPedPreloadPropData(PlayerPedId(), 6, shoeList[i])
        end
        local shoe = NativeUI.CreateListItem("Schuhe", shoeList, 1)
        menu:AddItem(shoe)

        local torso2Num = GetNumberOfPedDrawableVariations(PlayerPedId(), 3)
        counter = 0
        torso2List = {}
        while counter <= torso2Num do
            table.insert(torso2List, counter)
            counter = counter + 1
        end
        for i = 1, #torso2List, 1 do
            SetPedPreloadPropData(PlayerPedId(), 3, torso2List[i])
        end
        local torso2 = NativeUI.CreateListItem("Arme", torso2List, 1)
        menu:AddItem(torso2)

        local final = NativeUI.CreateItem('Speichern', 'Speichert deinen Charakter und setzt die Einreise fort.')
        menu:AddItem(final)

        final.Activated = function(sender, index)
            finish()
        end

        menu.OnListChange = function(sender, item, index)
            if item == face then
                SetPedComponentVariation(PlayerPedId(), 0, faceList[index])
                currentFace = faceList[index]
            end
            if item == hair then
                SetPedComponentVariation(PlayerPedId(), 2, hairList[index])
                currentHair = hairList[index]
            end
            if item == torso then
                SetPedComponentVariation(PlayerPedId(), 11, torsoList[index])
                currentTorso = torsoList[index]
            end
            if item == undershirt then
                if undershirtList[index] == 123 then
                    return
                end
                SetPedComponentVariation(PlayerPedId(), 8, undershirtList[index])
                currentUndershirt = undershirtList[index]
            end
            if item == leg then
                SetPedComponentVariation(PlayerPedId(), 4, legList[index])
                currentLeg = legList[index]
            end
            if item == shoe then
                SetPedComponentVariation(PlayerPedId(), 6, shoeList[index])
                currentShoe = shoeList[index]
            end
            if item == torso2 then
                SetPedComponentVariation(PlayerPedId(), 3, torso2List[index])
                currentTorso2 = torso2List[index]
            end
        end

        menu.OnSliderChange = function(sender, item, index)
            if item == hairColor then
                SetPedComponentVariation(PlayerPedId(), 2, currentHair, hairColorList[index])
                currentHairColor = hairColorList[index]
            end
        end

        menu:Visible(true)

        Citizen.CreateThread(function()
            while editor == true do
                Citizen.Wait(0)
                if _Pool:IsAnyMenuOpen() == false then
                    menu:Visible(true)
                end
            end
        end)
    end
end

function openEntry(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "document",
        display = bool,
    })
end

RegisterNUICallback("error", function(data)
    ShowNotification(data.error)
end)

RegisterCommand("doc", function()
    openEntry(true)
end)

function finish()
    if currentTorso == 287 or currentUndershirt == 122 or currentLeg == 114 or currentLeg == 115 or currentShoe == 78 then
        ShowNotification("Du darfst die Adminkleidung leider nicht benutzen")
        return
    end
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "confirm",
        display = true,
    })
end

RegisterCommand("finish", function()
    if editor ~= true then
        print("Du befindetst dich nicht im Editor")
        return
    end
    if currentTorso == 287 or currentUndershirt == 122 or currentLeg == 114 or currentLeg == 115 or currentShoe == 78 then
        print("Du darfst die Adminkleidung leider nicht benutzen")
        return
    end
    style = {
        hair = currentHair,
        face = currentFace,
        hairColor = currentHairColor,
        torso = currentTorso,
        undershirt = currentUndershirt,
        leg = currentLeg,
        shoe = currentShoe,
        arms = currentTorso2
    }
    TriggerServerEvent('identity:saveStyle', GetPlayerServerId(PlayerId()), style)
end)

exports('openEditor', openEditor)
exports('document', document)
exports('start', start)