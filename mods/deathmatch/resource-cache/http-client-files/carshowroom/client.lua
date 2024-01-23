local browserGUI, browser, selectedVehicle, vehicle = nil
local toggle, testDrive = false


-- setDevelopmentMode(true, true)

function guiCarShowRoom(bool)
    if bool then
        local screenWidth, screenHeight = guiGetScreenSize()

        browserGUI = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        browser = guiGetBrowser(browserGUI)
        guiSetInputMode("no_binds_when_editing")
        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
            -- toggleBrowserDevTools(browser, true)
        end)
    else
        if isElement(browserGUI) then
            removeEventHandler('onClientBrowserCreated', browser, function()
                loadBrowserURL(browser, "http://mta/local/data/index.html")
            end)
            guiSetInputMode("allow_binds")
            destroyElement(browserGUI)
            browserGUI, browser = nil
        end
    end
end

function setCameraSettings(bool)
    if bool then
        setCameraMatrix(2055, 1533, 15, 2060, 1540, 11)
    else
        setCameraTarget(localPlayer)
    end
end

function toggleGui()
    toggle = not toggle 
    showCursor(toggle)
    guiCarShowRoom(toggle)
    setCameraSettings(toggle)
    destroyElement(vehicle)
end

addEvent('onClientBuyCar', true)
addEventHandler('onClientBuyCar', getRootElement(), function()
    toggleGui()
    triggerServerEvent("onBuyCar", root, localPlayer, selectedVehicle)
end)


addEvent('onClientTestDrive', true)
addEventHandler('onClientTestDrive', getRootElement(), function()
    toggleGui()
    triggerServerEvent("onTestDrive", root, localPlayer, selectedVehicle)
end)

addEvent('createVehicle', true)
addEventHandler('createVehicle', getRootElement(), function(carJSON)

    selectedVehicle = fromJSON(carJSON)

    if isElement(vehicle) then
        destroyElement(vehicle)
    end

    vehicle = createVehicle(selectedVehicle.car_id, 2063, 1541, 11, 0, 0, 120)
    setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
end)

bindKey("i", "down", toggleGui)


