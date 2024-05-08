let buttonLevel1 = document.querySelector('.farmer-level-1')
let buttonLevel2 = document.querySelector('.farmer-level-2')
let buttonAllow = document.querySelector('.job-button-allow')
updateProgressBar(0, 0, 0)

buttonLevel1.addEventListener('click', function (){
    mta.triggerEvent('startFarmerJobLevel1Client')
});

buttonLevel2.addEventListener('click', function (){
    mta.triggerEvent('startFarmerJobLevel2Client')
});

buttonAllow.addEventListener('click', function (){
    mta.triggerEvent('showFarmerGUI')
});


function updateProgressBar(experience_1, experience_2, experience_3) {

    var progressValue1 = experience_1 / 500 * 100; 
    var progressValue2 = experience_2 / 200 * 100; 
    var progressValue3 = experience_3 / 250 * 100; 

    var progressBar1 = document.getElementById("progress-bar1");
    var progressBar2 = document.getElementById("progress-bar2");
    var progressBar3 = document.getElementById("progress-bar3");    

    progressBar1.style.width = progressValue1 + "%";
    progressBar2.style.width = progressValue2 + "%";
    progressBar3.style.width = progressValue3 + "%";
}
