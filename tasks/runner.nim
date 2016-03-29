import ospaths
import strutils

proc run*(cmd: string): string =
  let utilPath = staticExec("nimb -utilpath").strip()
  let utilCmd = utilpath / "nimbexec.exe \"$1\"" % [cmd]
  let resultOutput = staticExec(utilCmd)
  
  let lines = resultOutput.splitLines()
  let code = parseInt(lines[0])
  let output = resultOutput

  if code>0:
    raise newException(Exception, "Command $1 execution failed with code $2 and output:\r\n $3" % [cmd, $code, output])

  return output