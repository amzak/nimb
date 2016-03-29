import os
import osproc
import strutils

var buildFile = "nimbfile.nims"
let params = commandLineParams()

if params.len() > 0:
  if params[0] == "-utilpath":
    quit getAppDir() / "utils"
  buildFile = params[0]

if not existsFile(buildFile):
  quit("error: nimb file not found", 1)

let imports = getAppDir() / "tasks"

let cmd = "nim --hints:off --lineDir:off --colors:on --path:$1 build $2" % [imports, buildFile]

let (output, code) = execCmdEx(cmd)

echo output