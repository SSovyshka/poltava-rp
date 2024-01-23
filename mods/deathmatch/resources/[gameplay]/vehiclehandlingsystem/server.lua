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