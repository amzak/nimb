import ospaths
import strutils

proc run(path:string; cmd: string; errors: var seq[string]): string =
  let utilPath = staticExec("nimb -utilpath").strip()  
  let utilCmd = utilpath / "nimbexec.exe \"$1\"" % [path / cmd]

  let resultOutput = staticExec(utilCmd)
  
  let lines = resultOutput.splitLines()
  let code = parseInt(lines[0])
  let output = lines[1..lines.len-1].join("\n")

  if code>0:
    errors.add(output)

  return output

proc run*(cmd: string; errors: var seq[string]): string =
  let scriptPath = getEnv("nimbfilePath")
  run(scriptPath, cmd, errors)

proc runAbs*(cmd: string; errors: var seq[string]): string =
  run("", cmd, errors)

proc quote*(str: string; errors: var seq[string]): string =
  return "\"$1\"" % [str]