
local sw, sh = guiGetScreenSize()
local toggle = false
local w, h = 300, 570
local intBrowser, browserContent, renderTimer = nil

function loadBrowser() 
    loadBrowserURL(source, "http://mta/local/html/index.html")
end

function whenBrowserReady()
    
end

function renderTime(bool)
    if bool then         
        renderTimer = setTimer(
            function () 
                executeBrowserJavascript(browserContent, "updateTime();")
            end, 0, 1000
        )
    else
        if isTimer(renderTimer) then
            killTimer(renderTimer)
            renderTimer = nil
        end
    end
end

function toggleBrowser(bool)
    if bool then 
        intBrowser = guiCreateBrowser((sw - w), (sh - h) / 2, w, h, true, true, false)
        browserContent = guiGetBrowser(intBrowser)
        guiSetInputMode("no_binds_when_editing")
        addEventHandler("onClientBrowserCreated", intBrowser, loadBrowser)
        addEventHandler("onClientBrowserDocumentReady", intBrowser, whenBrowserReady)
    else 
        if isElement(intBrowser) then
            removeEventHandler("onClientBrowserCreated", intBrowser, loadBrowser)
            removeEventHandler("onClientBrowserDocumentReady", intBrowser, whenBrowserReady)
            guiSetInputMode("allow_binds")
            destroyElement(intBrowser)
            intBrowser, browserContent = nil
        end
    end
    renderTime(bool)
    collectgarbage()
end

bindKey("i","down", 
    function () 
        toggle = not toggle 
        showCursor(toggle)
        toggleBrowser(toggle)
    end
)

addEventHandler("onClientResourceStop", resourceRoot, 
    function () 
        toggleBrowser(false)
        sw, sh, w, h, toggle = nil
        collectgarbage()
    end
)