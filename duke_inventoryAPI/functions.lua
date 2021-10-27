function InvAddItem(item, amount, player)
    TriggerServerEvent('inv:addItem', item, amount, player)
end

function InvRemoveItem(item, amount, player)
    TriggerServerEvent('inv:removeItem', item, amount, player)
end

function InvRegisterItem(item, desc, handler)
    TriggerServerEvent('inv:registerItem', item, desc, handler)
    print("Test")
end