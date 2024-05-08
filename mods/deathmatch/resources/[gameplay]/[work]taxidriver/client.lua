local farmerVisible = false
local screenWidth, screenHeight = guiGetScreenSize()

local browserGUI, browser = nil
local browserGUI_money, browser_money = nil
local toggle = false

local prl = exports['[library]poltavarp']
local orderListClient;

setDevelopmentMode(true, true) 

function guiKPK(bool)
    if bool then
        browserGUI = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        browser = guiGetBrowser(browserGUI)
        guiSetInputMode("no_binds_when_editing")

        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
            -- toggleBrowserDevTools(browser, true)
        end)

        addEventHandler('onClientBrowserDocumentReady', browser, function()
            
            -- addEvent("addNewOrderUI", true)
            -- addEventHandler("addNewOrderUI", root, function(data)
            --     local javascriptCode = string.format([[addNewOrder(%s)]], data)
            --     executeBrowserJavascript(browser, javascriptCode)
            -- end)
            for i, data in ipairs(orderListClient) do
                outputChatBox(toJSON(data))
                local javascriptCode = string.format([[addNewOrder(%s)]], toJSON(data))
                executeBrowserJavascript(browser, javascriptCode)
            end
        end)
    else
        if isElement(browserGUI) then
            removeEventHandler('onClientBrowserCreated', browser, function()
                loadBrowserURL(browser, "http://mta/local/data/index.html")
            end)

            -- removeEventHandler('onClientBrowserDocumentReady', browser)

            guiSetInputMode("allow_binds")
            destroyElement(browserGUI)
            browserGUI, browser = nil
        end
    end
end


function pay_money_taxi()
    browserGUI_money = guiCreateBrowser(0, 0, 1920, 1080, true, true, false)
    browser_money = guiGetBrowser(browserGUI_money)

    guiSetInputMode("no_binds_when_editing")
    addEventHandler('onClientBrowserCreated', browser_money, function()
        loadBrowserURL(browser_money, "http://mta/local/data/money_pay.html")
        outputDebugString('dsadas')
    end)

    showCursor(true)

end
addEvent("openMoneyTaker", true)
addEventHandler('openMoneyTaker', root, pay_money_taxi)


function toggleGui()
    toggle = not toggle 
    showCursor(toggle)
    guiKPK(toggle)
end

addEvent("openKPK", true)
addEventHandler("openKPK", root, function(  )
    toggleGui()
end)

addEvent("setClientOrderList", true)
addEventHandler("setClientOrderList", root, function( data )
    orderListClient = data
end)

addEvent('onAcceptOrder', true)
addEventHandler('onAcceptOrder', root, function(playerName)
    triggerServerEvent("getTaxiOrder", root, playerName, getLocalPlayer())
    triggerServerEvent("deleteTaxiOrder", root, playerName)
    toggleGui()
end)



addCommandHandler("o", function()
    -- triggerClientEvent('addNewOrderUI', root, toJSON({playerName = getPlayerName(player), distance = 1000}))
    triggerServerEvent("addTaxiOrder", root, getLocalPlayer())
    -- local javascriptCode = string.format([[addNewOrder(%s)]], toJSON({playerName = getPlayerName(getLocalPlayer()), distance = 1000}))
    -- executeBrowserJavascript(browser, javascriptCode)
end)

addCommandHandler("do", function()
    triggerServerEvent("deleteTaxiOrder", root, getLocalPlayer())
end)

addCommandHandler("go", function()
    triggerServerEvent("getTaxiOrders", root)
end)

addCommandHandler("goi", function(cmd, id)
    triggerServerEvent("getTaxiOrder", root, getPlayerName(getLocalPlayer()))
end)

