const
  msbuildExe = "C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe"

template msbuild*(body: untyped) = 
  proc `msbuild Task`*() = 
    when not declaredInScope(packageId):
      var solution {.inject.}: string

    proc `nugetpack Body`() = body
    `nugetpack Body`()

    echo runAbs msbuildExe & " \\\"$1\\\" /verbosity:quiet /nologo /target:Clean;Build /p:Configuration=Release" % [solution.toAbsolutePath]
    
