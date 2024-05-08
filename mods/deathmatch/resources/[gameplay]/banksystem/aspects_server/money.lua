money_module = {}


function money_module.init()
    addEvent("onServerGetMoney", true)
    addEventHandler("onServerGetMoney", root, function(client, response_client_event)
        money = db_module.get_money_by_name(getPlayerName(client))
        triggerClientEvent(response_client_event, client, money)
    end)

    addEvent("onServerGiveMoney", true)
    addEventHandler("onServerGiveMoney", root, function(client, response_client_event, count_money)
        if count_money < 0 then
            res = db_module.minus_money_by_name(getPlayerName(client), (count_money*-1))
        else
            res = db_module.plus_money_by_name(getPlayerName(client), (count_money*-1))
        end
        triggerClientEvent(response_client_event, client, res)
    end)
end

money_module.init()