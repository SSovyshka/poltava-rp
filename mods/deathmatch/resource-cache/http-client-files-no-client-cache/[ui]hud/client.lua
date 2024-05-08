local sw, sh = guiGetScreenSize()
local px, py = sw / 1920, sh / 1080
local browserGUI, browser = nil


setPlayerHudComponentVisible('armour', false)
setPlayerHudComponentVisible('health', false)
setPlayerHudComponentVisible('money', false)
setPlayerHudComponentVisible('clock', false)
setPlayerHudComponentVisible('ammo', false)
setPlayerHudComponentVisible('weapon', false)
setPlayerHudComponentVisible('breath', false)


addEventHandler('onClientResourceStart', root, function()

    browserGUI = guiCreateBrowser(1920 - 400, 0, 400, 280, true, true, false)
    browser = guiGetBrowser(browserGUI)
    guiSetInputMode("no_binds_when_editing")
    addEventHandler('onClientBrowserCreated', browser, function()
        loadBrowserURL(browser, "http://mta/local/data/index.html")
    end)

    addEventHandler('onClientBrowserDocumentReady', browser, function()
        setPlayerNicknameUI(getPlayerName(getLocalPlayer()))

        addEventHandler('onClientRender', root, function()
            setUpdatebleData(getElementHealth( getLocalPlayer( ) ), getPedArmor( getLocalPlayer() ), getPlayerMoney( getLocalPlayer() ), getRealTime( ))
        end)

    end)

end)

function setPlayerNicknameUI(nickname)
    local javascriptCode = string.format([[setPlayerNicknameUI('%s')]], nickname)
    executeBrowserJavascript(browser, javascriptCode)
end

function setUpdatebleData(health, shield, money, time)
    local formatedTime = time.hour..":"..time.minute
    local javascriptCode = string.format([[setPlayerHealthUI(%d); setPlayerShieldUI(%d); setPlayerMoneyUI(%d); setTimeUI('%s')]], health, shield, money, formatedTime)
    executeBrowserJavascript(browser, javascriptCode)
end
