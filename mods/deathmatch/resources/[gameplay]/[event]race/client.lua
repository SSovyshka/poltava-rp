local screenWidth, screenHeight = guiGetScreenSize()
local tick = nil;
local activate = false;
local startTimer = false
local pausedTime = 0
local toggle = false

local browserGUI, browser = nil

local leaders = {}


function guiCarRace(bool)
    if bool then
        browserGUI = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        browser = guiGetBrowser(browserGUI)
        guiSetInputMode("no_binds_when_editing")

        addEventHandler('onClientBrowserCreated', browser, function()
            loadBrowserURL(browser, "http://mta/local/data/index.html")
            toggleBrowserDevTools(browser, true)

            triggerServerEvent( "getRaceTopPlayers", root, getLocalPlayer() )
            
        end)

        addEventHandler('onClientBrowserDocumentReady', browser, function()
            local jsonLeaders = toJSON(leaders)
            local javascriptCode = string.format("insertLeaders(%s)", jsonLeaders)
            executeBrowserJavascript(browser, javascriptCode)

            local x, y, z = -1195.63367, 1800.28711, 40.77487

            dxDrawMaterialLine3D(x, y, z + 5, x, y, z + 10, browserGUI, 5, tocolor(255, 255, 255, 255))
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



addEvent("showCarRaceGUI", true)
addEventHandler("showCarRaceGUI", root, function(  )
    toggleGui() 
end)

addEvent("setLeadersTable", true)
addEventHandler("setLeadersTable", root, function( result )
    leaders = result
end)

addEvent("clientStartRace", true)
addEventHandler("clientStartRace", root, function()
    triggerServerEvent("serverStartRace", root, getLocalPlayer())
end)


function toggleGui()
    toggle = not toggle 
    showCursor(toggle)
    guiCarRace(toggle)
end



local function formatTime(raceTime)
    local minutes = math.floor(raceTime / 60000)
    local seconds = math.floor((raceTime % 60000) / 1000)
    local milliseconds = raceTime % 1000
    return string.format("%02d:%02d:%03d", minutes, seconds, milliseconds)
end

local function renderTextWithBackground( )
    if activate == true then

        local width, height = 300, 50
        local x = (screenWidth - width) / 2 
        local y = 10  
        
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150))  

        local raceTime = (startTimer == false) and pausedTime or (getTickCount() - tick)
        dxDrawText(formatTime(raceTime), x, y, x + width, y + height, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
    end
end
addEventHandler("onClientRender", root, renderTextWithBackground)

addEvent( "onClientRenderRace", true )
addEventHandler( "onClientRenderRace", root, function( bool )

    if bool then
        activate = bool
        setTimer(function()
            tick = getTickCount()
            startTimer = true
        end, 3000, 1)
    else
        startTimer = false
        pausedTime = getTickCount() - tick
        setTimer(function()
            activate = bool
        end, 6000, 1)
    end

end)
