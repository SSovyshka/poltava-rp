var leadersContainer = document.querySelector(".leaders");

let buttonAllow = document.querySelector('.job-button-accept')

buttonAllow.addEventListener('click', function (){
    mta.triggerEvent('clientStartRace')
    mta.triggerEvent('showCarRaceGUI')
});

let buttonAllow2 = document.querySelector('.job-button-allow')
buttonAllow2.addEventListener('click', function (){
    mta.triggerEvent('showCarRaceGUI')
});


function insertLeaders(leadersList) {
    var leadersContainer = document.querySelector(".leaders");
    leadersContainer.innerHTML = "";  

    console.log(leadersList);  
    leadersList = leadersList[0];

    
    for (var i = 0; i < leadersList.length; i++) {
        var leader = leadersList[i];
        var leaderHTML = `
            <div class="leader">
                <p style="width:40px;">${i + 1}</p>
                <p style="width:150px;">${leader.player}</p>
                <p>${formatTime(leader.time)}</p>
            </div>
        `;
        leadersContainer.innerHTML += leaderHTML;
    }
}

function formatTime(time) {
    var minutes = Math.floor(time / 60000);
    var seconds = Math.floor((time % 60000) / 1000);
    var milliseconds = time % 1000;
    return `${minutes}:${seconds < 10 ? '0' : ''}${seconds}:${milliseconds}`;
}


