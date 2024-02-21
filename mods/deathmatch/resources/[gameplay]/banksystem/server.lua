-- создаем глобальную переменную для хранения ссылки на коннект 
sqlLink = dbConnect ( 
    "sqlite", -- тип базы данных 
    ":/banksystem.db" -- путь к файлу БД 
) 
dbExec(sqlLink, [[CREATE TABLE IF NOT EXISTS PlayerMoney (
                        name TEXT PRIMARY KEY,
                        money INTEGER
                        );]])
dbExec(sqlLink, [[CREATE TABLE IF NOT EXISTS PositionTerminal (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        x INTEGER,
                        y INTEGER,
                        z INTEGER
                        );]])

--mainMarker = createMarker(2034, 1550, 9, "cylinder")

function initMarkers()
    queryID = dbQuery(sqlLink, "SELECT * FROM PositionTerminal")
    res, num, tmp = dbPoll(queryID, -1)
    startIndex = 1
    if num ~= 0 then 
        for i=1, num do
            local marker = createMarker(tonumber(res[i]['x']), tonumber(res[i]['y']), tonumber(res[i]['z']), "cylinder", 1)
            setElementData(marker, "resource", getResourceName(getThisResource()))
        end
    end
end

initMarkers()

function commandAddMarker(client)
    x, y, z = getElementPosition(client)
    dbExec(sqlLink, "INSERT INTO PositionTerminal ( x, y, z ) VALUES ("..tostring(x)..", "..tostring(y)..", "..tostring(z-1)..")")
    outputChatBox("Додано мітку банкомату!", client)
end
addEvent("commandAddMarker", true)
addEventHandler("commandAddMarker", root, commandAddMarker)




--             махинации с деньгами
function checkIfCreated(client, errIfNone)
    queryID = dbQuery(sqlLink, "SELECT * FROM PlayerMoney WHERE name='"..getPlayerName(client).."'")
    res, num, tmp = dbPoll(queryID, -1)
    if num==0 then
        if not errIfNone then
            dbExec(sqlLink, "INSERT INTO PlayerMoney ( name, money ) VALUES ('"..getPlayerName(client).."', 0)")
            return 0
        else
            return -1
        end
    end
    dbFree(queryID)
    outputDebugString(toJSON(res))
    outputDebugString(tostring(num))
    return res[1]["money"]
end

function commandGetMoney(client)
    money = checkIfCreated(client)
    outputChatBox("Ваш баланс у банку  $"..tostring(money), client)
end
addEvent("getMoney", true)
addEventHandler("getMoney", root, commandGetMoney)

function commandUpdate(client)
    money = checkIfCreated(client)
    setElementData(client, "money", money)
end
addEvent("update", true)
addEventHandler("update", root, commandUpdate)


function commandGetMoneyGUI(client)
    money = checkIfCreated(client)
    triggerClientEvent("GUImoney", client, money)
end
addEvent("getMoneyGUI", true)
addEventHandler("getMoneyGUI", root, commandGetMoneyGUI)


function commandSendMoney(client, toName, amout)
    if tonumber(amout) <= 0 then
        outputChatBox("Сума переказу не повинна буди нулем або менше!", client)
        return -1
    end
    if (getPlayerFromName(toName) or false) ~= false then
        toPlayerMoney = checkIfCreated(getPlayerFromName(toName), true)
    else
        outputChatBox("Гравець зараз не на сервері!", client) 
        return -1
    end
    if toPlayerMoney == -1 then
        outputChatBox("Гравця з ніком "..toName.." немає в банковій системі!", client)
        return -1
    end
    money = checkIfCreated(client)
    if money < tonumber(amout) then
        outputChatBox("У вас недостатньо коштів!", client)
        return -1
    end
    dbExec(sqlLink, "UPDATE PlayerMoney SET money="..tostring(money-tonumber(amout)).." WHERE name='"..getPlayerName(client).."'")
    dbExec(sqlLink, "UPDATE PlayerMoney SET money="..tostring(toPlayerMoney+tonumber(amout)).." WHERE name='"..toName.."'")
    outputChatBox("Ви успішно передали $"..tostring(amout).." гравцю "..toName, client)
    outputChatBox("Вам на рахунок прийшло $"..tostring(amout).." від "..getPlayerName(client), getPlayerFromName(toName))
end
addEvent("sendMoney", true)
addEventHandler("sendMoney", root, commandSendMoney)

function commandWithdraw(client, amout)
    amout = tonumber(amout)
    if amout <= 0 then
        outputChatBox("Сума зняття не повинна буди нулем або менше!", client)
        return -1
    end    
    money = checkIfCreated(client)
    if amout > money then
        outputChatBox("У вас недостатньо коштів!", client)
        return -1
    end
    dbExec(sqlLink, "UPDATE PlayerMoney SET money="..tostring(money-amout).." WHERE name='"..getPlayerName(client).."'")
    setPlayerMoney(client, amout+getPlayerMoney(client))
    outputChatBox("Ви зняли з рахунку $"..tostring(amout), client)
end
addEvent("withdraw", true)
addEventHandler("withdraw", root, commandWithdraw)

function commandDeposit(client, amout)
    amout = tonumber(amout)
    if amout <= 0 then
        outputChatBox("Сума депозиту не повинна буди нулем або менше!", client)
        return -1
    end    
    moneyP = getPlayerMoney(client)
    if amout > moneyP then
        outputChatBox("У вас недостатньо коштів!", client)
        return -1
    end
    money = checkIfCreated(client)
    dbExec(sqlLink, "UPDATE PlayerMoney SET money="..tostring(money+amout).." WHERE name='"..getPlayerName(client).."'")
    setPlayerMoney(client, getPlayerMoney(client)-amout)
    outputChatBox("Ви поклали на рахунок $"..tostring(amout), client)
end
addEvent("deposit", true)
addEventHandler("deposit", root, commandDeposit)