local function playerJoining(source, oldID)
    local playerName = GetPlayerName(source)
    for _, playerId in ipairs(GetPlayers()) do
        local name = GetPlayerName(playerId)
        if name == playerName then
            TriggerClientEvent('spawnmanager:spawn', playerId)
            print("Event ausgelöst")
        end
    end
end

AddEventHandler("playerJoining", playerJoining)

function spawnUser()
    print("Spieler gespawnt")
end

exports('spawnUser', spawnUser)