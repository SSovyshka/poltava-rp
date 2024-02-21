local startJobPickup = createPickup( startDrivePosition[1], startDrivePosition[2], startDrivePosition[3], 3, 1239, 50 )
local collisions = {}


function getFreeColisions(collisionTable)
    for i, collision in ipairs(collisionTable) do
        local elements = getElementsWithinColShape(collision, 'vehicle')
        if #elements == 0 then
            return collision
        end
    end
    return nil -- Возвращаем nil, если все коллизии заняты
end

function createCollisions()

    for i, collision in ipairs(spawnCarPosition) do
        collision = createColRectangle( spawnCarPosition[i][1] - 2.8, spawnCarPosition[i][2] - 5, 5, 10 )
        setElementData( collision, 'collision:vehicle:x', spawnCarPosition[i][1] )
        setElementData( collision, 'collision:vehicle:y', spawnCarPosition[i][2] )
        setElementData( collision, 'collision:vehicle:z', spawnCarPosition[i][3] )
        table.insert( collisions, collision )
    end
end
addEventHandler( "onResourceStart", root, createCollisions )

function startDriveJob( player )
    local freeCollision = getFreeColisions( collisions )

    if freeCollision then
        local x, y, z = getElementData(freeCollision, 'collision:vehicle:x'), getElementData(freeCollision, 'collision:vehicle:y'), getElementData(freeCollision, 'collision:vehicle:z')
        local vehicle = createVehicle( 411, x, y, z )
    end
   
end
addEventHandler( "onPickupHit", startJobPickup, startDriveJob )




