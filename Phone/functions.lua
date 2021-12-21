function PhoneAddApp(appId, player)
    TriggerServerEvent('phone:addApp', appId, player)
end

function PhoneRemoveApp(appId, player)
    TriggerServerEvent('phone:removeApp', appId, player)
end

function PhoneRegisterApp(appId, icon, html, client, server)
    TriggerServerEvent('phone:regApp', appId, icon, html, client, server)
end
