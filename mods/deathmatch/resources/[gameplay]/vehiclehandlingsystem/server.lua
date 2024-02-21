sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/vehicles.db" -- путь к файлу БД 
) 

local predefinedHandling = {
	[411] = {
		["mass"] = 1525,
        ["engineInertia"] = 50,
        ["engineAcceleration"] = 25,
        ["dragCoeff"] = 1.2,
        ["maxVelocity"] = 350,
        ["tractionMultiplier"] = 1.2,
        ["tractionLoss"] = 0.8,
        ["collisionDamageMultiplier"] = 0,
	},
    [541] = {
		["mass"] = 1350,
        ["engineInertia"] = 40,
        ["engineAcceleration"] = 20,
        ["dragCoeff"] = 1.0,
        ["maxVelocity"] = 300,
        ["tractionMultiplier"] = 1.5,
        ["tractionLoss"] = 1.0,
        ["collisionDamageMultiplier"] = 0,
	},
    [562] = { 
		["driveType"] = "rwd",
		["engineAcceleration"] = 200,
		["dragCoeff"] = 1.5,
		["maxVelocity"] = 300,
		["tractionMultiplier"] = 0.7,
		["tractionLoss"] = 0.8,
		["collisionDamageMultiplier"] = 0.4,
		["engineInertia"] = -175,
		["steeringLock"] = 75,
		["numberOfGears"] = 4,
		["suspensionForceLevel"] = 0.8,
		["suspensionDamping"] = 0.8,
		["suspensionUpperLimit"] = 0.33,
		["suspensionFrontRearBias"] = 0.4,
		["mass"] = 1800,
		["turnMass"] = 3000,
		["centerOfMass"] = { [1]=0, [2]=-0.2, [3]=-0.5 }
    }
}


-- addEventHandler("onVehicleEnter", root, function(player)
--     for key, value in pairs(predefinedHandling) do

--         local sqlQuery = "INSERT INTO handling (model, stats) VALUES ('" .. key .. "', '" .. string.sub(toJSON(value), 3, -3) .. "')"
--         dbExec ( sqlLink, sqlQuery )

--         outputDebugString(toJSON(key))
--         outputDebugString(toJSON(value))
--     end
-- end)

function setVehicleHandlingByModel(theVehicle) 
    local modelId = getElementModel(theVehicle);

    local sqlQuery = "SELECT * FROM handling WHERE model = '" .. modelId .. "'"

    local result = dbPoll(dbQuery ( sqlLink, sqlQuery ), -1)
    
    local carStats = fromJSON(result[1].stats)
    -- outputDebugString(carStats[1].stats)
    
    for key, value in pairs(carStats) do
        setVehicleHandling(theVehicle, key, value)
    end

end
addEvent("setVehicleHandlingByModelDB", true)
addEventHandler("setVehicleHandlingByModelDB", root, setVehicleHandlingByModel)

function setVehicleHandlingByModel(theVehicle) 
    local modelId = getElementModel(theVehicle);

    local carStats = predefinedHandling[modelId]
    
    for key, value in pairs(carStats) do
        setVehicleHandling(theVehicle, key, value)
    end

end
addEvent("setVehicleHandlingByModel", true)
addEventHandler("setVehicleHandlingByModel", root, setVehicleHandlingByModel)


function setVehicleHandlingByJson(theVehicle, json)
    local carStats = fromJSON(json)
    
    for key, value in pairs(carStats) do
        setVehicleHandling(theVehicle, key, value)
    end

end
addEvent("setVehicleHandlingByJson", true)
addEventHandler("setVehicleHandlingByJson", root, setVehicleHandlingByJson)