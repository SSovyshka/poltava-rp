local startJobMarker = createPickup(-713.72919, 947.95721, 12.28290, 3, 1239, 0)
local orderList = {}

addEventHandler('onPickupHit', startJobMarker, function(player)
    local vehicle = createVehicle(420, -723.72919, 947.95721, 12.28290)

    setElementData(player, "job:work", 'taxi')

    addEventHandler('onVehicleEnter', vehicle, function()
        bindKey(player, 'k', 'down', function()
            triggerClientEvent(player, 'setClientOrderList', root, orderList)
            triggerClientEvent(player, 'openKPK', root)         
        end)
    end)

    addEventHandler('onVehicleExit', vehicle, function()
        unbindKey(player, 'k', 'down')
    end)

end)

function addTaxiOrder(player)
    local x, y, z = getElementPosition(player)

    for i, order in ipairs(orderList) do
        if order.player == getPlayerName(player) then
            outputChatBox("Вы вже маете замовлення!")
            return
        end
    end

    local order = {
        player = getPlayerName(player),
        x = x,
        y = y,
        z = z
    }
    table.insert(orderList, order)

end
addEvent("addTaxiOrder", true)
addEventHandler("addTaxiOrder", root, addTaxiOrder)

function deleteTaxiOrder(playerName)
    for i, order in ipairs(orderList) do
        if order.player == playerName then
            table.remove(orderList, i)
            outputChatBox("Taxi order for " .. playerName .. " deleted")
        end
    end
end
addEvent("deleteTaxiOrder", true)
addEventHandler("deleteTaxiOrder", root, deleteTaxiOrder)

function getAllTaxiOrders()
    outputChatBox("------------------------------------------------------")
    outputChatBox(tostring(toJSON(orderList)))
end
addEvent("getTaxiOrders", true)
addEventHandler("getTaxiOrders", root, getAllTaxiOrders)

function getTaxiOrder(playerName, taxidriver)
    for i, order in ipairs(orderList) do
        if order.player == playerName then
            triggerClientEvent(getPlayerFromName( playerName ), 'showInteraptedMessage', root, 'Залишайся на точці!')

            local blip = createBlip(order.x, order.y, order.z, 0, 1, 255, 0, 0, 255, 0, 65535, taxidriver)
            local marker = createMarker(order.x, order.y, order.z - 1, 'cylinder', 1.5, 255, 0, 0, 255, taxidriver)

            addEventHandler("onMarkerHit", marker, function(hitElement)
                if hitElement == taxidriver then
                    destroyElement( marker )
                    destroyElement( blip )
                    triggerClientEvent(taxidriver, 'showInteraptedMessage', root, 'Зачекайте клієнта!')
                    triggerClientEvent(taxidriver, 'openMoneyTaker', root)
                end
            end)

            return
        end
    end
end
addEvent("getTaxiOrder", true)
addEventHandler("getTaxiOrder", root, getTaxiOrder)
