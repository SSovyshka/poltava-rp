sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local veh = nil


-----__ (Сервер -> Клиент) __-----

---Возвращение клиента списка автомобилей
addEvent("onGetCars", true)
addEventHandler("onGetCars", root, function(player)
    local sqlQuery = "SELECT * FROM car WHERE user = '" .. getPlayerName(player).. "'"
    local result = dbQuery(sqlLink, sqlQuery)

    if result then
        local rows = dbPoll(result, -1)

        if #rows > 0 then
            triggerClientEvent("testCarS", root, rows)
        end

    end
end)

