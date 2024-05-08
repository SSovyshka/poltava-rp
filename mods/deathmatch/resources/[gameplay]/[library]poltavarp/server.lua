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


function isDimFree(Type, dim)
	local state = true
	for key, value in ipairs(getElementsByType(Type)) do
		if getElementDimension(value) == dim then
			state = false
			break
		end
	end
	return state
end


function getFreeDimension( elementType )
	local freeDim = nil
	for dim = 1, 65535 do
		if isDimFree(elementType, dim) == true then
			freeDim = dim
			break
		end
	end
	return freeDim
end