local function reloadWeapon()
	reloadPedWeapon(client)
end
addEvent("relWep", true)
addEventHandler("relWep", root, reloadWeapon)