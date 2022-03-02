_Pool = NativeUI.CreatePool()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        entry = GetConvar("entry"..GetPlayerName(PlayerId()), "error")
        _Pool:ProcessMenus()
        if IsControlJustReleased(0, 289) then
            openMenu()
        end
    end
end)

function openMenu()
    local playerPed = PlayerPedId()
    data = GetConvar("data"..GetPlayerName(PlayerId()), "error")
    inventory = GetConvar("inventory"..GetPlayerName(PlayerId()), "error")
    data = json.decode(data)
    name = string.upper(string.sub(data.firstName, 1, 1)).."."..string.upper(string.sub(data.lastName, 1, 1))..string.sub(data.lastName, 2)
    menu = NativeUI.CreateMenu(name, 'Aktion auswählen:')
    invMenu = _Pool:AddSubMenu(menu, "Inventar", "Dein persönlicher Rucksack.")
    _Pool:Add(menu)
    _Pool:MouseControlsEnabled (false)
    _Pool:MouseEdgeEnabled (false)
    _Pool:ControlDisablingEnabled(false)

    if inventory == "{}" then
        local item = NativeUI.CreateItem('Leer', 'Du hast nichts in deinem Inventar')
        invMenu:AddItem(item)
    else
        local inventory = json.decode(inventory)
        for i = 1, #inventory do
            local item = NativeUI.CreateItem(inventory[i].name.." ("..inventory[i].quant..")", inventory[i].desc)
            invMenu:AddItem(item)
            item.Activated = function(sender, index)
                local handler = inventory[i].handler
                if handler ~= "No Handler" then
                    local func = load(handler)
                    func()
                end
            end
        end
    end

    local item2 = NativeUI.CreateItem('Dokumente', 'Alle Dokumente, die du gerade dabei hast.')
    local item3 = NativeUI.CreateItem('Persönliches', 'Persönliche Daten.')

    menu:AddItem(item2)
    menu:AddItem(item3)

    item2.Activated = function(sender, index)
        print("Ausrichtung: ")
    end

    menu:Visible(true)
end