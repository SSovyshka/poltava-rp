sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local marker = createMarker( 2075, 1566, 11, "cylinder", 1.5)
local carInTuning = {}

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

addEvent("onTuningCarEnter", true)
addEventHandler("onTuningCarEnter", root, function(player)
    local vehicle = getPedOccupiedVehicle(player)

    if vehicle then
        setElementDimension(player, getFreeDimension())
        setElementDimension(vehicle, getFreeDimension())
        setElementPosition(vehicle, 2026, 1343, 10.5)
        setElementRotation(vehicle, 0, 0, 210) 
        setElementFrozen(vehicle, true)
        setCameraMatrix(player, 2034, 1339, 13, 2026, 1343, 11)
        
    end
end)

addEvent("onTuningCarExit", true)
addEventHandler("onTuningCarExit", root, function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
        setElementDimension(player, 0)
        setElementDimension(vehicle, 0)
        setElementFrozen(vehicle, false)
    end
end)


addEvent('engine', true)
addEventHandler('engine', root, function(veh, player)
    -- local handling = getVehicleHandling(veh)

    local modelId = getElementModel(veh);
    local sqlQuery = "SELECT * FROM handling WHERE model = '" .. modelId .. "'"

    local result = dbPoll(dbQuery ( sqlLink, sqlQuery ), -1)
    
    local carStats = fromJSON(result[1].stats)

    outputDebugString(carStats["engineAcceleration"])
    outputDebugString(carStats["maxVelocity"])

    outputDebugString(carStats["engineAcceleration"] + (carStats["engineAcceleration"] * 0.05))
    setVehicleHandling(veh, "engineAcceleration", carStats["engineAcceleration"] + (carStats["engineAcceleration"] * 0.05))
    setVehicleHandling(veh, "maxVelocity", carStats["maxVelocity"] + (carStats["maxVelocity"] * 0.05))
    updateCarStats(veh)
end)

function updateCarStats(veh)
    local stats = getVehicleHandling(veh)
    local sqlQuery = "UPDATE car SET car_stats = '" .. string.sub(toJSON(stats), 3, -3) .. "' WHERE car_id = '" .. getElementData(veh, "carId") .. "'"
    dbExec(sqlLink, sqlQuery)
end