local control = false
_Pool = NativeUI.CreatePool()
display = false

--[[function openEditor(bool)
    local player = PlayerId()
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
    })
end]]--

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
        --print(GetNumberOfPedDrawableVariations(playerPed, variations.face))
        --print(GetNumberOfPedTextureVariations(playerPed, variations.face))
        SetPedComponentVariation(playerPed, variations.head, 0, 1, 2)
    end
end

--[[AddEventHandler('playerSpawned', function(spawn)
    local entry = GetConvar("entry"..GetPlayerName(PlayerId()), "Fehler bei der Einreise")
    local playerPed = PlayerPedId()
    local coords = GetConvar("coords"..GetPlayerName(PlayerId()), "Keine Koordinaten")
    coords = json.decode(coords)
    Citizen.Wait(80)
    if entry == "0" then
        openEditor()
        --camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1130.679, -2807.965, 27.70876, 0.00, 0.00, 0.00, 30, false, 0)
        --PointCamAtCoord(camSkin, -1136.313, -2806.844, 27.70873)
        --PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.0, 0.0, true)
        --SetCamActive(camSkin, true)
        --RenderScriptCams(true, false, 2000, true, true) 
        --openEditor()
    else
        local style = GetConvar("style"..GetPlayerName(PlayerId()), "Kein Style")
        local style = json.decode(style)
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z, true, false, false, true)
        setModel("mp_m_freemode_01")
        SetPedComponentVariation(PlayerPedId(), 0, style["face"])
        SetPedComponentVariation(PlayerPedId(), 2, style["hair"])
        SetPedComponentVariation(PlayerPedId(), 3, style["arms"])
        SetPedComponentVariation(PlayerPedId(), 4, style["leg"])
        SetPedComponentVariation(PlayerPedId(), 6, style["shoe"])
        SetPedComponentVariation(PlayerPedId(), 8, style["undershirt"])
        SetPedComponentVariation(PlayerPedId(), 2, style["hair"], style["hairColor"])
    end
end)]]--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _Pool:ProcessMenus()
    end
end)

RegisterCommand('cam', function(source, args, raw)
    --local coords = GetEntityCoords(PlayerPedId())
    --camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1135.5, -2797.0, 28.70876, 0.00, 0.00, 0.00, 15.0, true, 2)
    --camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x+3, coords.y+3, coords.z-1, 0.00, 0.00, 0.00, 30, false, 0)
    --PointCamAtCoord(camSkin, -1136.313, -2806.844, 28.5)
    --PointCamAtEntity(camSkin, PlayerPedId(), 0.0, 0.6, 0.0, true)
    --SetCamActive(camSkin, true)
    --RenderScriptCams(true, false, 0, true, true)
    --openEditor(true)
    --_Pool:MouseControlsEnabled (false)
    --_Pool:ControlDisablingEnabled(false)
    --local item = NativeUI.CreateSliderItem("Test", 2, 1, "Test", 5)
    --menu:AddItem(item)
    --local window = NativeUI.CreateHeritageWindow("Mum", "Dad")
    --menu:AddWindow(window)
    --menu:Visible(true)
    --local playerPed = PlayerPedId()
    --SetPedFaceFeature(playerPed, 0, 0.5)
    --TriggerServerEvent('face', playerPed)
    --SetPedEyeColor(playerPed, 6, 0, 1)
    --setModel("mp_m_freemode_01")
    --setModel("u_m_y_juggernaut_01")
    local style = GetConvar("style"..GetPlayerName(PlayerId()), "Kein Style")
    local style = json.decode(style)
    print(style)
end)

RegisterCommand('ped', function(source, args, raw)
    --print(GetNumberOfPedDrawableVariations(PlayerPedId(), 0))
    --SetPedComponentVariation(PlayerPedId(), 0, 1)
    --SetPedComponentVariation(PlayerPedId(), 11, 2)
    --SetPedComponentVariation(PlayerPedId(), 7, 0)
    --SetPedComponentVariation(PlayerPedId(), 8, 1)
    --SetPedComponentVariation(PlayerPedId(), 9, 0)
    --SetPedComponentVariation(PlayerPedId(), 2, 2, 1)
    print(GetPedTextureVariation(PlayerPedId(), 2))
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

RegisterCommand('show', function()
    local playerPed = PlayerPedId()
    SetEntityVisible(playerPed, true)
    SetGameplayCamRelativeRotation(-100.0, -100.0, 0.0)
end)

RegisterCommand('control', function(source, args, raw)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, -1140.822, -2806.093, 27.70873, true, false, false, true)
    --SetEntityRotation(playerPed, 0.009067512, 0.00114927, -96.40307)
    control = true
end)

RegisterNUICallback("exit", function(data)
    openEntry(false)
end)

function openEditor()
    editor = true
    SetEntityCoords(PlayerPedId(), -1135.24, -2804.194, 27.70873, true, false, false, false)
        setModel("mp_m_freemode_01")
        Citizen.CreateThread(function()
            SetEntityVisible(playerPed, false)
            while control == false do
                --DisableAllControlActions(0)
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
                --FreezeEntityPosition(PlayerPedId(), true)
                SetEntityLocallyVisible(playerPed)
                Citizen.Wait(0)
            end
        end)
    camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1135.5, -2797.0, 28.70876, 0.00, 0.00, 0.00, 15.0, true, 2)
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
    local undershirt = NativeUI.CreateListItem("Unterhemd", undershirtList, 1)
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

function openEntry(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
    })
    print("NUI Nachricht gesendet")
end

RegisterCommand("editor", function()
    openEditor()
end)

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
exports('openEntry', openEntry)