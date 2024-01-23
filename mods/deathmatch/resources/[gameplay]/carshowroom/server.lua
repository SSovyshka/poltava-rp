sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local drivers = {}

function generateUniqueId()
    return tostring(os.time(os.date("!*t")) * 1000 + tonumber(string.sub(tostring(os.clock()), 3, 5)))
end

function isDimFree(Type, dim)
	local state = true
	for key, value in ipairs(getElementsByType(Type)) do
		if getElementDimension(value) == dim then
			state = false
			break
		end
	end
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
	return freeDim
end

addEvent("onTestDrive", true)
addEventHandler("onTestDrive", root, function(player, selectedVehicle)
    local veh = nil
    local x,y,z = getElementPosition(player)
    local playerName = getPlayerName(player)

    if getPedOccupiedVehicle(player) == false then        

        veh = createVehicle(selectedVehicle.car_id, x, y, z)

        setElementData(veh, "driver", playerName)
        setVehicleColor(veh, 255, 255, 255)

        table.insert(drivers, veh)     
        
        triggerEvent("setVehicleHandlingByModel", root, veh)
        warpPedIntoVehicle(player,veh)

        local dimension = getFreeDimension()
        setElementDimension(player, dimension)
        setElementDimension(veh, dimension)

        addEventHandler("onVehicleExit", veh, function()
        
    
            for numerator, driver in ipairs(drivers) do
        
                if playerName == getElementData(driver, "driver") then
                    setElementPosition(player, x, y, z)
                    
                    destroyElement(driver)
                    table.remove(drivers, numerator)

                    setElementDimension(player, 0)
    
                end
        
            end
        
        end)

    end

end)


addEvent("onBuyCar", true)
addEventHandler("onBuyCar", root, function(player, selectedVehicle)
    local price = tonumber(selectedVehicle.car_price)

    if getPlayerMoney(player) >= price then

        local sqlQuery = "INSERT INTO car (user, car_id, car_model, car_name, car_image) VALUES ('" .. getPlayerName(player) .. "', " .. generateUniqueId() .. " ," .. selectedVehicle.car_id .. " ,'" .. selectedVehicle.car_name .. "' ,'" .. selectedVehicle.car_image .. "')"
        local result = dbExec(sqlLink, sqlQuery)

        if result then
            takePlayerMoney(player, selectedVehicle.car_price)
        end

    end

end)
