-- Создаем главное окно
local screenWidth, screenHeight = guiGetScreenSize()
local browser = nil
local bro = nil

-- Функция для отображения браузера
function showBrowser()
    if isElement(browser) then
        screenWidth, screenHeight = guiGetScreenSize()
        browser = guiCreateBrowser(0, 0, 20, 20, true, true, false)
        bro = guiGetBrowser(browser)
        guiSetInputMode("no_binds_when_editing")
        guiSetVisible(bro, true)
        addEventHandler('onClientBrowserCreated', bro, function()
            loadBrowserURL(bro, "http://mta/local/data/index.html")
            -- toggleBrowserDevTools(browser, true)
        end)
    end
end

-- Функция для скрытия браузера
function hideBrowser()
    if isElement(browser) then
        guiSetVisible(bro, false)
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
end)

addEvent('onClientDeposit', true)
addEventHandler('onClientDeposit', root, function(count)
    triggerServerEvent("deposit", root, localPlayer, count)
end)

addEvent('onClientUpdate', true)
addEventHandler('onClientUpdate', root, function()
    triggerServerEvent("update", root, localPlayer)
    tmp = getElementData(localPlayer, "money")
    executeBrowserJavascript(browser, "updatebalance(" .. tmp .. ")")
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