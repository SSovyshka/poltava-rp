local startJobMarker = createPickup( startJobPositionMarker[1], startJobPositionMarker[2], startJobPositionMarker[3], 3, 1239, 0 )


function playerStartJob( player ) -- Когда игрок заходит на метку начинается работа
    if getElementType(player) == 'player' and not getPedOccupiedVehicle(player) then
        if getElementData(player, 'job:isworking') then
            outputChatBox('[Робота] Ти звільнився!', player, 255, 0, 0)

            playerEndJob( player )
        else
            setElementData(player, 'job:isworking', true)
            setElementData(player, 'job:box:counter', 0)
            setElementData(player, 'job:box:object', nil)
            setElementData(player, 'job:marker', nil)
            setElementData(player, 'job:collision', nil)

            outputChatBox('[Робота] Ти влаштувався!', player, 0, 255, 0)
            
            createPickUpMarker( player )
        end
    end
end
addEventHandler( 'onPickupHit', startJobMarker, playerStartJob )


function playerEndJob( player ) -- Когда игрок заканчивает работу
    if getElementData(player, 'job:marker') then
        destroyElement(getElementData(player, 'job:marker'))
    end

    if getElementData(player, 'job:collision') then
        destroyElement(getElementData(player, 'job:collision'))
    end

    if getElementData(player, 'job:box:object') then
        destroyElement(getElementData(player, 'job:box:object'))
    end
    
    setElementData(player, 'job:isworking', nil, true)
    
    setPedAnimation(player,'CARRY','putdwn',0,false,false, false, false)
    playerToggleControll(player, true)

    givePlayerPayday( player )
end



function playerToggleControll( player, arg ) -- Включение/выключение управления игрока
    toggleControl( player, 'fire', arg )
    toggleControl( player, 'aim_weapon', arg )
    toggleControl( player, 'next_weapon', arg )
    toggleControl( player, 'previous_weapon', arg )
    toggleControl( player, 'jump', arg )
    toggleControl( player, 'sprint', arg )
    toggleControl( player, 'crouch', arg )
end


function givePlayerPayday( player ) -- Выдача зарплаты игроку
    if getElementType(player) == 'player' then
        givePlayerMoney( player, getElementData(player, 'job:box:counter') * 100 )
    end
end


function createPickUpMarker( player ) -- Создание маркера для поднятия груза
    local random = math.random(1, #boxPickupPotition)
    local x, y, z = boxPickupPotition[random][1], boxPickupPotition[random][2], boxPickupPotition[random][3]

    local marker = createMarker( x, y, z-1, 'cylinder', 1.5, 255, 0, 0, 150, player )
    local collision = createColSphere( x, y, z-1, 1.5 )

    setElementData(collision, 'job:player', player)

    setElementData(player, 'job:marker', marker)
    setElementData(player, 'job:collision', collision)

    addEventHandler('onColShapeHit', collision, function( player )
        if getElementType(player) == 'player' and getElementData(collision, 'job:player') == player and not getPedOccupiedVehicle(player) then
            destroyElement(getElementData(player, 'job:marker'))
            destroyElement(getElementData(player, 'job:collision'))
            
            setPedAnimation(player, 'CARRY', 'liftup', 1, false)

            setTimer(function()
                setPedAnimation(player, 'CARRY', 'crry_prtial', 2, true, true, true)

                playerToggleControll( player, false )

                local box = createObject(3052, 0, 0, 0)
                setObjectScale(box, 1)
                setElementData(player, 'job:box:object', box)
                exports.bone_attach:attachElementToBone(box, player, 11, -0.17, 0.12, 0.1, -90, -15, -10)

                createPutDownMarker( player )
            end, 1000, 1)
        
        end
    end)

end


function createPutDownMarker( player ) -- Создание маркера для сдачи груза
    local x, y, z = boxPutdownPosition[1], boxPutdownPosition[2], boxPutdownPosition[3]

    local marker = createMarker( x, y, z-1, 'cylinder', 1.5, 255, 0, 0, 150, player)
    local collision = createColSphere( x, y, z-1, 1.5 )

    setElementData(collision, 'job:player', player)

    setElementData(player, 'job:marker', marker)
    setElementData(player, 'job:collision', collision)

    addEventHandler('onColShapeHit', collision, function( player )
        if getElementType(player) == 'player' and getElementData(collision, 'job:player') == player and not getPedOccupiedVehicle(player) then

            destroyElement(getElementData(player, 'job:marker'))
            destroyElement(getElementData(player, 'job:collision'))

            setPedAnimation(player,'CARRY','putdwn',1,false)
            setTimer(function()
                setPedAnimation(player,'CARRY','putdwn',0,false,false, false, false)
                setElementData(player, 'job:box:counter', getElementData(player, 'job:box:counter') + 1)
                destroyElement(getElementData(player, 'job:box:object'))
                
                outputChatBox(getElementData(player, 'job:box:counter') .. " = " .. getElementData(player, 'job:box:counter') * 100, player, 0, 255, 0)
                -- triggerClientEvent(player, 'updateLoader', root, player)
                playerToggleControll(player, true)

                
                createPickUpMarker( player )
            end, 1000, 1)

        end
    end)
    
end
