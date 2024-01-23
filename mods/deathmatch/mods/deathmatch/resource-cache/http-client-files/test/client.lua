marker = createMarker(-713, 958, 13.390607833862, "cylinder", 2, 255, 0, 0, 255)
local browser = nil

function abrirHTML()
    browserGUI = guiCreateBrowser(0, 0, 1440, 900, true, true, false)
    browser = guiGetBrowser(browserGUI)
    addEventHandler('onClientBrowserCreated', browser, function()
        loadBrowserURL(browser, "http://mta/local/Archivos/index.html")
        showCursor(true)
    end)
end

addEventHandler('onClientMarkerHit', marker, abrirHTML)

function mensajeChat()
    outputChatBox('Estoy enviando mi primer mensaje desde HTML')
    executeBrowserJavascript(browser, 'modificarTexto()')
end
addEvent('mensajeChat', true)
addEventHandler('mensajeChat', getRootElement(), mensajeChat)
