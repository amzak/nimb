import system
import strutils
import tables
import ../contexts
import ../tools/time
import ../tools/prettyreport

template getContext(name: untyped): TaskContext =  
  let taskName = astToStr(name)
  getOrAddContext(taskName)

template call*(name: untyped) =
  if not globalContext().stop:
    var taskContext = getContext(name)
    let before = getTicks()
    `name Task`()
    let delta = getTicks() - before
    taskContext.timing = delta
    taskContext.skipped = false
    if taskContext.err.len > 0:
      globalContext().stop = true

template nimbTask*(name: untyped; body: untyped): untyped =
  var taskContext = getContext(name)
  `name`(taskContext, body)

template nimbExecute*(actions: untyped): untyped =
  task build, "":
    let before = getTicks()
    actions
    let delta = getTicks() - before
    globalContext().timing = delta
    prettyReport(globalContext())