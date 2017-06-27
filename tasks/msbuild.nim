const
  msbuildExe14 = "C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe"
  msbuildExe15 = "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Professional\\MSBuild\\15.0\\Bin\\MSBuild.exe"

type
  msbuildVersion* = enum
    v14, v15 

proc msbuildExe*(version: msbuildVersion): string =
  case version:
    of v14:
      result = msbuildExe14
    of v15:
      result = msbuildExe15  

template msbuild*(body: untyped) = 
  proc `msbuild Task`*() = 
    when not declaredInScope(packageId):
      var solution {.inject.}: string

    proc `nugetpack Body`() = body
    `nugetpack Body`()

    echo runAbs msbuildExe & " \\\"$1\\\" /verbosity:quiet /nologo /target:Clean;Build /p:Configuration=Release" % [solution.toAbsolutePath]
    
