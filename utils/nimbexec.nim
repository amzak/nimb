import os
import osproc
import marshal
import strutils

var cmd = ""
let params = commandLineParams()

#echo params

if params.len() == 0:
  quit ("missing execution command", 1)

let fullCmd = params[0]

let (output, code) = execCmdEx(fullCmd)

echo code
echo output