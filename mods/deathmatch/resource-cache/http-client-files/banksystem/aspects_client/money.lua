money_module = {}

function money_module.get_money()
    local responseFromServer = nil
    local responseReceived = false

    addEvent("get_money_response", true)
    addEventHandler("get_money_response", root, function(count_money)
        outputChatBox("SEX SYKA")
        responseFromServer = count_money
        responseReceived = true
    end)

    triggerServerEvent("onServerGetMoney", root, localPlayer, "get_money_response")

    while not responseReceived do
        tmp = 0
    end
    return responseFromServer
end

function money_module.plus_or_minus_money()
    local responseFromServer = nil
    local responseReceived = false

    addEvent("plus_or_minus_money_response", true)
    addEventHandler("plus_or_minus_money_response", root, function(res)
        responseFromServer = res
        responseReceived = true
    end)

    triggerServerEvent("onServerGiveMoney", root, localPlayer, "plus_or_minus_money_response")

    local co = coroutine.create(function()
        while not responseReceived do
            coroutine.yield()
        end
    end)

    coroutine.resume(co)
    return responseFromServer
end
