-- Создаем главное окно
local screenWidth, screenHeight = guiGetScreenSize()
local main_window = guiCreateWindow((screenWidth - 300) / 2, (screenHeight - 150) / 2, 300, 150, "Банковское окно", false)
guiSetVisible(main_window, false)

-- Создаем кнопки
local withdraw_button = guiCreateButton(20, 30, 100, 30, "Снять деньги", false, main_window)
local deposit_button = guiCreateButton(130, 30, 100, 30, "Положить", false, main_window)
local exit_button = guiCreateButton(240, 30, 50, 30, "Выход", false, main_window)
local editBox = guiCreateEdit( 20, 100, 100, 30, "", false, main_window )
guiEditSetMaxLength ( editBox, 128 )

-- Обработчик событий для кнопок
addEventHandler("onClientGUIClick", withdraw_button, function()
    local amount = tonumber(guiGetText(editBox))
    if amount then
        triggerServerEvent("withdraw", root, localPlayer, amount)
    end
end, false)

addEventHandler("onClientGUIClick", deposit_button, function()
    local amount = tonumber(guiGetText(editBox))
    if amount then
        triggerServerEvent("deposit", root, localPlayer, amount)
    end
end, false)

addEventHandler("onClientGUIClick", exit_button, function()
    guiSetVisible(main_window, false)
    showCursor(false)
end, false)

local inChekPoint = false

-- function MarkerHit ( hitPlayer, matchingDimension )
--     if hitPlayer == localPlayer  and not getPedOccupiedVehicle(localPlayer) then
--         inChekPoint = true
--     end
-- end
-- addEventHandler ( "onClientMarkerHit", getRootElement(), MarkerHit )

function MarkerLeave ( hitPlayer, matchingDimension )
    if hitPlayer == localPlayer then
        inChekPoint = false
    end
end
addEventHandler ( "onClientMarkerLeave", getRootElement(), MarkerLeave )

function ShowGUIBankomat()
    if inChekPoint then
        guiSetVisible(main_window, true)
        showCursor(true)
    end
end
bindKey("lalt", "down", ShowGUIBankomat)

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