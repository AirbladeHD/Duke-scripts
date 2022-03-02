display = false

function SetDisplay(bool, msg, duration)
    display = bool
    SendNUIMessage({
        type = "ui",
        display = bool,
        msg = msg,
        duration = duration
    })
end

RegisterNUICallback("ResetDisplay", function()
    display = false
end)

RegisterNetEvent("ClearNotifications", function()
    SendNUIMessage({
        type = "clear",
    })
end)

RegisterNetEvent("ShowDukeNotification")
AddEventHandler("ShowDukeNotification", function(msg, duration)
    Citizen.CreateThread(function()
        while display == true do
            Citizen.Wait(1)
        end
        SetDisplay(true, msg, duration)
    end)
end)