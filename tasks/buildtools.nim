const
  msbuildExe* = "C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe"

proc toSln*(filename: string): string =
  filename & ".sln"

proc orDefault*(param, default: string): string= 
  result = if param == "": default else: param
