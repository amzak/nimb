template assemblyinfoOf*(body: untyped) = 
  proc `assemblyinfoOf Task`*() = 
    when not declaredInScope(outputPath):
      var outputPath {.inject.}: string
      var asmversion {.inject.}: Version
      var copyright {.inject.}: string

    proc `assemblyinfoOf Body`() = body
    `assemblyinfoOf Body`()
    var buffer = ""
    buffer.add("using System.Reflection;\n\c")
    buffer.add("using System.Runtime.InteropServices;\n\c")
    buffer.add("[assembly: AssemblyVersion(\"$1\")]\n\c" % [asmversion.short()])
    buffer.add("[assembly: AssemblyFileVersion(\"$1\")]\n\c" % [asmversion.short()])
    buffer.add("[assembly: AssemblyInformationalVersionAttribute(\"$1\")]\n\c" % [asmversion.shortWithDirty()])
    buffer.add("[assembly: AssemblyCopyrightAttribute(\"$1\")]\n\c" % [copyright])
    writeFile(outputPath / "SolutionVersion.cs", buffer)
