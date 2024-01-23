let carsContainer = document.querySelector(".cars-content");
let carApp = document.querySelector('.car-app');
let carAppC = document.querySelector('.car-app-c');
let mainButton = document.querySelector('.main-button');

function setCarList(carsList) {
    console.log(carsList);
    carsList.forEach((car) => {
        const carDiv = document.createElement('div');
        carDiv.classList.add('car');

        carDiv.innerHTML = `
            <div class="car-image-container">
                <img src="images/${car.car_image}" alt="">
            </div>
            <div class="car-content-container">
                <span>${car.car_name}</span>
            </div>
        `;

        carsContainer.appendChild(carDiv);

        carDiv.addEventListener('click', function () {
            mta.triggerEvent('onClientGetCar', car.car_id);
        });
    });
}

carAppC.addEventListener('click', function () {
    carApp.classList.remove('lock');
    carApp.classList.add('unlock');
    console.log("hui")
});

mainButton.addEventListener('click', function () {
    carApp.classList.remove('unlock');
    carApp.classList.add('lock');
});

mta.triggerEvent('testCar');

