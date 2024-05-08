// addNewOrder({"playerName": "biba", "distance": 23121})
// addNewOrder({"playerName": "biba2", "distance": 23121})
// addNewOrder({"playerName": "biba3", "distance": 23121})


function addNewOrder(data) {
    console.log(data)
    let tempElement = document.createElement('div');

    tempElement.innerHTML = '<div class="scroll-element">' +
                            '<h1 class="scroll-title">'+ data[0].player +'</h1>' +
                            '<h2 class="scroll-description">' + data[0].distance + ' meters</h2>' +
                            '<div class="scroll-button">Прийняти замовлення</div>' +
                        '</div>';

    let buttonElement = tempElement.querySelector('.scroll-button');
    buttonElement.addEventListener('click', function() {
        console.log(`${data[0].player}`);
        mta.triggerEvent('onAcceptOrder', data[0].player)
    });

    let scrollContainer = document.querySelector('.scroll-container');
    scrollContainer.appendChild(tempElement.firstChild);
}

