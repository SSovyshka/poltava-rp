db_module = {}
db_module.db_connect = dbConnect ( 
    "sqlite",
    ":/banksystem.db"
)

--init tables
dbExec(db_module.db_connect, [[CREATE TABLE IF NOT EXISTS PlayerMoney (
                        name TEXT PRIMARY KEY,
                        money INTEGER
                        );]])
dbExec(db_module.db_connect, [[CREATE TABLE IF NOT EXISTS PositionTerminal (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        x INTEGER,
                        y INTEGER,
                        z INTEGER
                        );]])                        
function db_module.Exec(query)
    dbExec(db_module.db_connect, query)
end

function db_module.Query(query)
    queryID = dbQuery(db_module.db_connect, query)
    result, count, errors = dbPoll(queryID, -1)
    dbFree(queryID)
    return result, count
end

function db_module.is_created_by_name(name)
    res, count = db_module.Query("SELECT * FROM PlayerMoney WHERE name='"..name.."'")
    if count > 0 then
        return true
    end
    return false
end

function db_module.create_player_money(name, count_money)
    if db_module.is_created_by_name(name) ~= true then
        db_module.Exec("INSERT INTO PlayerMoney ( name, money ) VALUES ('"..name.."', "..tostring(count_money)..")")
    end
end

function db_module.get_money_by_name(name)
    res, count = db_module.Query("SELECT * FROM PlayerMoney WHERE name='"..name.."'")
    if count == 0 then
        return 0
    end
    return res[1]["money"]
end

function db_module.set_money_by_name(name, count_money)
    db_module.Exec("UPDATE PlayerMoney SET money="..tostring(count_money).." WHERE name='"..name.."'")
end

function db_module.minus_money_by_name(name, count_money)
    if db_module.is_created_by_name(name) ~= true then
        db_module.create_player_money(name, 0)
    end
    player_money = db_module.get_money_by_name(name)
    if count_money > player_money then
        return false
    end
    db_module.set_money_by_name(name, player_money-count_money)
    return true
end

function db_module.plus_money_by_name(name, count_money)
    if db_module.is_created_by_name(name) ~= true then
        db_module.create_player_money(name, count_money)
        return true
    end
    player_money = db_module.get_money_by_name(name)
    db_module.set_money_by_name(name, player_money+count_money)
    return true
end