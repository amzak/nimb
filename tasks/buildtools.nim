const
  msbuildExe* = "C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe"


template call*(name: untyped) = 
  `name Task`()

proc toSln*(filename: string): string =
  filename & ".sln"

