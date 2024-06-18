sqlLink = dbConnect(
    "sqlite", -- тип бази даних 
    ":/vehicles.db" -- шлях до файлу БД 
) 

local drivers = {}

function generateUniqueId()
    local id = tostring(os.time(os.date("!*t")) * 1000 + tonumber(string.sub(tostring(os.clock()), 3, 5)))
    outputDebugString("Згенеровано унікальний ID: " .. id)
    return id
end

function isDimFree(Type, dim)
    local state = true
    for key, value in ipairs(getElementsByType(Type)) do
        if getElementDimension(value) == dim then
            state = false
            break
        end
    end
    outputDebugString("Вимір " .. dim .. " вільний: " .. tostring(state))
    return state
end

function getFreeDimension()
    local freeDim = nil
    for dim = 1, 65535 do
        if isDimFree("player", dim) == true then
            freeDim = dim
            break
        end
    end
    outputDebugString("Знайдено вільний вимір: " .. tostring(freeDim))
    return freeDim
end

addEvent("onTestDrive", true)
addEventHandler("onTestDrive", root, function(player, selectedVehicle)
    local veh = nil
    local x, y, z = getElementPosition(player)
    local playerName = getPlayerName(player)
    outputDebugString(playerName .. " розпочав тест-драйв автомобіля ID: " .. selectedVehicle.car_id)

    if getPedOccupiedVehicle(player) == false then        
        veh = createVehicle(selectedVehicle.car_id, x, y, z)
        outputDebugString("Автомобіль створено з ID: " .. tostring(veh))

        setElementData(veh, "driver", playerName)
        setVehicleColor(veh, 255, 255, 255)
        table.insert(drivers, veh)

        triggerEvent("setVehicleHandlingByModelDB", root, veh)
        warpPedIntoVehicle(player, veh)

        local dimension = getFreeDimension()
        setElementDimension(player, dimension)
        setElementDimension(veh, dimension)
        outputDebugString("Гравця та автомобіль переміщено у вимір: " .. tostring(dimension))

        addEventHandler("onVehicleExit", veh, function()
            outputDebugString(playerName .. " вийшов з автомобіля з ID: " .. tostring(veh))

            for numerator, driver in ipairs(drivers) do
                if playerName == getElementData(driver, "driver") then
                    setElementPosition(player, x, y, z)
                    destroyElement(driver)
                    table.remove(drivers, numerator)
                    setElementDimension(player, 0)
                    outputDebugString("Автомобіль знищено, і гравець повернувся на початкову позицію.")
                end
            end
        end)
    else
        outputDebugString("Гравець вже знаходиться в автомобілі.")
    end
end)

addEvent("onBuyCar", true)
addEventHandler("onBuyCar", root, function(player, selectedVehicle)
    local price = tonumber(selectedVehicle.car_price)
    local playerName = getPlayerName(player)
    outputDebugString(playerName .. " намагається придбати автомобіль за " .. tostring(price))

    if getPlayerMoney(player) >= price then
        local sqlQuery = "INSERT INTO car (user, car_id, car_model, car_name, car_image) VALUES ('" .. playerName .. "', " .. generateUniqueId() .. " ," .. selectedVehicle.car_id .. " ,'" .. selectedVehicle.car_name .. "' ,'" .. selectedVehicle.car_image .. "')"
        local result = dbExec(sqlLink, sqlQuery)
        outputDebugString("SQL-запит виконано: " .. sqlQuery)

        if result then
            takePlayerMoney(player, selectedVehicle.car_price)
            outputDebugString("Гравець придбав автомобіль, і гроші було знято.")
        else
            outputDebugString("Не вдалося вставити автомобіль у базу даних.")
        end
    else
        outputDebugString("Гравцю не вистачає грошей для покупки автомобіля.")
    end
end)
