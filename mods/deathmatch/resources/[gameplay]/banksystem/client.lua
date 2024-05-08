

function commandGetMoney()
    money = money_module.get_money()
    outputChatBox(tostring(money))
end
addCommandHandler("pip", commandGetMoney)











-- Создаем главное окно
local screenWidth, screenHeight = guiGetScreenSize()
local browser = nil
local bro = nil

-- Функция для отображения браузера
function showBrowser()
    
    screenWidth, screenHeight = guiGetScreenSize()
    browser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
    bro = guiGetBrowser(browser)
    guiSetInputMode("no_binds_when_editing")
    addEventHandler('onClientBrowserCreated', bro, function()
        loadBrowserURL(bro, "http://mta/local/data/index.html")
    end)
    addEventHandler('onClientBrowserDocumentReady', bro, function()
        executeBrowserJavascript(bro, "prestart()")
    end)
end

-- Функция для скрытия браузера
function hideBrowser()
    if isElement(browser) then
        destroyElement(browser)
    end
end

local inChekPoint = false
local is_open_browser = false


-- Обработчик событий для маркеров которые были созданы в этом ресурсе
function MarkerHit ( hitPlayer, matchingDimension )
    local markerResource = getElementData(source, "resource")
    if hitPlayer == localPlayer and markerResource == "banksystem" and not isPedInVehicle(hitPlayer) then
        inChekPoint = true
    end
end
addEventHandler ( "onClientMarkerHit", root, MarkerHit )

function MarkerLeave ( hitPlayer, matchingDimension )
    local markerResource = getElementData(source, "resource")
    if hitPlayer == localPlayer and markerResource == "banksystem" then
        inChekPoint = false
    end
end
addEventHandler ( "onClientMarkerLeave", root, MarkerLeave )

function ShowGUIBankomat()
    if inChekPoint then
        if is_open_browser then
            hideBrowser()
            is_open_browser = false
            showCursor(false)
        else
            showBrowser()
            is_open_browser = true
            showCursor(true)
        end
    end
end
bindKey("lalt", "down", ShowGUIBankomat)

addEvent('onClientWithdraw', true)
addEventHandler('onClientWithdraw', root, function(count)
    triggerServerEvent("withdraw", root, localPlayer, count)
    triggerServerEvent("update", root, localPlayer)
end)

addEvent('onClientDeposit', true)
addEventHandler('onClientDeposit', root, function(count)
    triggerServerEvent("deposit", root, localPlayer, count)
    triggerServerEvent("update", root, localPlayer)
end)

addEvent('onClientUpdate', true)
addEventHandler('onClientUpdate', root, function()
    triggerServerEvent("update", root, localPlayer)
end)

addEvent('jsexecute', true)
addEventHandler('jsexecute', root, function()
    tmp = getElementData(localPlayer, "money")
    executeBrowserJavascript(bro, "updatebalance(" .. tmp .. ")")
end)


function commandGetMoney()
    triggerServerEvent("getMoney", root, localPlayer)
end
addCommandHandler("money", commandGetMoney)

function commandSendMoney(cmd, name, amout)
    triggerServerEvent("sendMoney", root, localPlayer, name, amout)
end
addCommandHandler("send", commandSendMoney)

function commandWithdraw(cmd, amout)
    triggerServerEvent("withdraw", root, localPlayer, amout)
end
addCommandHandler("withdraw", commandWithdraw)

function commandDeposit(cmd, amout)
    triggerServerEvent("deposit", root, localPlayer, amout)
end
addCommandHandler("deposit", commandDeposit)

function cammandAddMark()
    triggerServerEvent("commandAddMarker", root, localPlayer)
end
addCommandHandler("addterminal", cammandAddMark)