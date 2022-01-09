Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand('inventar', function() 
    inventory()
end)

RegisterKeyMapping("inventar", "inventar öffnen", "keyboard", "M")

_menuPool = NativeUI.CreatePool()

Citizen.CreateThread(function()
    while true do
        if _menuPool:IsAnyMenuOpen() then 
            _menuPool:ProcessMenus()
        else
            _menuPool:CloseAllMenus()
        end
    Citizen.Wait(0)
    end
end)

function CreateDialog(OnScreenDisplayTitle_shopmenu) --general OnScreenDisplay for KeyboardInput
    AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
    DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local displayResult = GetOnscreenKeyboardResult()
        return displayResult
    end
end

function inventory() 
    mainMenu = NativeUI.CreateMenu("Inventar", "Deine Gegenstände")
    inventoryitems = ESX.GetPlayerData().inventory
    _menuPool:Add(mainMenu) 
    for k, v in pairs(inventoryitems) do
        if v.count > 0 then 
            local submenu = _menuPool:AddSubMenu(mainMenu, v.count.."x "..v.label, v.label, v.name)
            local use = NativeUI.CreateItem("Benutzen", v.label.." benutzen")
            if v.usable then 
                submenu:AddItem(use)
            end
            local give = NativeUI.CreateItem("Weitergeben", v.label.." Weitergeben", 1)
            submenu:AddItem(give)
            local wegwerfen = NativeUI.CreateItem("Wegwerfen", v.label.." Wegwerfen")
            if v.canRemove then 
                submenu:AddItem(wegwerfen)
            end
            mainMenu:AddItem(submenu)
          
            submenu.OnItemSelect = function(sender, item, index)
               if item == use then 
                    TriggerServerEvent('esx:useItem', v.name)
                    _menuPool:CloseAllMenus()
               elseif item == wegwerfen then 
                local amount = CreateDialog("Wie viel willst du wegwerfen?")
                    if tonumber(amount) <= v.count then 
                        TriggerServerEvent("esx:removeInventoryItem", "item_standard", v.name, tonumber(amount))
                        _menuPool:CloseAllMenus()
                    end
                elseif item == give then 
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance < 3.0 then
                        local amount = CreateDialog("Wie viel willst du weitergeben?")
                        if tonumber(amount) <= v.count then 
                            TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), 'item_standard',v.name, tonumber(amount))
                            _menuPool:CloseAllMenus()
                        end
                    else
                        ESX.ShowNotification("Kein Spieler in der Nähe")
                        return 
                    end
                end
            end
        end
    end
    mainMenu:Visible(true) 
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled (false)
    _menuPool:MouseEdgeEnabled (false)
    _menuPool:ControlDisablingEnabled(false)  
end

RegisterNetEvent('sni:cl:openanyinv')
AddEventHandler('sni:cl:openanyinv', function(inv, id)
    otherinv = NativeUI.CreateMenu("Inventar von ID: "..id, "Gegenstände")
    _menuPool:Add(otherinv) 
    for k, v in pairs(inv) do
        if v.count > 0 then 
            item = NativeUI.CreateItem(v.label.." "..v.count.."x ", v.label .." nehmen")
            otherinv:AddItem(item)
            otherinv.OnItemSelect = function(sender, item, index)
                if item == item then 
                    TriggerServerEvent("sni:takeitem", v.name, v.count, id)
                    _menuPool:CloseAllMenus()
                    TriggerServerEvent("sni:openotherinventory", id)
                end
            end
        end
    end
    otherinv:Visible(true) 
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled (false)
    _menuPool:MouseEdgeEnabled (false)
    _menuPool:ControlDisablingEnabled(false)  
end)

RegisterCommand("test", function()
    TriggerServerEvent("sni:openotherinventory", 3)
end)