import ospaths
import strutils

proc run(path:string, cmd: string): string =
  echo "executing: " & cmd
  let utilPath = staticExec("nimb -utilpath").strip()  
  let utilCmd = utilpath / "nimbexec.exe \"$1\"" % [path / cmd]

  echo "util cmd: " & utilCmd

  let resultOutput = staticExec(utilCmd)
  
  let lines = resultOutput.splitLines()
  let code = parseInt(lines[0])
  let output = lines[1]

  if code>0:
    raise newException(Exception, "Command $1 execution failed with code $2 and output:\r\n $3" % [cmd, $code, output])

  return output

proc run*(cmd: string): string =
  let scriptPath = getEnv("nimbfilePath")
  run(scriptPath, cmd)

proc runAbs*(cmd: string): string =
  run("", cmd)

proc quote*(str: string): string =
  return "\"$1\"" % [str]