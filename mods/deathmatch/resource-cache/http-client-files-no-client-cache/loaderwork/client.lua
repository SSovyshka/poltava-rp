-- local loaderVisible = false


-- function drawStuff( player )
--     if loaderVisible then
        
--         local screenWidth, screenHeight = guiGetScreenSize()
--         local squareWidth, squareHeight = 400, 200
--         local marginX, marginY = 50, 550
--         local counter = getElementData(player, 'job:box:counter')


--         dxDrawRectangle(screenWidth - squareWidth - marginX, screenHeight - squareHeight - marginY, squareWidth, squareHeight, tocolor(0, 0, 0, 200))
--         dxDrawText("Відвантажено: ".. counter, screenWidth - squareWidth - marginX + 10, screenHeight - squareHeight - marginY + 10, screenWidth - squareWidth - marginX + 10 + squareWidth, screenHeight - squareHeight - marginY + 10 + squareHeight, tocolor(255, 255, 255), 2, "default-bold", "left", "top")
--         dxDrawText("Зароблено: ", screenWidth - squareWidth - marginX + 10, screenHeight - squareHeight - marginY + 50, screenWidth - squareWidth - marginX + 10 + squareWidth, screenHeight - squareHeight - marginY + 10 + squareHeight, tocolor(255, 255, 255), 2, "default-bold", "left", "top")
--     end
-- end
-- addEventHandler("onClientRender", root, drawStuff)

-- addEvent("showLoader", true)
-- addEventHandler("showLoader", root, function( arg )
--     loaderVisible = arg
-- end)

-- addEvent("updateLoader", true)
-- addEventHandler("updateLoader", root, drawStuff)