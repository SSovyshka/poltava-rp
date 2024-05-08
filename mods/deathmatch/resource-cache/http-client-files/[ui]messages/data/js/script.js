function showAlert(messageText){
    let messageList = document.querySelector('.message-list');
    let message = document.createElement('div')
    message.innerHTML = `<div class="message alert"><img src="img/alert.svg" alt=""><p>${messageText}</p></div>`

    messageList.appendChild(message)


    setTimeout(function() {
        messageList.removeChild(message);
    }, 5000);


}

function showInterapted(messageText){
    let messageList = document.querySelector('.message-list');
    let message = document.createElement('div')
    message.innerHTML = `<div class="message interapted"><img src="img/interapted.svg" alt=""><p>${messageText}</p></div>`

    messageList.appendChild(message)


    setTimeout(function() {
        messageList.removeChild(message);
    }, 5000);


}

function showSuccess(messageText){
    let messageList = document.querySelector('.message-list');
    let message = document.createElement('div')
    message.innerHTML = `<div class="message success"><img src="img/check.svg" alt=""><p>${messageText}</p></div>`

    messageList.appendChild(message)


    setTimeout(function() {
        messageList.removeChild(message);
    }, 5000);

}