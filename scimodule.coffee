
scimodule = {name: "scimodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scimodule"]?  then console.log "[scimodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region node_modules
require('systemd')
express = require('express')
bodyParser = require('body-parser')
#endregion

############################################################
#region internalProperties
cfg = null
data = null

############################################################
app = null
#endregion

############################################################
scimodule.initialize = () ->
    log "scimodule.initialize"
    cfg = allModules.configmodule
    data = allModules.datahandlermodule

    app = express()
    app.use bodyParser.urlencoded(extended: false)
    app.use bodyParser.json()
    return

############################################################
#region internalFunctions
attachSCIFunctions = ->
    log "attachSCIFunctions"

    app.post "/getLatestOrders", onGetLatestOrders 
    app.post "/getLatestTicker", onGetLatestTicker
    app.post "/getLatestBalance", onGetLatestBalance

    return

############################################################
#region communicationHandlers
onGetLatestOrders = (req, res) ->
    log "onGetLatestOrders"
    response = {}
    try
        for pair in req.body.assetPairs
            sellStack = data.getSellStack(pair)
            buyStack = data.getBuyStack(pair)
            cancelledStack = data.getCancelledStack(pair)
            filledStack = data.getFilledStack(pair)
            if sellStack? and buyStack? and cancelledStack? and filledStack? then response[pair] = {sellStack, buyStack, cancelledStack, filledStack}
        res.send(response)
    catch err
        log "Error in onGetLatestOrders!"
        log err
        res.send(err)
    return

onGetLatestTicker = (req, res) ->
    log "onGetLatestTicker"
    response = {}
    try
        for pair in req.body.assetPairs
            response[pair] = data.getTicker(pair)
        res.send(response)
    catch err
        log "Error in onGetLatestOrders!"
        log err
        res.send(err)
    return

onGetLatestBalance = (req, res) ->
    log "onGetLatestBalance"
    response = {}
    try
        for asset in req.body.assets
            response[asset] = data.getAssetBalance(asset)
        res.send(response)
    catch err
        log "Error in onGetLatestBalance!"
        log err
        res.send(err)
    return

#endregion

#################################################################
listenForRequests = ->
    log "listenForRequests"
    if process.env.SOCKETMODE
        app.listen "systemd"
        log "listening on systemd"
    else
        port = process.env.PORT || cfg.defaultPort
        app.listen port
        log "listening on port: " + port
    return

#endregion

############################################################
#region exposedFunctions
scimodule.prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    attachSCIFunctions()
    listenForRequests()
    return
    
#endregion exposed functions

export default scimodule