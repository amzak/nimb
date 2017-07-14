import ../contexts
import version

template assemblyinfoOf*(context: TaskContext; body: untyped) =   
  when not declaredInScope(outputPath):
    var outputPath {.inject.}: string
    var asmversion {.inject.}: Version
    var copyright {.inject.}: string
  proc `assemblyinfoOf Task`*() = 
    proc `assemblyinfoOf Body`() = body
    `assemblyinfoOf Body`()
    context.info.add("detected assembly version $1" % [$asmversion])
    var buffer = ""
    buffer.add("using System.Reflection;\n\c")
    buffer.add("using System.Runtime.InteropServices;\n\c")
    buffer.add("[assembly: AssemblyVersion(\"$1\")]\n\c" % [asmversion.short()])
    buffer.add("[assembly: AssemblyFileVersion(\"$1\")]\n\c" % [asmversion.short()])
    buffer.add("[assembly: AssemblyInformationalVersionAttribute(\"$1\")]\n\c" % [asmversion.shortWithDirty()])
    buffer.add("[assembly: AssemblyCopyrightAttribute(\"$1\")]\n\c" % [copyright])
    writeFile(outputPath / "SolutionVersion.cs", buffer)    
    context.info.add("file SolutionVersion.cs put in $1" % [outputPath])
