local sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/leaderboard.db" -- путь к файлу БД 
) 

local markerPositions = {
    {-1027.27307, 1853.36475, 59.95639},
    {-864.41632, 1811.04004, 59.77836},
    {-870.30963, 1987.82385, 59.66839},
    {-603.52643, 2033.47778, 59.70575},
    {-387.00378, 2079.34790, 60.54631},
    {-478.66394, 1931.10315, 85.82182},
    {-444.72250, 1761.92163, 71.53777},
    {-415.25555, 1917.94897, 57.06921},
    {-410.07343, 1695.83301, 39.08064},
    {-401.68518, 1331.83899, 26.59405},
    {-111.51012, 1259.12500, 16.32595},
    {143.98485, 1170.50000, 15.04624},
    {192.43878, 1070.12048, 18.84986},
    {304.90695, 797.53424, 14.08217}
}

local startRaceMarker = createMarker(-1197.63367, 1790.28711, 40.77487, "cylinder", 2, 255, 0, 255, 255)
local raceCheckpoint = nil
local prl = exports['[library]poltavarp']
local currentMarkerIndex = 1

local function saveRaceResult(playerName, raceTime)
    local selectQuery = string.format("SELECT * FROM race_1 WHERE player='%s'", playerName)
    local selectResult = dbQuery(sqlLink, selectQuery)
    
    if selectResult then
        local numRows = dbPoll(selectResult, -1)
        
        if numRows and #numRows > 0 then
            local currentTimeQuery = string.format("SELECT time FROM race_1 WHERE player='%s'", playerName)
            local currentTimeResult = dbQuery(sqlLink, currentTimeQuery)
            local currentTimeRow = dbPoll(currentTimeResult, -1)
            local currentTime = tonumber(currentTimeRow[1]["time"])
            
            if raceTime <= currentTime then
                local updateQuery = string.format("UPDATE race_1 SET time=%d WHERE player='%s'", raceTime, playerName)
                local updateResult = dbExec(sqlLink, updateQuery)
                if not updateResult then
                    outputDebugString("Failed to update race result for player " .. playerName)
                end
            else
                outputDebugString("New race time is greater than the current time for player " .. playerName)
            end
        else
            local insertQuery = string.format("INSERT INTO race_1 (player, time) VALUES ('%s', %d)", playerName, raceTime)
            local insertResult = dbExec(sqlLink, insertQuery)
            if not insertResult then
                outputDebugString("Failed to save race result for player " .. playerName)
            end
        end
    else
        outputDebugString("Failed to query race result for player " .. playerName)
    end
end


local function createCheckpoint(index)
    if index <= #markerPositions then
        local pos = markerPositions[index]
        return createMarker(pos[1], pos[2], pos[3], 'checkpoint', 5, 255, 0, 0, 255)
    end
    return nil
end

local function formatTime(raceTime)
    local minutes = math.floor(raceTime / 60000)
    local seconds = math.floor((raceTime % 60000) / 1000)
    local milliseconds = raceTime % 1000
    return string.format("%02d:%02d:%03d", minutes, seconds, milliseconds)
end

local function onCheckpointHit(hitElement)
    if getElementType(hitElement) == "vehicle" then
        if raceCheckpoint then
            destroyElement(raceCheckpoint)
        end
        
        currentMarkerIndex = currentMarkerIndex + 1
        raceCheckpoint = createCheckpoint(currentMarkerIndex)
        
        if raceCheckpoint then
            addEventHandler('onMarkerHit', raceCheckpoint, onCheckpointHit)
        else
            outputChatBox("Finish")

            local raceTime = getTickCount() - startTime
            outputDebugString(formatTime(raceTime))

            saveRaceResult(getPlayerName(getVehicleOccupant( hitElement, 0 )), raceTime)

            return
        end
        
        local raceTime = getTickCount() - startTime
        outputDebugString(formatTime(raceTime))
    end
end

local function startRace(hitElement)
    local freeDimension = prl:getFreeDimension("player")
    local vehicle = getPedOccupiedVehicle(hitElement)

    setElementPosition(vehicle, -1198.40027, 1799.41687, 41.40839)
    setElementRotation(vehicle, 0, 0, -95)
    setElementFrozen(vehicle, true)

    warpPedIntoVehicle(hitElement, vehicle, 0)

    setTimer(function()
        setElementFrozen(vehicle, false)
        currentMarkerIndex = 1

        raceCheckpoint = createCheckpoint(currentMarkerIndex)
        addEventHandler('onMarkerHit', raceCheckpoint, onCheckpointHit)

        startTime = getTickCount()
    end, 3000, 1)
end

addEventHandler('onMarkerHit', startRaceMarker, startRace)
