import ospaths
import strutils

proc getTicks*(): int64 =
  let utilPath = staticExec("nimb -utilpath").strip()  
  let utilCmd = utilpath / "nimbtime.exe"
  let resultOutput = staticExec(utilCmd).strip()
  let code = parseBiggestInt(resultOutput)
  return code
