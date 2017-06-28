import strutils
import runner

type
  Version* = object
    major* : string
    minor* : string
    patch* : string
    hash* : string
    isDirty* : bool

proc `$`* (version: Version): string =
  result = "$1.$2.$3-$4" % [version.major, version.minor, version.patch, version.hash]
  if version.isDirty:
    result &= "-dirty"

proc shortWithDirty* (version: Version): string =
  result = "$1.$2.$3" % [version.major, version.minor, version.patch]
  if version.isDirty:
    result &= "-dirty"

proc short* (version: Version): string =
  result = "$1.$2.$3" % [version.major, version.minor, version.patch]

# parsing output. It looks like: v1.0-0-g69d5874d6aa1cbfd2ef5d5205162b872cccb0471-dirty
proc getVersion*(): Version = 
  let scriptPath = getEnv("nimbfilePath")
  let output = runAbs("git -C $1 describe --abbrev=64 --first-parent --long --dirty --always" % scriptPath)
  echo "git output: " & output

  let splitMajor = output.split('.')

  if splitMajor.len()>1:
    let major = splitMajor[0].strip(true, false, {'v'})
    let splitMinor = splitMajor[1].split('-')
    let minor = splitMinor[0]
    let patch = splitMinor[1]
    let hash = splitMinor[2][1..7]

    result = Version(major: major, minor: minor, patch: patch, hash: hash)
    result.isDirty = splitMinor.len() > 3
  else:
    let hash = output[1..7]    
    let splitMinor = output.split('-')
    result = Version(major: "0", minor: "0", patch: "0", hash: hash)
    result.isDirty = splitMinor.len() > 3
  echo "detected version: $1" % [$result]

