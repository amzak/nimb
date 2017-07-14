import ../contexts
import strutils

template cleanBuildFolder*(context: TaskContext; body: untyped) =   
  when not declaredInScope(buildFolder):
    var buildFolder {.inject.}: string
  proc `cleanBuildFolder Task`*() = 
    proc `cleanBuildFolder Body`() = body
    `cleanBuildFolder Body`()
    removeDir(buildFolder, context.warn)
    makeDir(buildFolder, context.err)
    context.info.add("cleaned folder $1" % [buildFolder])