function getFreeColisions( collisionTable, elementType )
    if type( collisionTable ) == "table" and type(elementType) == "string" then
        for i, collision in ipairs(collisionTable) do
            local elements = getElementsWithinColShape(collision, elementType)
            if #elements == 0 then
                return collision
            end
        end

        return nil
    end
end
