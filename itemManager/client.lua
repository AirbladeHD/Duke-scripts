local id = GetPlayerServerId(PlayerId())
--InvAddItem("Joint", 10, id)
InvRegisterItem('Medkit2', 'Ein Erste-Hilfe-Set um dich zu heilen',
    [[RequestAnimDict("amb@world_human_stand_fishing@idle_a")
    if GetVehiclePedIsIn(playerPed, false) ~= 0 then 
        return
    end
    local playerPed = PlayerPedId()
    local id = GetPlayerServerId(PlayerId())
    local health = GetPedMaxHealth(playerPed)
    local coords = GetEntityCoords(playerPed)
    local rotation = GetEntityRotation(playerPed)
    local networkScene = NetworkCreateSynchronisedScene(GetEntityCoords(playerPed), GetEntityRotation(playerPed), 2, false, true, 1.0, 10000, 1.8)
    menu:Visible(false)
    NetworkAddPedToSynchronisedScene(playerPed, networkScene, "amb@world_human_stand_fishing@idle_a", "idle_b", 1.8, 1.9, 8000, 1, 1.5, 0)
    NetworkStartSynchronisedScene(networkScene)
    TriggerServerEvent("inv:removeItem", "Medkits", 1, id)
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        TriggerServerEvent("inv:refresh_inventory", id)
        Citizen.Wait(7000)
        SetEntityHealth(playerPed, health)
        NetworkStopSynchronisedScene(networkScene)
        ShowNotification("Du wurdest geheilt")
    end)]]
)