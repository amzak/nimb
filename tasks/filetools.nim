import strutils

proc removeDir*(dir: string; errors: var seq[string]) = 
  let dirs = listDirs(dir)

  for dir in dirs:
    try:
      removeDir(dir, errors)
      rmDir(dir)
    except: 
      errors.add("can't remove $1" % [dir])
      continue

  let files = listFiles(dir)

  for file in files:
    try:
      rmFile(file)
    except: 
      errors.add("can't remove $1" % [file])
      continue

proc makeDir*(dir: string; errors: var seq[string]) = 
  if existsDir(dir):
    return

  try:
    mkDir dir
  except:
    errors.add("can't create $1 dir" % [dir])