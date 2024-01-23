local browserGUI, browser, selectedVehicle, vehicle = nil
local toggle, testDrive = false

function guiCarShowRoom(bool)
    if bool then
        browserGUI = guiCreateBrowser(0, 0, 1920, 1080, true, true, false)
        browser = guiGetBrowser(browserGUI)
        guiSetInputMode("no_binds_when_editing")
        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
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
-- addEvent('testDriveEnd', true)
-- addEventHandler('testdrive', getRootElement(), toggleGui)

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
addEventHandler('createVehicle', getRootElement(), function(carId, carPrice)

    selectedVehicle = {car_id = carId, car_price = tonumber(carPrice)}
    triggerServerEvent("debug", root, toJSON(selectedVehicle))

    if isElement(vehicle) then
        destroyElement(vehicle)
    end

    vehicle = createVehicle(carId, 2063, 1541, 11, 0, 0, 120)
    setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
end)

bindKey("i", "down", toggleGui)


