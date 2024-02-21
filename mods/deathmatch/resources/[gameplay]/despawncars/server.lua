-- Период проверки в миллисекундах (в данном случае, каждые 10 секунд)
local checkInterval = 10000

-- Функция проверки и удаления взорванных машин
function checkAndRemoveExplodedVehicles()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElement(vehicle) and isVehicleBlown(vehicle) then
            destroyElement(vehicle)
        end
    end
end

-- Запуск функции с заданным интервалом
setTimer(checkAndRemoveExplodedVehicles, checkInterval, 0)