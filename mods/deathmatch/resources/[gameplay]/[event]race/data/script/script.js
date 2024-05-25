var leadersContainer = document.querySelector(".leaders");

function insertLeaders(leadersList) {
    var leadersContainer = document.querySelector(".leaders");

    for (var i = 0; i < 10; i++) {

        var leaderHTML = `
            <div class="leader">
                <p style="width:40px;">${i + 1}</p>
                <p style="width:150px;">Лідер</p>
                <p>Час</p>
            </div>
        `;

        leadersContainer.innerHTML += leaderHTML;
    }
}

insertLeaders();