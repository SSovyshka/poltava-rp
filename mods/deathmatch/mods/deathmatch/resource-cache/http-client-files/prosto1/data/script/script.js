let carContainer = document.querySelector('.car-panel');
let testDriveButton = document.querySelector('.test-drive-button');
let buyButton = document.querySelector('.buy-button');

carsList = [
    {"car_id": 562, "car_name": "Elegy", "car_image": "./images/Elegy.png", "car_price": "2000", "car_acceleration": "2" , "car_speed": "200", "car_fueltank": "50"},
    {"car_id": 494, "car_name": "Hotring", "car_image": "./images/Hotring.png", "car_price": "2500", "car_acceleration": "3", "car_speed": "220", "car_fueltank": "30"},
    {"car_id": 411, "car_name": "Infernus", "car_image": "./images/Infernus.png", "car_price": "3500", "car_acceleration": "2", "car_speed": "201", "car_fueltank": "40"},
    {"car_id": 559, "car_name": "Jester", "car_image": "./images/Jester.png", "car_price": "4500", "car_acceleration": "5", "car_speed": "190", "car_fueltank": "80"},
    {"car_id": 451, "car_name": "Turismo", "car_image": "./images/Turismo.png", "car_price": "5000", "car_acceleration": "4", "car_speed": "230", "car_fueltank": "20"},
    {"car_id": 429, "car_name": "Banshee", "car_image": "./images/Banshee.png", "car_price": "5500", "car_acceleration": "1", "car_speed": "140", "car_fueltank": "20"},
    {"car_id": 541, "car_name": "Bullet", "car_image": "./images/Bullet.png", "car_price": "6000", "car_acceleration": "6", "car_speed": "120", "car_fueltank": "40"},
    {"car_id": 434, "car_name": "Hotknife", "car_image": "./images/Hotknife.png", "car_price": "6750", "car_acceleration": "4", "car_speed": "240", "car_fueltank": "30"},
    {"car_id": 506, "car_name": "Super GT", "car_image": "./images/Supergt.png", "car_price": "7500", "car_acceleration": "3", "car_speed": "207", "car_fueltank": "20"},
    {"car_id": 558, "car_name": "Uranus", "car_image": "./images/Uranus.png", "car_price": "9500", "car_acceleration": "1", "car_speed": "203", "car_fueltank": "50"},
    {"car_id": 571, "car_name": "Admin Car", "car_image": "./images/Uranus.png", "car_price": "10000000000", "car_acceleration": "1", "car_speed": "203", "car_fueltank": "50"}
];

carsList.forEach(function (car){
    let newCar = document.createElement('div');
    newCar.className = 'car';

    let carImageCont = document.createElement('div');
    carImageCont.className = 'car-image';

    let carImage = document.createElement('img');
    carImage.src = car.car_image;
    carImageCont.appendChild(carImage);

    newCar.appendChild(carImageCont);

    let carContent = document.createElement('div');
    carContent.className = 'car-content';

    let carTitle = document.createElement('h1');
    carTitle.textContent = car.car_name;
    let carPrice = document.createElement('p');
    carPrice.textContent = `Цена: ${car.car_price}`;

    carContent.appendChild(carTitle);
    carContent.appendChild(carPrice);

    newCar.appendChild(carContent);

    carContainer.appendChild(newCar);

    newCar.addEventListener('click', function() {
        updateStats(car);
        mta.triggerEvent('createVehicle', car.car_id, car.car_price);
    });
});

function updateStats(car){
    document.querySelector('.stats').style = "display: flex;"
    document.querySelector('#car_name').textContent = `Название: ${car.car_name ? car.car_name : "N/A"}`
    document.querySelector('#car_price').textContent = `Цена: ${car.car_price ? car.car_price : "N/A"}`
    document.querySelector('#car_acceleration').textContent = `Ускорение: ${car.car_acceleration ? car.car_acceleration : "N/A"}`
    document.querySelector('#car_speed').textContent = `Макс. скорость: ${car.car_speed ? car.car_speed : "N/A"}`
    document.querySelector('#car_fueltank').textContent = `Топливный бак: ${car.car_fueltank ? car.car_fueltank : "N/A"}`
}

testDriveButton.addEventListener('click', function(){
   mta.triggerEvent('onClientTestDrive')
});

buyButton.addEventListener('click', function(){
    mta.triggerEvent('onClientBuyCar')
});
