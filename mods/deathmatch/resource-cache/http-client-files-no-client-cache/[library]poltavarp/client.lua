function drawPolyhedron(centralCoordinates, radius, sides, rotation)
    local centerX, centerY, centerZ = centralCoordinates[1], centralCoordinates[2], centralCoordinates[3] 

    local vertices = {} 

    for i = 1, sides do
        local angle = math.rad((360 / sides) * i + rotation) 
        local x = centerX + radius * math.cos(angle)
        local y = centerY + radius * math.sin(angle)
        table.insert(vertices, {x, y})
    end

    for i = 1, #vertices do
        local nextIndex = i % #vertices + 1
        dxDrawLine3D(vertices[i][1], vertices[i][2], centerZ, vertices[nextIndex][1], vertices[nextIndex][2], centerZ, tocolor(255, 255, 255))
    end
end
