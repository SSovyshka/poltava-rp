addEventHandler('onClientResourceStart', resourceRoot, function ()
    txd = engineLoadTXD('srthellcar/elegy.txd', 562)
    if txd then
        outputDebugString('TXD loaded successfully')
        engineImportTXD(txd, 562)
    else
        outputDebugString('Failed to load TXD')
    end
    
    dff = engineLoadDFF('srthellcar/elegy.dff', 562)
    if dff then
        outputDebugString('DFF loaded successfully')
        engineReplaceModel(dff, 562)
    else
        outputDebugString('Failed to load DFF')
    end
end)
