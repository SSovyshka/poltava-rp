sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local carDB = {}

addEvent("onGetCar", true)
addEventHandler("onGetCar", root, function(player, carId)
    local sqlQuery = "SELECT * FROM car WHERE user = '" .. getPlayerName(player) .. "' AND car_id = " .. carId
    local result = dbQuery(sqlLink, sqlQuery)
    
    
    if result then
        local rows = dbPoll(result, -1)
        local x,y,z = getElementPosition(player)

    
        if #rows > 0 then
            
            for _, row in ipairs(rows) do 

                for numerator, DBveh in ipairs(carDB) do
                    if getPlayerName(player) == getElementData(DBveh, "owner") then
                        destroyElement(DBveh)
                        table.remove(carDB, numerator)
                    end
                end
                
                veh = createVehicle(row.car_model, x, y, z)


                triggerEvent("setVehicleHandlingByModelDB", root, veh)
                if row.car_stats ~= nil then
                    triggerEvent("setVehicleHandlingByJson", root, veh, row.car_stats)
                end

                table.insert(carDB, veh)

                setElementData(veh, "owner", getPlayerName(player))
                setElementData(veh, "carId", row.car_id)
                
                warpPedIntoVehicle(player, veh)
                
                outputDebugString(toJSON(getVehicleHandling(veh)))

            end

        end

    end

end)



