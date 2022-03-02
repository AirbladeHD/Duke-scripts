function ShowDukeNotification(player, msg, duration)
    TriggerServerEvent("ShowDukeNotification", player, msg, duration)
end

function ClearNotifications(player)
    TriggerServerEvent("ClearNotifications", player)
end