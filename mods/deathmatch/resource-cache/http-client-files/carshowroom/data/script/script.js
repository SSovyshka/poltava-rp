let carContainer = document.querySelector('.car-panel');
let testDriveButton = document.querySelector('.test-drive-button');
let buyButton = document.querySelector('.buy-button');

carsList = [
    {"car_id": 562, "car_name": "Elegy", "car_image": "Elegy.png", "car_price": "2000", "car_acceleration": "2" , "car_speed": "236", "car_fueltank": "50"},
    {"car_id": 494, "car_name": "Hotring", "car_image": "Hotring.png", "car_price": "2500", "car_acceleration": "3", "car_speed": "214", "car_fueltank": "30"},
    {"car_id": 411, "car_name": "Infernus", "car_image": "Infernus.png", "car_price": "3500", "car_acceleration": "2", "car_speed": "359", "car_fueltank": "40"},
    {"car_id": 559, "car_name": "Jester", "car_image": "Jester.png", "car_price": "4500", "car_acceleration": "5", "car_speed": "190", "car_fueltank": "80"},
    {"car_id": 451, "car_name": "Turismo", "car_image": "Turismo.png", "car_price": "5000", "car_acceleration": "4", "car_speed": "230", "car_fueltank": "20"},
    {"car_id": 429, "car_name": "Banshee", "car_image": "Banshee.png", "car_price": "5500", "car_acceleration": "1", "car_speed": "140", "car_fueltank": "20"},
    {"car_id": 541, "car_name": "Bullet", "car_image": "Bullet.png", "car_price": "6000", "car_acceleration": "6", "car_speed": "120", "car_fueltank": "40"},
    {"car_id": 434, "car_name": "Hotknife", "car_image": "Hotknife.png", "car_price": "6750", "car_acceleration": "4", "car_speed": "240", "car_fueltank": "30"},
    {"car_id": 506, "car_name": "Super GT", "car_image": "Supergt.png", "car_price": "7500", "car_acceleration": "3", "car_speed": "207", "car_fueltank": "20"},
    {"car_id": 558, "car_name": "Uranus", "car_image": "Uranus.png", "car_price": "9500", "car_acceleration": "1", "car_speed": "203", "car_fueltank": "50"},
];

carsList.forEach(function (car){
    let newCar = document.createElement('div');
    newCar.className = 'car';


    newCar.innerHTML = `
        <div class="car">
            <div class="car-image">
                <img src="./images/${car.car_image}">
            </div>
            <div class="car-content">
                <h1>${car.car_name}</h1>
                <p>Ціна: ${car.car_price}</p>
            </div>
        </div>
    `

    carContainer.appendChild(newCar);

    newCar.addEventListener('click', function() {
        updateStats(car);
        console.log(car)
        mta.triggerEvent('createVehicle', JSON.stringify(car));
    });
});

function updateStats(car){
    document.querySelector('.stats').style = "display: flex;"
    document.querySelector('#car_name').textContent = `Назва: ${car.car_name ? car.car_name : "N/A"}`
    document.querySelector('#car_price').textContent = `Ціна: ${car.car_price ? car.car_price : "N/A"}`
    document.querySelector('#car_acceleration').textContent = `Прискорення: ${car.car_acceleration ? car.car_acceleration : "N/A"}`
    document.querySelector('#car_speed').textContent = `Макс. швидкість: ${car.car_speed ? car.car_speed : "N/A"}`
    document.querySelector('#car_fueltank').textContent = `Паливний бак: ${car.car_fueltank ? car.car_fueltank : "N/A"}`
}

testDriveButton.addEventListener('click', function(){
   mta.triggerEvent('onClientTestDrive')
});

buyButton.addEventListener('click', function(){
    mta.triggerEvent('onClientBuyCar')
});
