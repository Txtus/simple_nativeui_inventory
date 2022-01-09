ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('sni:openotherinventory')
AddEventHandler('sni:openotherinventory', function(id)
    src = source 
    local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
    TriggerClientEvent('sni:cl:openanyinv', src, items, id)
end)

RegisterNetEvent('sni:takeitem')
AddEventHandler('sni:takeitem', function(name, count, id)
    src = source
    xPlayer = ESX.GetPlayerFromId(src)
    xTarget = ESX.GetPlayerFromId(id)
    if xPlayer.canCarryItem(name, count) then 
        xTarget.removeInventoryItem(name, count)
        xPlayer.addInventoryItem(name, count)
    else
        xPlayer.showNotification("Du kannst so viel nicht tragen")
    end
end)