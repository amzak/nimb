import ospaths

proc toSln*(filename: string): string =
  filename & ".sln"

proc orDefault*(param, default: string): string= 
  result = if param == "": default else: param

proc toAbsolutePath*(path: string): string =
  let scriptPath = getEnv("nimbfilePath")
  result = scriptPath / path
