let count_balance_element = document.getElementById("count_balance");

mta.triggerEvent("onClientUpdate");

function prestart(){
    let btns = document.getElementsByClassName("button");
    let index = 1;
    for (let btn in btns){
        btn.addEventListener("click", function(){
            buttonclk(index);
        });
        if (index == 1){
            btn.querySelector('::after').style.content = "Зняти";
        }else if (index == 2){
            btn.querySelector('::after').style.content = "Покласти";
        }
        index+=1;
    }
}

function updatebalance(amount){
    count_balance_element.innerHTML = amount;
}


function buttonclk(numbtn){
    if(numbtn == 1){
        let amount = document.getElementById("amount").value;
        if(amount > 0){
            mta.triggerEvent("onClientWithdraw", amount);
        }
    }else if(numbtn == 2){
        let amount = document.getElementById("amount").value;
        if(amount > 0){
            mta.triggerEvent("onClientDeposit", amount);
        }
    }
}

