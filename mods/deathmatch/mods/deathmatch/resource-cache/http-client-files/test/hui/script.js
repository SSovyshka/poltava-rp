const getAll = (element) => { return document.querySelectorAll(element) }

const apps = getAll('.car-container')

function foo(){
    mta.triggerEvent("testhui", app.textContent.trim())
}

apps.forEach((app, key) => app.onclick = (e) => foo());