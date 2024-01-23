const colorPicker = document.getElementById('colorPicker');
const rgbValue = document.getElementById('rgbValue');

// Обработчик события изменения цвета
colorPicker.addEventListener('input', function() {
    // Получение значения цвета
    const selectedColor = colorPicker.value;

    // Преобразование hex-значения в RGB
    const rgbArray = hexToRgb(selectedColor);

    // Отображение RGB-значения
    mta.triggerEvent('debugc', rgbArray)
});

// Функция для преобразования hex в RGB
function hexToRgb(hex) {
    // Убираем решетку (#), если она есть
    hex = hex.replace(/^#/, '');

    // Разбиваем на составляющие (каждые 2 символа)
    const bigint = parseInt(hex, 16);

    // Извлекаем значения RGB
    const r = (bigint >> 16) & 255;
    const g = (bigint >> 8) & 255;
    const b = bigint & 255;

    return { r, g, b };
}