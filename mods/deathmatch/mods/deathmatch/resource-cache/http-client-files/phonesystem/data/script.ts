let cars = document.querySelector('#cars');


cars.addEventListener('click', function (){
    mta.triggerEvent('onClientGetCar', "1705366095571");
})