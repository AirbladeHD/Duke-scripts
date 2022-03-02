colors = {
    white = "\x1B[0m",
    red = "\x1B[31m",
    green = "\x1B[32m",
    yellow = "\x1B[33m",
    blue = "\x1B[36m"
}

function InvAddItem(item, quant, player)
    TriggerServerEvent('inv:addItem', item, quant, player)
end

function InvRemoveItem(item, quant, player)
    TriggerServerEvent('inv:removeItem', item, quant, player)
end

function InvRegisterItem(item, desc, handler)
    TriggerServerEvent('inv:registerItem', item, desc, handler)
end

function RefreshInventorys()
    TriggerEvent("refreshInventorys")
end