mode = ScriptMode.Verbose

task build, "build nimb":
  exec "nim c nimb.nim"
  exec "nim c utils\\nimbexec.nim"
  setCommand "nop"