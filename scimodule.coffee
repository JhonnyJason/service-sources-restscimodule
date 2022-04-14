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
#region modules from the Environment
import * as sciBase from "thingy-sci-base"
import { routes, handlers } from "./specificinterface"
import * as service from "./service"

#endregion

############################################################
export prepareAndExpose = ->
    log "scimodule.prepareAndExpose"
    handlers.setService(service)
    sciBase.prepareAndExpose(service.authenticate, routes)
    return