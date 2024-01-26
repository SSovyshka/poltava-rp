sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local marker = createMarker( 2075, 1566, 11, "cylinder", 1.5)
local carInTuning = {}



addEvent("onTuningCarEnter", true)
addEventHandler("onTuningCarEnter", root, function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then
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
        setElementFrozen(vehicle, false)
    end
end)


addEvent('engine', true)
addEventHandler('engine', root, function(veh)
    local handling = getVehicleHandling(veh)

    outputDebugString(handling["engineAcceleration"])
    outputDebugString(handling["maxVelocity"])

    outputDebugString(handling["engineAcceleration"] + (handling["engineAcceleration"] * 0.05))
    setVehicleHandling(veh, "engineAcceleration", handling["engineAcceleration"] + (handling["engineAcceleration"] * 0.05))
    setVehicleHandling(veh, "maxVelocity", handling["maxVelocity"] + (handling["maxVelocity"] * 0.05))
end)