local collisions = {}


local prl = exports['[library]poltavarp']


local collision2 = createColRectangle(-1192.01965 - 2.5, -1184.74976 - 2.5, 5, 5)
local collision3 = createColRectangle(2114.73145 - 2.5, -1779.30017 - 2.5, 5, 5)


local getCarBlip = createMarker(-1101.90564, -1250.54358, 128.21875, "cylinder", 1.25, 255, 255, 255, 150)
local sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/works.db" -- путь к файлу БД 
) 

addEventHandler("onColShapeHit", collision2, function(hitElement)
    if getElementType(hitElement) == 'vehicle' and getElementData(hitElement, "vehicle:work") == 'farmer_2' then

        if not getElementData(hitElement, "vehicle:isloaded") then

            setElementFrozen(hitElement, true)
            setTimer(function() 
            
                local seno = createObject(3374, 0, 0, 0)
                local seno2 = createObject(3374, 0, 0, 0)
    
                setElementCollisionsEnabled(seno, false)
                setElementCollisionsEnabled(seno2, false)
    
                setObjectScale(seno, 0.7)
                setObjectScale(seno2, 0.7)
    
                attachElements(seno, hitElement, 0, 0.8, 0.8)
                attachElements(seno2, hitElement, 0, -2.1, 0.8)
    
                setElementData(hitElement, "vehicle:isloaded", true)        
                setElementData(hitElement, "vehicle:seno", seno)
                setElementData(hitElement, "vehicle:seno2", seno2)

                setElementFrozen(hitElement, false)

                
                destroyElement(getElementData(hitElement, "vehicle:blip"))
                local blip = createBlip(2114.73145, -1779.30017, 0, 0, 2, 255, 0, 0, 255)
                setElementData(hitElement, "vehicle:blip", blip)

            end, 5000, 1)
            
        end
    end
end)


addEventHandler("onColShapeHit", collision3, function(hitElement)
    if getElementType(hitElement) == 'vehicle' and getElementData(hitElement, "vehicle:work") == 'farmer_2' then
        if getElementData(hitElement, "vehicle:isloaded") == true then
            local player = getVehicleOccupant(hitElement, 0)
            setElementFrozen(hitElement, true)
            setTimer(function() 
                destroyElement(getElementData(hitElement, "vehicle:seno"))
                destroyElement(getElementData(hitElement, "vehicle:seno2"))

                setElementData(hitElement, "vehicle:seno", nil)
                setElementData(hitElement, "vehicle:seno2", nil)

                setElementData(hitElement, "vehicle:isloaded", false)
                setElementFrozen(hitElement, false)

                givePlayerMoney(player, 15000)

                destroyElement(getElementData(hitElement, "vehicle:blip"))
                local blip = createBlip(-1192.28943, -1184.84863, 0, 0, 2, 255, 0, 0, 255)
                setElementData(hitElement, "vehicle:blip", blip)

                local sqlQuery = "UPDATE farmer SET experience_level_2 = experience_level_2 + 1 WHERE player = '" .. getPlayerName(player) .. "'"
                dbExec(sqlLink, sqlQuery)
            end, 5000, 1)
        end
    end
end)


function playerStartFarmDriverJob( player )
    if getElementType(player) == 'player' then
        if getElementData(player, 'job:isworking') then
            outputChatBox('[Робота] Ти звільнився!', player, 255, 0, 0)
            
            playerEndFarmerDriveJob( player )
        else
            setElementData(player, 'job:isworking', true)

            setElementData(player, 'player:isRented', nil)
            setElementData(player, 'player:work', "farmer_2")
            
            insertPlayerIntoDatabase( player )

            outputChatBox('[Робота] Ти влаштувався на роботу!', player, 0, 255, 0)
        end
    end
end
addEvent( 'startFarmerJobLevel2Server', true )
addEventHandler( 'startFarmerJobLevel2Server', root, playerStartFarmDriverJob )



function playerEndFarmerDriveJob( player ) -- Когда игрок заканчивает работу
    
    setElementData(player, 'player:work', nil, true)
    setElementData(player, 'job:isworking', nil, true)
    
    -- setPedAnimation(player, 'CARRY', 'putdwn', 0, false, false, false, false)
    playerToggleControll(player, true)

end


function createCollisions()
    for i, collisionPos in ipairs(carSpawnPositions) do
        local x, y, z = collisionPos[1], collisionPos[2], collisionPos[3]
        local collision = createColRectangle(x - 2.8, y - 5, 5, 10)
        setElementData(collision, 'collision:vehicle:x', x)
        setElementData(collision, 'collision:vehicle:y', y)
        setElementData(collision, 'collision:vehicle:z', z)
        table.insert(collisions, collision)
    end
end
addEventHandler("onResourceStart", resourceRoot, createCollisions)


function createVehicleInFreeColision()
    local freeColision = prl:getFreeColisions(collisions, "vehicle");

    if freeColision then
        local x, y, z = getElementData(freeColision, 'collision:vehicle:x'), getElementData(freeColision, 'collision:vehicle:y'), getElementData(freeColision, 'collision:vehicle:z')
        local vehicle = createVehicle(578, x, y, z)

        setElementData(vehicle, "vehicle:tenant", nil)
        setElementData(vehicle, "vehicle:isloaded", false)
        setElementData(vehicle, "vehicle:work", 'farmer_2')

        addEventHandler("onVehicleStartEnter", vehicle, function(player)
            local playerWork = getElementData(player, 'player:work')
            local rentedVehicle = getElementData(player, 'player:isRented')
            if not playerWork or playerWork ~= "farmer_2" then
                cancelEvent()
                return
            end
        
            local vehicleTenant = getElementData(vehicle, "vehicle:tenant")
            if not vehicleTenant then
                if rentedVehicle and rentedVehicle ~= vehicle and rentedVehicle ~= nil then
                    cancelEvent()
                    return
                end

                
                setElementData(vehicle, "vehicle:tenant", player)
                setElementData(player, 'player:isRented', vehicle)
            elseif vehicleTenant ~= player then
                cancelEvent()
            end
        end)

        addEventHandler("onVehicleEnter", vehicle, function(player)
            local blip = createBlip(-1192.28943, -1184.84863, 0, 0, 2, 255, 0, 0, 255)
            setElementData(vehicle, "vehicle:blip", blip)
        end)

        addEventHandler("onVehicleExit", vehicle, function()
            if getElementData(vehicle, "vehicle:blip") then
                destroyElement(getElementData(vehicle, "vehicle:blip"))
            end
        end)

        addEventHandler('onVehicleExplode', vehicle, function(player)
            destroyElement(getElementData(vehicle, "vehicle:seno"))
            destroyElement(getElementData(vehicle, "vehicle:seno2"))
            destroyElement(getElementData(vehicle, "vehicle:blip"))
            setElementData(getElementData(source, "vehicle:tenant"), 'player:isRented', nil)
        end)


    end
end
addEventHandler("onMarkerHit", getCarBlip, createVehicleInFreeColision)
