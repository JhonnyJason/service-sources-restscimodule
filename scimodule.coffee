
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
import handlers from "./scihandlers"
import routes from "./sciroutes"

############################################################
#region internalProperties
cfg = null
app = null
#endregion

############################################################
scimodule.initialize = () ->
    log "scimodule.initialize"
    cfg = allModules.configmodule

    app = express()
    app.use bodyParser.urlencoded(extended: false)
    app.use bodyParser.json()

    handlers.initialize()
    if handlers.authenticate? then app.use handlers.authenticate
    return

############################################################
#region internalFunctions
attachSCIFunctions = ->
    log "attachSCIFunctions"
    for route,handler of routes
        log route
        app.post "/"+route, handler
    return

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