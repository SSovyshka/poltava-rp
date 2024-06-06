local sw, sh = guiGetScreenSize()
local px, py = sw / 1920, sh / 1080
local browserGUI, browser = nil
setDevelopmentMode(true, true) 


addEventHandler('onClientResourceStart', root, function()

    browserGUI = guiCreateBrowser(1920 - 400, 200, 400, 280, true, true, false)
    browser = guiGetBrowser(browserGUI)

    guiSetInputMode("no_binds_when_editing")
    addEventHandler('onClientBrowserCreated', browser, function()
        loadBrowserURL(browser, "http://mta/local/data/index.html")
    end)

end)

addEvent('showSuccessMessage', true)
addEventHandler('showSuccessMessage', root, function(message)
    local javascriptCode = string.format([[showSuccess('%s')]], message)
    executeBrowserJavascript(browser, javascriptCode)
end)

addEvent('showAlertMessage', true)
addEventHandler('showAlertMessage', root, function(message)
    local javascriptCode = string.format([[showAlert('%s')]], message)
    executeBrowserJavascript(browser, javascriptCode)
end)

addEvent('showInteraptedMessage', true)
addEventHandler('showInteraptedMessage', root, function(message)
    local javascriptCode = string.format([[showInterapted('%s')]], message)
    executeBrowserJavascript(browser, javascriptCode)
end)

-- addCommandHandler( 'sm', function ( command, message )
--     local javascriptCode = string.format([[showSuccess('%s')]], message)
--     executeBrowserJavascript(browser, javascriptCode)
-- end)
-- addCommandHandler( 'am', function ( command, message )
--     local javascriptCode = string.format([[showAlert('%s')]], message)
--     executeBrowserJavascript(browser, javascriptCode)
-- end)
-- addCommandHandler( 'im', function ( command, message )
--     local javascriptCode = string.format([[showInterapted('%s')]], message)
--     executeBrowserJavascript(browser, javascriptCode)
-- end)