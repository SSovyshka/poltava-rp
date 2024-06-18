sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

-- local veh = nil

function printCarInfo(cars)
    for _, car in ipairs(cars) do
        outputDebugString("Користувач: " .. car.user)
        outputDebugString("Назва автомобіля: " .. car.car_name)
        outputDebugString("Модель автомобіля: " .. car.car_model)
        outputDebugString("Зображення автомобіля: " .. car.car_image)
        outputDebugString("ID автомобіля: " .. car.car_id)
        
        if car.car_stats and car.car_stats ~= "false" then
            local car_stats = fromJSON(car.car_stats)
            if car_stats then
                outputDebugString("Статистика автомобіля:")
                for stat, value in pairs(car_stats) do
                    outputDebugString("  " .. stat .. ": " .. tostring(value))
                end
            else
                outputDebugString("Статистика автомобіля: Невірний JSON")
            end
        else
            outputDebugString("Статистика автомобіля: Відсутня")
        end
        
        outputDebugString("----------------------------------------")
    end
end


-----__ (Сервер -> Клиент) __-----

---Возвращение клиента списка автомобилей
addEvent("onGetCars", true)
addEventHandler("onGetCars", root, function(player)
    local sqlQuery = "SELECT * FROM car WHERE user = '" .. getPlayerName(player) .. "'"
    local result = dbQuery(sqlLink, sqlQuery)

    if result then
        local rows = dbPoll(result, -1)

        if #rows > 0 then
            local cars = fromJSON(toJSON(rows))
            printCarInfo(cars) -- Виклик функції для виведення інформації про автомобілі
            triggerClientEvent("testCarS", root, rows)
        end
    end
end)