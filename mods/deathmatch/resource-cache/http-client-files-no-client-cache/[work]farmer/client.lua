local farmerVisible = false
local screenWidth, screenHeight = guiGetScreenSize()
local squareWidth, squareHeight = 400, 200        
local marginX, marginY = 50, 550

local browserGUI, browser = nil
local toggle = false

local prl = exports['[library]poltavarp']

setDevelopmentMode(true, true) 

function guiCarShowRoom(bool)
    if bool then
        browserGUI = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        browser = guiGetBrowser(browserGUI)
        guiSetInputMode("no_binds_when_editing")

        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
            -- toggleBrowserDevTools(browser, true)
        end)

        addEventHandler('onClientBrowserDocumentReady', browser, function()
            triggerServerEvent('getExperienceFarmer', root, getLocalPlayer())
        end)
    else
        if isElement(browserGUI) then
            removeEventHandler('onClientBrowserCreated', browser, function()
                loadBrowserURL(browser, "http://mta/local/data/index.html")
            end)

            removeEventHandler('onClientBrowserDocumentReady', browser)

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

addEvent("setExperienceFarmer", true)
addEventHandler("setExperienceFarmer", root, function(arg1, arg2, arg3)
    local javascriptCode = string.format([[updateProgressBar(%d, %d, %d)]], arg1, arg2, arg3)
    executeBrowserJavascript(browser, javascriptCode)
end)



addEvent("startFarmerJobLevel1Client", true)
addEventHandler("startFarmerJobLevel1Client", root, function(  )
    toggleGui()
    triggerServerEvent('startFarmerJobLevel1Server', root, getLocalPlayer())
end)


addEvent("startFarmerJobLevel2Client", true)
addEventHandler("startFarmerJobLevel2Client", root, function(  )
    toggleGui()
    triggerServerEvent('startFarmerJobLevel2Server', root, getLocalPlayer())
end)

addEvent("showFarmerGUI", true)
addEventHandler("showFarmerGUI", root, function(  )
    toggleGui() 
end)


function drawStuff( )
    if farmerVisible then
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

addEvent("showFarmerJobGUI", true)
addEventHandler("showFarmerJobGUI", root, function( arg )
    farmerVisible = arg
end)


addEventHandler("onClientRender", root, function()
    prl:drawPolyhedron({-726, 970, 12-0.5}, 4, 4, 45)
    prl:drawPolyhedron({-726, 986, 12-0.37}, 4, 4, 45)
end)