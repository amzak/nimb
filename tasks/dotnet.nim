import ../contexts
import ../tools/runner

template dotnetbuild*(context: TaskContext; body: untyped) =
  when not declaredInScope(slnFile):
    var slnFile {.inject.}: string
  proc `dotnetbuild Task`*() = 
    proc `dotnetbuild Body`() = body
    `dotnetbuild Body`()
    var output = runAbs("dotnet restore " & slnFile.toAbsolutePath, context.err)
    context.info.add(output)
    output = runAbs("dotnet build " & slnFile.toAbsolutePath, context.err)
    context.info.add(output)

template dotnettest*(context: TaskContext; body: untyped) =
    when not declaredInScope(testsProject):
        var testsProject {.inject.}: string
    proc `dotnettest Task`*() = 
        proc `dotnettest Body`() = body
        `dotnettest Body`()
        var output = runAbs("dotnet test " & testsProject, context.err)
        context.info.add(output)

template dotnetgcfix*(context: TaskContext; body: untyped) =
    # specify server gc manually in *.config file
    when not declaredInScope(targetConfig):
        var targetConfig {.inject.}: string
    proc `dotnetgcfix Task`*() = 
        proc `dotnetgcfix Body`() = body
        `dotnetgcfix Body`()
        var config = targetConfig.readFile()
        config = config.replace("  <runtime>", "  <runtime>\r\n    <gcServer enabled=\"true\" />")
        targetConfig.writeFile(config)
        context.info.add("dotnet gc fix was written to $1" % [targetConfig])