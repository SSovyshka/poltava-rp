local marker = createMarker( 2075, 1566, 11, "cylinder", 1.5)


function guiCarShowRoom(bool)
    if bool then
        local screenWidth, screenHeight = guiGetScreenSize()

        browserGUI = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        browser = guiGetBrowser(browserGUI)
        guiSetInputMode("no_binds_when_editing")
        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
            triggerServerEvent('onTuningCarEnter', root, localPlayer)
        end)
    else
        if isElement(browserGUI) then
            removeEventHandler('onClientBrowserCreated', browser, function()
                loadBrowserURL(browser, "http://mta/local/data/index.html")
            end)
            guiSetInputMode("allow_binds")
            destroyElement(browserGUI)
            setCameraTarget(localPlayer)
            triggerServerEvent('onTuningCarExit', root, localPlayer)
            browserGUI, browser = nil
        end
    end
end

function toggleGui()
    toggle = not toggle 
    showCursor(toggle)
    guiCarShowRoom(toggle)
    setCameraSettings(toggle)
    destroyElement(vehicle)
end


bindKey("[", "down", function()
    -- local vehicle = getPedOccupiedVehicle(localPlayer)
    -- if vehicle then
        toggleGui()
    -- end
end)


addEvent('engine', true)
addEventHandler( "engine", root, function()
    
    local vehicle = getPedOccupiedVehicle(localPlayer)

    triggerServerEvent('engine', root, vehicle, localplayer)

end)