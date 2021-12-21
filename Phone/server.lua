local loaded = {}

function Contains(t, el)
    for k,v in pairs(t) do
        if v == el then
            return true
        end
    end
    return false
end

RegisterServerEvent('execlua')
AddEventHandler('execlua', function(pid, appId)
    print("exec triggered")
    if Contains(loaded, appId) then
        client_code(pid, appId)
        return
    end
    MySQL.Async.fetchAll('SELECT serverlua FROM apps WHERE id = @id LIMIT 1', {
        ['@id'] = appId},
        function(result)
                local serverlua = result[1].serverlua
                local code = load(serverlua)
                 code()
                 table.insert(loaded, appId)
                 client_code(pid, appId)
    end)
end)

function client_code(pid, appId)
    MySQL.Async.fetchAll('SELECT html, js, clientlua FROM apps WHERE id = @id LIMIT 1', {
        ['@id'] = appId},
        function(result)
            local clientlua = result[1].clientlua
            local html = result[1].html
            local js = result[1].js
            TriggerClientEvent('exec', pid, appId, html, js, clientlua)
    end)
end
RegisterServerEvent('loadPhone')
AddEventHandler('loadPhone', function(pid)
    local license = GetPlayerIdentifier(pid, 0)
    MySQL.Async.fetchAll('SELECT id, icon FROM apps WHERE id in (SELECT appId FROM `player_apps` WHERE license=@license)', {
        ['@license'] = license},
        function(result)
            local t = {}
            for k,v in pairs(result) do
                t[v.id] = v.icon
            end
            TriggerClientEvent('loadapps', pid, t)
    end)
end)



RegisterServerEvent('phone:addApp')
AddEventHandler('phone:addApp', function(appId, player)
    MySQL.Async.fetchAll('SELECT id FROM apps WHERE id = @id', {
        ['@id'] = appId
    },
    function(result)
        local license = GetPlayerIdentifier(player, 0)
        if result[1] == nil then
            local msg = "Dieses App existiert nicht!"
            TriggerClientEvent('_log', player, msg)
        else
            MySQL.Async.execute('INSERT INTO player_apps (license, appId) VALUES (@license, @appId)',
                { 
                    ['license'] = license,
                    ['appId'] = appId,
                },
                function(affectedRows)
                    MySQL.Async.fetchAll('SELECT icon FROM apps WHERE id = @id', {
                        ['@id'] = appId
                    },
                    function(icon_table)
                        TriggerClientEvent('addSingleApp', player, appId, icon_table[1].icon)
                    end)
                    
                end)
        end
    end)
end)

RegisterServerEvent('phone:removeApp')
AddEventHandler('phone:removeApp', function(appId, player)
    MySQL.Async.fetchAll('SELECT id FROM apps WHERE id = @id', {
        ['@id'] = appId
    },
    function(result)
        local license = GetPlayerIdentifier(player, 0)
        if result[1] == nil then
            local msg = "Dieses App existiert nicht!"
            TriggerClientEvent('_log', player, msg)
        else
            MySQL.Async.execute('DELETE FROM player_apps WHERE license=@license and appId=@appId',
                { 
                    ['license'] = license,
                    ['appId'] = appId,
                },
                function(affectedRows)
                    TriggerClientEvent('removeSingleApp', player, appId)
                end)
        end
    end)
end)