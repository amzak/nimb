import os
import osproc
import marshal

type
  ExecResult = object
    code: int
    output: string

var cmd = ""
let params = commandLineParams()

if params.len() == 0:
  let execResult = ExecResult(code: 1, output: "missing execution command")  
  quit ($$execResult, execResult.code)

cmd = params[0]

let (output, code) = execCmdEx(cmd)

let execResult = ExecResult(code: code, output: output)

echo $$execResult
