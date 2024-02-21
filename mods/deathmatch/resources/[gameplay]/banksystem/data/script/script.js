let count_balance_element = document.getElementById("count_balance");
mta.triggerEvent("onClientUpdate", localPlayer);
function updatebalance(amount){
    count_balance_element.innerHTML = amount;
}


function buttonclk(numbtn){
    if(numbtn == 1){
        let amount = document.getElementById("amount").value;
        if(amount > 0){
            mta.triggerEvent("onClientWithdraw", localPlayer, amount);
            mta.triggerEvent("onClientUpdate", localPlayer);
        }
    }else if(numbtn == 2){
        let amount = document.getElementById("amount").value;
        if(amount > 0){
            mta.triggerEvent("onClientDeposit", localPlayer, amount);
            mta.triggerEvent("onClientUpdate", localPlayer);
        }
    }
}