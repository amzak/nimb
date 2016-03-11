import os
import osproc
import strutils

var buildFile = "nimbfile.nims"
let params = commandLineParams()

if params.len() > 0:
  buildFile = params[0]

if not existsFile(buildFile):
  quit("error: nimb file not found", 1)

let imports = getAppDir() / "tasks"

let cmd = "nim --hints:off --lineDir:off --colors:on --path:$2 build $1" % [buildFile, imports]

let (output, code) = execCmdEx(cmd)

echo output