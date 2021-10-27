local noclip = false
SetTextChatEnabled(false)

function Collision()
    for i=1,256 do
        if NetworkIsPlayerActive(i) then
            SetEntityVisible(GetPlayerPed(i), false, false)
            SetEntityVisible(PlayerPedId(), true, true)
            SetEntityNoCollisionEntity(GetPlayerPed(i), GetPlayerPed(-1), false)
        end
    end
end

function Visible()
    while enable == true do
        Citizen.Wait(0)
        DisableAllControlActions(0)
        Collision()
    end
end

RegisterNetEvent('Test')
AddEventHandler('Test', function()
    print("Test")
end)

--TriggerServerEvent('inv:RegisterItem', "Crack", "Droge zum Verkaufen")

local Camera = {
	face = {x = 402.92, y = -1000.72, z = -98.45, fov = 10.00},
	body = {x = 402.92, y = -1000.72, z = -99.01, fov = 30.00},
}

function CreateSkinCam(camera)
    if camSkin then
        local newCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera[camera].x, Camera[camera].y, Camera[camera].z, 0.00, 0.00, 0.00, Camera[camera].fov, false, 0)
        PointCamAtCoord(newCam, Camera[camera].x, Camera[camera].y, Camera[camera].z)
        SetCamActiveWithInterp(newCam, camSkin, 2000, true, true)
        camSkin = newCam
    else
        camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera[camera].x, Camera[camera].y, Camera[camera].z, 0.00, 0.00, 0.00, Camera[camera].fov, false, 0)
        SetCamActive(cam2, true)
        RenderScriptCams(true, false, 2000, true, true) 
    end
end

RegisterCommand('editor', function()
    --CreateSkinCam('face')
    local playerCoords = GetEntityCoords(PlayerPedId())
    local newCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", playerCoords.x+1, playerCoords.y+1, playerCoords.z+1, 0.00, 0.00, 0.00, 10.00, false, 0)
    PointCamAtCoord(newCam, playerCoords.x, playerCoords.y, playerCoords.z)
    SetCamActive(newCam, true)
    RenderScriptCams(true, false, 2000, true, true) 
    --SetCamActiveWithInterp(newCam, camSkin, 2000, true, true)
    --camSkin = newCam
end)

RegisterCommand('noclip', function()
    SetEntityRecordsCollisions(PlayerPedId(), false)
    if noclip == true then
        --SetEntityVisible(PlayerPedId(), true, false)
        noclip = false
    else
        --SetEntityVisible(PlayerPedId(), false, false)
        noclip = true
    end
    --[[for i=1,256 do
        if NetworkIsPlayerActive(i) then
            print(i)
            --SetEntityVisible(GetPlayerPed(i), false, false)
            SetEntityVisible(PlayerPedId(), false, false)
            SetEntityNoCollisionEntity(GetPlayerPed(i), GetPlayerPed(-1), false)
        end
    end]]--
end)