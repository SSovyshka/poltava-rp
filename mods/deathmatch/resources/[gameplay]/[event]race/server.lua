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

local prl = exports['[library]poltavarp']
local startTime = 0


local startRaceMarker = createMarker(-1197.63367, 1790.28711, 40.77487, "cylinder", 2, 255, 0, 255, 255)

addEventHandler('onMarkerHit', startRaceMarker, function(hitElement) 

    triggerClientEvent(hitElement, "showCarRaceGUI", getRootElement())
end)

local exitHandlers = {}  


local function formatTime(raceTime)
    local minutes = math.floor(raceTime / 60000)
    local seconds = math.floor((raceTime % 60000) / 1000)
    local milliseconds = raceTime % 1000
    return string.format("%02d:%02d:%03d", minutes, seconds, milliseconds)
end


function getTopRacePlayers()
    local top10Query = "SELECT player, time FROM race_1 ORDER BY time ASC LIMIT 10"
    local result = dbQuery(sqlLink, top10Query)

    if result then
        local rows = dbPoll(result, -1)
        outputDebugString(string.format("Топ 10 гравців"))
        if rows and #rows > 0 then
            for i, row in ipairs(rows) do
                outputDebugString(string.format("%d. %s - %s", i, row.player, formatTime(row.time)))
            end
            return rows
        else
            outputDebugString("Не знайдено гравців")
            return {}
        end
    else
        outputDebugString("Помилка(не вдалося з'єднатися з базою данних)")
        return {}
    end
end


addEvent("getRaceTopPlayers", true)
addEventHandler("getRaceTopPlayers", root, function( player )
    triggerClientEvent(player, "setLeadersTable", root, getTopRacePlayers())
end)


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
                    outputDebugString("Новий час було встановлено " .. playerName)
                end
            else
                outputDebugString("Час ".. playerName .." менші ніж його найкращий результат " )
            end
        else
            local insertQuery = string.format("INSERT INTO race_1 (player, time) VALUES ('%s', %d)", playerName, raceTime)
            local insertResult = dbExec(sqlLink, insertQuery)
            if not insertResult then
                outputDebugString("Помилка збереження гравця в базу даних " .. playerName)
            end
        end
    else
        outputDebugString("Помилка запиту " .. playerName)
    end
end


local function createCheckpoint(index, player)
    if index <= #markerPositions then
        local pos = markerPositions[index]
        return createMarker(pos[1], pos[2], pos[3], 'checkpoint', 5, 255, 0, 0, 255, player)
    end
    return nil
end

local function onCheckpointHit(hitElement)
    if getElementType(hitElement) == "vehicle" then
        local marker = getElementData(hitElement, "race:marker")
        if marker then
            destroyElement(marker)
        end

        setElementData(hitElement, "race:checkpoint", getElementData(hitElement, "race:checkpoint") + 1)

        local newMarker = createCheckpoint(getElementData(hitElement, "race:checkpoint"), getVehicleOccupant(hitElement))
        setElementData(hitElement, "race:marker", newMarker)

        if newMarker then
            addEventHandler('onMarkerHit', newMarker, onCheckpointHit)
        else            
            successfulCompletionRace(hitElement)
            return
        end
    end
end

function successfulCompletionRace(hitElement)
    local raceTime = getTickCount() - startTime

    removeVehicleHandlers(hitElement)

    triggerClientEvent(getVehicleOccupant(hitElement, 0), "showSuccessMessage", root, formatTime(raceTime))
    triggerClientEvent(getVehicleOccupant(hitElement, 0), "onClientRenderRace", root, false)

    saveRaceResult(getPlayerName(getVehicleOccupant(hitElement, 0)), raceTime)
end

function unsuccessfulCompletionRace(player, vehicle)

    if vehicle then
        removeVehicleHandlers(vehicle)
        local marker = getElementData(vehicle, "race:marker")
        if marker then
            destroyElement(marker)
        end
    end

    triggerClientEvent(player, "showInteraptedMessage", root, "Кінцева точка не была досягнута")
    triggerClientEvent(player, "onClientRenderRace", root, false)
end

function removeVehicleHandlers(vehicle)
    if vehicle then
        if exitHandlers[vehicle] then
            removeEventHandler("onVehicleExit", vehicle, exitHandlers[vehicle])
            exitHandlers[vehicle] = nil
        end
    end
end

function startRace(hitElement)
    local freeDimension = prl:getFreeDimension("player")
    local vehicle = getPedOccupiedVehicle(hitElement)

    setElementPosition(vehicle, -1198.40027, 1799.41687, 41.40839)
    setElementRotation(vehicle, 0, 0, -95)
    setElementFrozen(vehicle, true)

    setElementData(vehicle, "race:checkpoint", 1)

    warpPedIntoVehicle(hitElement, vehicle, 0)

    triggerClientEvent(hitElement, "onClientRenderRace", root, true)

    local exitHandler = function() unsuccessfulCompletionRace(hitElement, vehicle) end
    exitHandlers[vehicle] = exitHandler
    addEventHandler("onVehicleExit", vehicle, exitHandler)
    
    setTimer(function()
        setElementFrozen(vehicle, false)

        local marker = createCheckpoint(getElementData(vehicle, "race:checkpoint"), hitElement)
        
        setElementData(vehicle, "race:marker", marker)
        -- setElementVisibleTo(marker, hitElement, true)

        addEventHandler('onMarkerHit', marker, onCheckpointHit)

        startTime = getTickCount()
        
    end, 3000, 1)
end
addEvent("serverStartRace", true)
addEventHandler('serverStartRace', root, startRace)
