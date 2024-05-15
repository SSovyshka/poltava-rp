local sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/works.db" -- путь к файлу БД 
) 


function playerStartFarmerJob( player ) -- Когда игрок заходит на метку начинается работа
    if getElementType(player) == 'player' then


        if getElementData(player, 'job:isworking') then
            outputChatBox('[Робота] Ти звільнився!', player, 255, 0, 0)
            triggerClientEvent(player, 'showFarmerJobGUI', root, false)
            playerEndFarmerJob( player )
        else
            setElementData(player, 'job:isworking', true)
            setElementData(player, 'player:work', "farmer_1")
            setElementData(player, 'job:box:counter', 0)
            setElementData(player, 'job:box:counternextmarker', 0)
            setElementData(player, 'job:box:object', nil)
            setElementData(player, 'job:marker', nil)
            setElementData(player, 'job:collision', nil)
            
            insertPlayerIntoDatabase( player )

            triggerClientEvent(player, 'showFarmerJobGUI', root, true)

            outputChatBox('[Робота] Ти влаштувався на роботу!', player, 0, 255, 0)
            
            createPickUpMarker( player )
        end
    end
end
addEvent('startFarmerJobLevel1Server', true)
addEventHandler( 'startFarmerJobLevel1Server', root, playerStartFarmerJob )


function playerEndFarmerJob( player ) -- Когда игрок заканчивает работу
    givePlayerPayday( player )
    
    if getElementData(player, 'job:marker') then
        destroyElement(getElementData(player, 'job:marker'))
    end

    if getElementData(player, 'job:collision') then
        destroyElement(getElementData(player, 'job:collision'))
    end

    if getElementData(player, 'job:box:object') then
        destroyElement(getElementData(player, 'job:box:object'))
    end
    
    setElementData(player, 'job:box:counter', 0)
    setElementData(player, 'player:work', nil, true)
    setElementData(player, 'job:isworking', nil, true)
    
    setPedAnimation(player, 'CARRY', 'putdwn', 0, false, false, false, false)
    playerToggleControll(player, true)

    
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
        local counter = getElementData(player, 'job:box:counter')
        local salary = 0 
        
        givePlayerMoney( player, counter * salaryMultiplier + salary )

        local sqlQuery = "UPDATE farmer SET experience_level_1 = experience_level_1 + ".. getElementData(player, 'job:box:counter') .." WHERE player = '" .. getPlayerName(player) .. "'"
        dbExec(sqlLink, sqlQuery)

    end
end


-- function createPickUpMarker( player ) -- Создание маркера для поднятия груза
--     local random = math.random(1, #pickupPosition)
--     local x, y, z = pickupPosition[random][1], pickupPosition[random][2], pickupPosition[random][3]

--     local marker = createMarker( x, y, z-1, 'cylinder', 1.5, 255, 0, 0, 150, player )
--     local collision = createColSphere( x, y, z-1, 1.5 )

--     setElementData(collision, 'job:player', player)

--     setElementData(player, 'job:marker', marker)
--     setElementData(player, 'job:collision', collision)

--     addEventHandler('onColShapeHit', collision, function( player )
--         if getElementType(player) == 'player' and getElementData(collision, 'job:player') == player and not getPedOccupiedVehicle(player) then
--             destroyElement(getElementData(player, 'job:marker'))
--             destroyElement(getElementData(player, 'job:collision'))
            
--             setPedAnimation(player, 'BOMBER', 'bom_plant', 1, false)
--             setTimer(function()
--                 setPedAnimation(player, 'BOMBER', 'bom_plant', 0, false, false, false, false)

--                 playerToggleControll( player, false )

--                 if getElementData(player, 'job:box:counternextmarker') ~= 4 then
--                     createPickUpMarker( player )
--                     setElementData(player, 'job:box:counternextmarker', getElementData(player, 'job:box:counternextmarker') + 1)
--                 else

--                     local box = createObject(3374, 0, 0, 0)
--                     setObjectScale(box, 0.04)
--                     setElementData(player, 'job:box:object', box)
--                     exports.bone_attach:attachElementToBone(box, player, 12, 0, 0.1, 0.1, 0, 0, 0)

--                     createPutDownMarker( player )
--                     setElementData(player, 'job:box:counternextmarker', 0)
--                 end

--             end, 2500, 1)
        
--         end
--     end)

-- end


-- function createPutDownMarker( player ) -- Создание маркера для сдачи груза
--     local x, y, z = putdownPosition[1], putdownPosition[2], putdownPosition[3]

--     local marker = createMarker( x, y, z-1, 'cylinder', 1.5, 255, 0, 0, 150, player)
--     local collision = createColSphere( x, y, z-1, 1.5 )

--     setElementData(collision, 'job:player', player)

--     setElementData(player, 'job:marker', marker)
--     setElementData(player, 'job:collision', collision)

--     addEventHandler('onColShapeHit', collision, function( player )
--         if getElementType(player) == 'player' and getElementData(collision, 'job:player') == player and not getPedOccupiedVehicle(player) then

--             destroyElement(getElementData(player, 'job:marker'))
--             destroyElement(getElementData(player, 'job:collision'))

--             setPedAnimation(player,'CARRY','putdwn',1,false)
--             setTimer(function()
--                 setPedAnimation(player,'CARRY', 'putdwn', 0, false, false, false, false)
--                 setElementData(player, 'job:box:counter', getElementData(player, 'job:box:counter') + 1)
--                 destroyElement(getElementData(player, 'job:box:object'))
                
--                 playerToggleControll(player, true)
                

                
--                 createPickUpMarker( player )
--             end, 1000, 1)

--         end
--     end)
    
-- end


addEventHandler("onResourceStart", resourceRoot, function()
    local x, y, z = -1185, -1059, 128 
    local j = 0 -- начальное значение переменной j

    -- Создаем функцию, которая будет запускать итерации цикла с задержкой
    local function delayedIteration()
        for i = 0, 26, 1 do 
            local senoDlyaSbora = createObject(864, x, y, z)
            local senoDlyaSboraCol = createColSphere( x, y, z, 2)

            addEventHandler("onColShapeHit", senoDlyaSboraCol, function(hitElement)
                if getElementType(hitElement) == "player" and getElementData(hitElement, 'player:work') == "farmer_1"  then
                    destroyElement(senoDlyaSboraCol)

                    setPedAnimation(hitElement, 'BOMBER', 'bom_plant', 1, false)
                    setTimer(function()
                        setPedAnimation(hitElement, 'BOMBER', 'bom_plant', 0, false, false, false, false)

                        playerToggleControll( hitElement, false )

                        destroyElement(senoDlyaSbora)
                        playerToggleControll( hitElement, true )


                        setElementData(hitElement, 'job:box:counter', getElementData(hitElement, 'job:box:counter') + 1)

                    end, 2500, 1)
                end
            end)

            y = y + 5
        end
        y = -1059
        x = x + 5

        j = j + 1 -- увеличиваем j после каждой итерации
        if j <= 35 then -- проверяем, достигли ли мы нужного количества итераций
            setTimer(delayedIteration, 750, 1) -- вызываем delayedIteration снова через 1000 миллисекунд
        end
    end

    -- Запускаем первую итерацию цикла
    delayedIteration()
end)
