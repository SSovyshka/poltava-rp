local startJobMarker = createPickup(startJobPositionMarker[1], startJobPositionMarker[2], startJobPositionMarker[3], 3,
    1239, 0)

local sqlLink = dbConnect("sqlite", -- тип базы данных 
":/works.db" -- путь к файлу БД 
)

addEventHandler('onPickupHit', startJobMarker, function(player)
    if not getPedOccupiedVehicle(player) then
        if getElementData(player, 'job:isworking') then
            if getElementData(player, 'player:work') == "farmer_1" then
                playerStartFarmerJob(player)
            elseif getElementData(player, 'player:work') == "farmer_2" then
                playerStartFarmDriverJob(player)
            end

        else
            triggerClientEvent(player, 'showFarmerGUI', root)
        end
    end

end)

addEvent("getExperienceFarmer", true)
addEventHandler("getExperienceFarmer", root, function(player)
    local sqlSelectQuery = "SELECT * FROM farmer WHERE player = '" .. getPlayerName(player) .. "'"
    local result = dbPoll(dbQuery(sqlLink, sqlSelectQuery), -1)

    local experience_1 = result[1]['experience_level_1']
    local experience_2 = result[1]['experience_level_2']
    local experience_3 = result[1]['experience_level_3']

    triggerClientEvent('setExperienceFarmer', root, experience_1, experience_2, experience_3)

end)

function insertPlayerIntoDatabase(player)
    local sqlSelectQuery = "SELECT * FROM farmer WHERE player = '" .. getPlayerName(player) .. "'"
    local result = dbPoll(dbQuery(sqlLink, sqlSelectQuery), -1)

    if #result == 0 then
        local insertQuery =
            "INSERT INTO farmer (player, experience_level_1, experience_level_2, experience_level_3) VALUES ('" ..
                getPlayerName(player) .. "', 0, 0, 0)"
        local insertResult = dbExec(sqlLink, insertQuery)
    end

end


