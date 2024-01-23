sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local marker = createMarker( 2075, 1566, 11, "cylinder", 1.5)
local carInTuning = {}

local vehicle = nil

addEvent("onTuningCar", true)
addEventHandler("onTuningCar", root, function(player)
    local vehicle = getPedOccupiedVehicle(player)
    
    local handling = getVehicleHandling(vehicle)

    outputDebugString(handling["engineAcceleration"])
    outputDebugString(handling["maxVelocity"])

    outputDebugString(handling["engineAcceleration"] + (handling["engineAcceleration"] * 0.05))
    setVehicleHandling(vehicle, "engineAcceleration", handling["engineAcceleration"] + (handling["engineAcceleration"] * 0.05))
    setVehicleHandling(vehicle, "maxVelocity", handling["maxVelocity"] + (handling["maxVelocity"] * 0.05))
end)

-- addEvent("engine", true)
-- addEventHandler("engine", root, function(veh) 
--     setVehicleHandling(veh, "engineAcceleration", 100)
--     outputDebugString(toJSON(getVehicleHandling(veh, "engineAcceleration")))
-- end)