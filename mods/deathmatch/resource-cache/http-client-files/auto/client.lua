addEventHandler('onClientResourceStart', resourceRoot, function ()
    txd = engineLoadTXD('car.txd', 411)
    if txd then
        outputDebugString('TXD loaded successfully')
        engineImportTXD(txd, 411)
    else
        outputDebugString('Failed to load TXD')
    end
    
    dff = engineLoadDFF('car.dff', 411)
    if dff then
        outputDebugString('DFF loaded successfully')
        engineReplaceModel(dff, 411)
    else
        outputDebugString('Failed to load DFF')
    end
end)
