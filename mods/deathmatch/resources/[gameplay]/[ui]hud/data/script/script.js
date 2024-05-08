function setPlayerNicknameUI(nickname) {
    let nicknameInput = document.querySelector("#nickname"); 
    nicknameInput.innerHTML = nickname; 
}

function setPlayerHealthUI(health) {
    let healthInput = document.querySelector("#health"); 
    let healthBar = document.querySelector('.health-bar')

    healthBar.style.width = health + "%";
    healthInput.innerHTML = health; 
}

function setPlayerShieldUI(shield) {
    let shieldInput = document.querySelector("#shield"); 
    let shieldBar = document.querySelector('.shield-bar')

    shieldBar.style.width = shield + "%";
    shieldInput.innerHTML = shield; 
}

function setPlayerMoneyUI(money){
    let moneyInput = document.querySelector("#money"); 
    moneyInput.innerHTML = money; 
}

function setTimeUI(time){
    let timeInput = document.querySelector("#clock"); 
    timeInput.innerHTML = time; 
}

