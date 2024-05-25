local screenWidth, screenHeight = guiGetScreenSize()
local tick = nil;
local activate = false;
local startTimer = false
local pausedTime = 0


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
        
        dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 150))  -- Прямоугольник с черным полупрозрачным фоном

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
