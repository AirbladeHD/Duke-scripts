loaded = {}
Apps = {}
appsloaded = false


function Contains(t, el)
    for k,v in pairs(t) do
        if v == el then
            return true
        end
    end
    return false
end

RegisterNetEvent('exec')
AddEventHandler('exec', function(appId, html, js, lua)
    if not Contains(loaded, appId) then
        local execlua = load(lua)
        execlua()
        SendNUIMessage({type = "js", code = js})
    end
    
    table.insert(loaded, appId)
    SendNUIMessage({type = "swap", code = html})
end)

RegisterNetEvent('loadapps')
AddEventHandler('loadapps', function(_apps)
    Apps = _apps
    appsloaded = true
end)

RegisterNUICallback("openApp", function(data)
    TriggerServerEvent("execlua", GetPlayerServerId(PlayerId()), data.sender)
end)


RegisterNUICallback("closePhone", function(data)
    SetNuiFocus(false, false)
end)

RegisterCommand('addapp', function(source, args, raw)
    exports.Phone:PhoneAddApp(tonumber(args[1]), GetPlayerServerId(PlayerId()))
end)

RegisterCommand('removeapp', function(source, args, raw)
    exports.Phone:PhoneRemoveApp(tonumber(args[1]), GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('_log')
AddEventHandler('_log', function(msg)
    _log(msg)
end)

function _log(msg)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"System", msg}
      })
end

RegisterNUICallback('phoneStarted', function(data)
    Citizen.CreateThread(function()
        while not appsloaded do
            Citizen.Wait(100)
        end
        tableToHomeScreen()
    end)
end)

function tableToHomeScreen()
    for k,v in pairs(Apps) do
        addApp(k,v)
    end
end

function addApp(_id, url)
    SendNUIMessage({type="addapp", id=_id, url=url})
end


Citizen.CreateThread(function()
while true do
    Wait(0)
    if IsControlJustPressed(0, 191) then
        SetNuiFocus(true, true)
        SendNUIMessage({type = "ui"})
    end
end
end)

RegisterNetEvent('addSingleApp')
AddEventHandler('addSingleApp', function(appId, icon)
    addApp(appId, icon)
    Apps[appId] = icon;
end)

RegisterNetEvent('removeSingleApp')
AddEventHandler('removeSingleApp', function(appId)
    table.remove(Apps, appId)
    SendNUIMessage({type="removeApp", id=appId})
end)

TriggerServerEvent("loadPhone", GetPlayerServerId(PlayerId()))