RegisterServerEvent("ShowDukeNotification")
AddEventHandler("ShowDukeNotification", function(player, msg, duration)
    TriggerClientEvent("ShowDukeNotification", player, msg, duration)
end)

RegisterServerEvent("ClearNotifications")
AddEventHandler("ClearNotifications", function(player)
    TriggerClientEvent("ClearNotifications", player)
end)