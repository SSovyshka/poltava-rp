local browserGUI, browser, selectedVehicle, vehicle = nil
local toggle, testDrive = false



-----__ (Клиент -> Сервер) __-----

addEvent('onClientGetCar', true)
addEventHandler('onClientGetCar', getRootElement(), function(carId)
    triggerServerEvent("onGetCar", root, localPlayer, carId)
end)

addEvent('testCar', true)
addEventHandler('testCar', getRootElement(), function()
    triggerServerEvent("onGetCars", root, localPlayer)
end)


-----__ (Сервер -> Клиент) __-----

addEvent('testCarS', true)
addEventHandler('testCarS', getRootElement(), function(jsonArray)
    local json = toJSON(jsonArray)
    json = string.sub(json, 2, -2)  
    executeBrowserJavascript(browser, string.format([[ 
        let carList = %s;
        setCarList(carList);
    ]], json))
end)



-----__ (Интерфейс) __-----

function guiPhone(bool)
    if bool then
        browserGUI = guiCreateBrowser(1600, 500, 300, 600, true, true, false)
        browser = guiGetBrowser(browserGUI)
        -- guiSetInputMode("no_binds_when_editing")
        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
        end)
    else
        if isElement(browserGUI) then
            removeEventHandler('onClientBrowserCreated', browser, function()
                loadBrowserURL(browser, "http://mta/local/data/index.html")
            end)
            -- guiSetInputMode("allow_binds")
            destroyElement(browserGUI)
            browserGUI, browser = nil
        end
    end
end

function toggleGui()
    toggle = not toggle 
    showCursor(toggle)
    guiPhone(toggle)
    destroyElement(vehicle)
end


bindKey("]", "down", toggleGui)


