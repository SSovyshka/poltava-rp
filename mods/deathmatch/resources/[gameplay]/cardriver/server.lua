local startJobPickup = createPickup( startDrivePosition[1], startDrivePosition[2], startDrivePosition[3], 3, 1239, 50 )
local collisions = {}
local prl = exports.poltavarplib

function createCollisions()
    for i, collisionPos in ipairs(spawnCarPosition) do
        local x, y, z = collisionPos[1], collisionPos[2], collisionPos[3]
        local collision = createColRectangle(x - 2.8, y - 5, 5, 10)
        setElementData(collision, 'collision:vehicle:x', x)
        setElementData(collision, 'collision:vehicle:y', y)
        setElementData(collision, 'collision:vehicle:z', z)
        table.insert(collisions, collision)
    end
end

function handleVehicleEnter(vehicle, player)
    local x, y, z = getElementData(vehicle, 'vehicle:enddrivepoint:x'), getElementData(vehicle, 'vehicle:enddrivepoint:y'), getElementData(vehicle, 'vehicle:enddrivepoint:z')
    local blip = createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 65535, player)
    local marker = createMarker(x, y, z - 1, 'cylinder', 2, 255, 0, 0, 255, player)
                
    setElementData(vehicle, 'vehicle:marker', marker)
    setElementData(vehicle, 'vehicle:blip', blip)

    addEventHandler("onMarkerHit", marker, function(hitElement)
        if hitElement == vehicle then
            local health = getElementHealth(vehicle)

            destroyElement(getElementData(vehicle, 'vehicle:marker'))
            destroyElement(getElementData(vehicle, 'vehicle:blip'))
            destroyElement(vehicle)

            outputChatBox(health * 10)
            givePlayerMoney(player, health * 10)
        end
    end)
end

function handleVehicleExit(vehicle)
    if getElementData(vehicle, 'vehicle:blip') then
        destroyElement(getElementData(vehicle, 'vehicle:blip'))
    end

    if getElementData(vehicle, 'vehicle:marker') then
        destroyElement(getElementData(vehicle, 'vehicle:marker'))
    end
end

function startDriveJob(player)
    local freeCollision = prl:getFreeColisions(collisions, 'vehicle')

    if freeCollision then
        local x, y, z = getElementData(freeCollision, 'collision:vehicle:x'), getElementData(freeCollision, 'collision:vehicle:y'), getElementData(freeCollision, 'collision:vehicle:z')
        local vehicle = createVehicle(411, x, y, z)

        if vehicle then
            local random = math.random(1, #endDrivePosition)
            setElementData(vehicle, 'vehicle:enddrivepoint:x', endDrivePosition[random][1])
            setElementData(vehicle, 'vehicle:enddrivepoint:y', endDrivePosition[random][2])
            setElementData(vehicle, 'vehicle:enddrivepoint:z', endDrivePosition[random][3])

            addEventHandler("onVehicleEnter", vehicle, function()
                handleVehicleEnter(vehicle, player)
            end)

            addEventHandler("onVehicleExit", vehicle, function()
                handleVehicleExit(vehicle)
            end)
        end
    end
end

addEventHandler("onPickupHit", startJobPickup, startDriveJob)
addEventHandler("onResourceStart", resourceRoot, createCollisions)