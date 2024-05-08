let buttonAccept = document.querySelector('.job-button-accept')
let buttonAllow = document.querySelector('.job-button-allow')


buttonAccept.addEventListener('click', function (){
    mta.triggerEvent('showLoaderGUITrue')
});

buttonAllow.addEventListener('click', function (){
    mta.triggerEvent('showLoaderGUIFalse')
});