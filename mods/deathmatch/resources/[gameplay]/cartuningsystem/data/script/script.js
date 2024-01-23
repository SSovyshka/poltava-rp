let engineButton = document.querySelector('.engine');

engineButton.addEventListener('click', function(){
    mta.triggerServerEvent('engine', true);
})