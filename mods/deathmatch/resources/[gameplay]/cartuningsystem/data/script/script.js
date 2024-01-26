let engineButton = document.querySelector('.engine');

engineButton.addEventListener('click', function(){
    mta.triggerEvent('engine', true);
})