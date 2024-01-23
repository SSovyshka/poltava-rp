local interfaceView = false
local dxClickable = false

local screenWidth, screenHeight = guiGetScreenSize()

local scrollY = 0;
local cars = {}
local selectedVehicle = nil
local vehicle = nil

local scaleFactor = math.min(screenWidth / 1920, screenHeight / 1080) -- Определяем масштабный коэффициент

----- ТЕСТИКИ -----

addCommandHandler("getcar", function(cmd, carIdArg)
    triggerServerEvent("onGetCar", root, localPlayer, carIdArg)
end)

----- СПИСОК МАШИН -----

table.insert(cars, {name = "Infernus", carId = 411, image = "images/Infernus.png", price = 2000, x = 0, y = 0, width = 350, height = 150})
table.insert(cars, {name = "Bullet", carId = 541, image = "images/Bullet.png", price = 23232, x = 0, y = 160, width = 350, height = 150})
table.insert(cars, {name = "Hotring Racer", carId = 494, image = "images/Hotring.png", price = 1231231, x = 0, y = 320, width = 350, height = 150})

----- АНТИДУПЛИКАТ -----

function createVehicleCarShowroom(id)
    destroyElement(vehicle)
    vehicle = createVehicle(id, 2060, 1540, 11, 0, 0, 120)
    setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
end

function setGuiSettings(state)
    showChat(not state)
    showCursor(state)
    dxClickable = state
    interfaceView = state
end

function destroyHuina()
    setCameraTarget(localPlayer)
    removeEventHandler("onClientRender", root, drawStuff)
    destroyElement(vehicle)
end

----- ИВЕНТЫ -----

addEventHandler("onClientKey", root, function(key)
    if key == "=" and interfaceView == false then
        setCameraMatrix(2055, 1533, 15, 2060, 1540, 11)
        addEventHandler("onClientRender", root, drawStuff)
        setGuiSettings(true)
    end
end)

addEventHandler("onClientKey", root, function(key, state)
    if key == "i" and interfaceView then
        destroyHuina()
        setGuiSettings(false)

        if isElement(vehicle) then
            destroyElement(vehicle)
        end

    end
end)

addEventHandler("onClientKey", root, function(button, state)
    if interfaceView then
        if button == "mouse_wheel_down" then
            if #cars * 160 then
                scrollY = scrollY + 10
                outputDebugString(scrollY)
            end
        elseif button == "mouse_wheel_up" then
            if scrollY ~= 0 then
                scrollY = scrollY - 10
                outputDebugString(scrollY)
            end
        end
    end

end)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY)
    if dxClickable then
        if isCursorShowing and button == "left" and state == "down" then
            outputDebugString(absoluteY)
            for _, car in ipairs(cars) do
                local scaledX, scaledY, scaledWidth, scaledHeight = car.x * scaleFactor, car.y * scaleFactor, car.width * scaleFactor, car.height * scaleFactor

                if absoluteX >= scaledX and absoluteX <= scaledX + scaledWidth and (absoluteY  - scrollY) >= scaledY and (absoluteY - scrollY)  <= scaledY + scaledHeight then
                    selectedVehicle = car
                    createVehicleCarShowroom(car.carId)
                    break
                end
            end

            local buyButtonX, buyButtonY, buyButtonWidth, buyButtonHeight = 1500 * scaleFactor, 1000 * scaleFactor, 150 * scaleFactor, 50 * scaleFactor

            if absoluteX >= buyButtonX and absoluteX <= buyButtonX + buyButtonWidth and (absoluteY - scrollY) >= buyButtonY and (absoluteY - scrollY) <= buyButtonY + buyButtonHeight then 
                if selectedVehicle then
                    triggerServerEvent("onPlayerRequestCarSpawn", root, localPlayer, selectedVehicle)
                    setGuiSettings(false)
                    destroyHuina()
                end
            end
        end
    end
end)

----- ПРОРИСОВКА GUI -----

function drawStuff()
    dxDrawRectangle(0, 0, 350 * scaleFactor, screenHeight, tocolor(0, 0, 0, 150))

    for _, car in ipairs(cars) do
        if car then
            local scaledX, scaledY, scaledWidth, scaledHeight = car.x * scaleFactor, car.y * scaleFactor, car.width * scaleFactor, car.height * scaleFactor

            dxDrawRectangle(scaledX, scrollY + scaledY, scaledWidth, scaledHeight, tocolor(255, 0, 0, 50))

            local imageWidth = 150 * scaleFactor
            local textX = scaledX + 10 + imageWidth
            local textY = scaledY
            local textWidth = scaledX + scaledWidth
            local textHeight = scaledY + scaledHeight

            dxDrawText(car.name, textX, scrollY + textY, textWidth, textHeight, tocolor(255, 255, 255))
            dxDrawText(car.price, textX, scrollY + textY + scaledHeight - 50, textWidth, textHeight, tocolor(255, 255, 255))
            dxDrawImage(scaledX + 10, scrollY + scaledY + (scaledHeight / 4), imageWidth, scaledHeight / 2, car.image)
        end
    end

    local buyButtonX, buyButtonY, buyButtonWidth, buyButtonHeight = 1500 * scaleFactor, 1000 * scaleFactor, 150 * scaleFactor, 50 * scaleFactor

    dxDrawRectangle(buyButtonX, buyButtonY, buyButtonWidth, buyButtonHeight, tocolor(0, 0, 0, 150))
    dxDrawText("Придбати", buyButtonX, buyButtonY, buyButtonX + buyButtonWidth, buyButtonY + buyButtonHeight, tocolor(255, 255, 255, 255))
end
