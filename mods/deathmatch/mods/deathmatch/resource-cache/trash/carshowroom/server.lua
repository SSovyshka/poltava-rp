-- local vehMark = createMarker(2048, 1523, 9.5,"cylinder")

-- addEvent("onPlayerRequestCarSpawn", true)
-- addEventHandler("onPlayerRequestCarSpawn", root, function(player, id, price)
--     local x,y,z = getElementPosition(player)
--     local veh = createVehicle(id, x,y,z)
--     warpPedIntoVehicle(player,veh)
--     setElementData(veh, "owner", getPlayerName(player))
--     takePlayerMoney(player, price)
-- end)
sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

function generateUniqueId()
    return tostring(os.time(os.date("!*t")) * 1000 + tonumber(string.sub(tostring(os.clock()), 3, 5)))
end

addEvent("onPlayerRequestCarSpawn", true)
addEventHandler("onPlayerRequestCarSpawn", root, function(player, vehicle)
    if getPlayerMoney(player) >= vehicle.price then
        if getPedOccupiedVehicle(player) == false then
            local x,y,z = getElementPosition(player)
            local veh = createVehicle(vehicle.carId, x,y,z)
            warpPedIntoVehicle(player,veh)
            setElementData(veh, "owner", getPlayerName(player))
            takePlayerMoney(player, vehicle.price)

            local sqlQuery = "INSERT INTO car (user, car_id, car_model) VALUES ('" .. getPlayerName(player) .. "', " .. generateUniqueId() .. " ," .. vehicle.carId .. ")"
            local result = dbExec(sqlLink, sqlQuery)

            if not result then
                outputChatBox("Ошибка при выполнении SQL-запроса: " .. dbErrorMessage(sqlLink))
            else
                outputChatBox("Данные успешно добавлены в таблицу car.")
            end
        end
    end
end)

addEvent("onGetCar", true)
addEventHandler("onGetCar", root, function(player, carId)
    local sqlQuery = "SELECT * FROM car WHERE user = '" .. getPlayerName(player) .. "' AND car_id = " .. carId
    local result = dbQuery(sqlLink, sqlQuery)
    local veh

    if result then
        local rows = dbPoll(result, -1)
        local x,y,z = getElementPosition(player)

    
        if #rows > 0 then
            for _, row in ipairs(rows) do 
                outputDebugString("Найдена запись: user = " .. row.user .. ", car_id = " .. row.car_id)
                veh = createVehicle(row.car_model, x, y, z)
                outputDebugString(tostring(veh))
                warpPedIntoVehicle(player, veh)
            end
            
            
        else
            outputDebugString("Запись не найдена для игрока с именем " .. playerNameToSearch)
        end
    else
        outputDebugString("Ошибка при выполнении SQL-запроса: " .. dbErrorMessage(sqlLink))
    end

end)
