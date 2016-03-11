import strutils

type
  Version* = object
    major* : string
    minor* : string
    patch* : string
    hash* : string
    isDirty* : bool

# parsing output. It looks like: v1.0-0-g69d5874d6aa1cbfd2ef5d5205162b872cccb0471-dirty
proc getVersion*(): Version = 
  let output = staticExec("git describe --abbrev=64 --first-parent --long --dirty --always")

  let splitMajor = output.split('.')
  let major = splitMajor[0].strip(true, false, {'v'})
  let splitMinor = splitMajor[1].split('-')
  let minor = splitMinor[0]
  let patch = splitMinor[1]
  let hash = splitMinor[2][1..7]

  result = Version(major: major, minor: minor, patch: patch, hash: hash)
  result.isDirty = splitMinor.len() > 3

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