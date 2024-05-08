local loaderVisible = false
local screenWidth, screenHeight = guiGetScreenSize()
local squareWidth, squareHeight = 400, 200        
local marginX, marginY = 50, 550

local browserGUI, browser = nil
local toggle = false


function guiCarShowRoom(bool)
    if bool then
        browserGUI = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
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

function toggleGui()
    toggle = not toggle 
    showCursor(toggle)
    guiCarShowRoom(toggle)
end

addEvent("showLoaderGUITrue", true)
addEventHandler("showLoaderGUITrue", root, function(  )
    toggleGui()
    triggerServerEvent('onPlayerStartLoaderWork', root, getLocalPlayer())
end)

addEvent("showLoaderGUIFalse", true)
addEventHandler("showLoaderGUIFalse", root, function(  )
    toggleGui() 
end)


function drawStuff( )
    if loaderVisible then
        local counter = getElementData(getLocalPlayer( ), 'job:box:counter')
        local salary = 0 
        
        if counter >= 20 and counter <= 39 then
            salary = counter * salaryMultiplier * 0.05
        elseif counter >= 40 and counter < 59 then
            salary = counter * salaryMultiplier * 0.10
        elseif counter >= 60  and counter < 99 then
            salary = counter * salaryMultiplier * 0.15
        elseif counter >= 100 then
            salary = counter * salaryMultiplier * 0.20
        end
        
        

        dxDrawRectangle(screenWidth - squareWidth - marginX, screenHeight - squareHeight - marginY, squareWidth, squareHeight, tocolor(0, 0, 0, 200))
        dxDrawText("Відвантажено: ".. counter, screenWidth - squareWidth - marginX + 10, screenHeight - squareHeight - marginY + 10, screenWidth - squareWidth - marginX + 10 + squareWidth, screenHeight - squareHeight - marginY + 10 + squareHeight, tocolor(255, 255, 255), 2, "default-bold", "left", "top")
        dxDrawText("Зароблено: " .. (counter * salaryMultiplier) + salary, screenWidth - squareWidth - marginX + 10, screenHeight - squareHeight - marginY + 50, screenWidth - squareWidth - marginX + 10 + squareWidth, screenHeight - squareHeight - marginY + 10 + squareHeight, tocolor(255, 255, 255), 2, "default-bold", "left", "top")
    end    
end
addEventHandler("onClientRender", root, drawStuff)

addEvent("showLoaderGUI", true)
addEventHandler("showLoaderGUI", root, function( arg )
    loaderVisible = arg
end)
