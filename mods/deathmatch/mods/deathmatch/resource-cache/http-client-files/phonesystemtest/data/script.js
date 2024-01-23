let carsContainer = document.querySelector(".cars-content")

function setCarList(carsList){
    console.log(carsList)
    carsList.forEach((car) => {
        const carDiv = document.createElement('div');
        carDiv.classList.add('car');

        carDiv.innerHTML = `<span>${car.car_id}</span><br>
                            <span>${car.car_name}</span>`;

        carsContainer.appendChild(carDiv);

        carDiv.addEventListener('click', function (){
            mta.triggerEvent('onClientGetCar', car.car_id);
        })
    });
}

mta.triggerEvent('testCar');

