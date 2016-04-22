import strutils

proc removeDir*(dir: string) = 
  echo "test"
  proc removeDirSafe(dir: string) = 
    echo "removed $1" % [dir]
    let dirs = listDirs(dir)

    for dir in dirs:
      try:
        removeDirSafe(dir)
        rmDir(dir)
      except: continue

    let files = listFiles(dir)

    for file in files:
      try:
        rmFile(file)
      except: continue

  removeDirSafe(dir)

proc makeDir*(dir: string) = 
  if existsDir(dir):
    echo "dir $1 already exists" % [dir]    
    return

  try:
    mkDir dir
    echo "created dir $1" % [dir]    
  except:
    echo "can't create $1 dir" % [dir]    