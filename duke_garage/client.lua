function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool,
    })
end

RegisterCommand('garage', function(source, args, raw)
    local player = GetPlayerServerId(PlayerId())
    TriggerServerEvent("loadVehicles", player)
    SetDisplay(true)
end)

RegisterNetEvent("loadVehiclesCallback")
AddEventHandler("loadVehiclesCallback", function(vehicles)
    for i = 1, #vehicles, 1 do
        config = json.decode(vehicles[i]["config"])
        print(vehicles[i]["manifacturer"].." "..vehicles[i]["displayName"].." "..config[1].." "..config[2])
    end
end)