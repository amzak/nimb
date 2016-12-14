import strutils
import ospaths
import runner

template nugetpack*(body: untyped) = 
  proc `nugetpack Task`*() = 
    when not declaredInScope(packageId):
      var nugetExecutable {.inject.}: string
      var packageId {.inject.}: string
      var packageVersion {.inject.}: string
      var title {.inject.}: string
      var binariesDir {.inject.}: string
      var parts {.inject.}: seq[string]
      var prefix {.inject.}: string
      var authors {.inject.}: string
      var description {.inject.}: string
      var files {.inject.}: seq[string]
      var outputDir {.inject.}: string

    proc `nugetpack Body`() = body
    `nugetpack Body`()

    proc fillWithQuotes(str: string): string =    
      let items = str.split(' ')
      result = ""
      for item in items:
        result &= item.replace("=", "=\'")
        result &= "\' "

    var filesXml = "\n"
    for item in items(files):
      filesXml.add(spaces(12) & "<file $1 target=''/>\n" % [item.fillWithQuotes()])

    makeDir(outputDir)
    
    let xmlTemplate = """
<?xml version='1.0'?>
<package xmlns='http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd'>
  <metadata>
      <id>$1</id>
      <version>$2</version>
      <title>$3</title>
      <authors>$4</authors>
      <description>$5</description>
      <releaseNotes/>
      <copyright/>
  </metadata> 
  <files>$6
  </files>
</package>
    """

    for part in parts:
      let fullPackageId = prefix & "." & part;
      let xml = xmlTemplate % [fullPackageId, packageVersion, title, authors, description, filesXml]
      let nuspecDir = binariesDir / part / fullPackageId & ".nuspec"
      echo "creating .nuspec for $1 in $2..." % [part, nuspecDir]
      writeFile(nuspecDir, xml)
      echo "created .nuspec for $1 packing..." % [part]
      let nugetCmd = nugetExecutable & " pack \\\"$1\\\" -OutputDirectory \\\"$2\\\"" % [nuspecDir, outputDir]
      echo run nugetCmd

proc add*(param: string): string= 
  result = "src=$1" % [param]

proc add*(str: string, param: string): string= 
  result = str & " src=$1" % [param]

proc exclude*(str: string, param: string): string= 
  result = str & " exclude=$1" % [param]

template nugetpush*(body: untyped) = 
  proc `nugetpush Task`*() = 
    when not declaredInScope(packageId):
      var nugetExecutable {.inject.}: string
      var fromDir {.inject.}: string
      var repoUrl {.inject.}: string
      var repoKey {.inject.}: string

    proc `nugetpack Body`() = body
    `nugetpack Body`()

    let files = fromDir.listFiles();

    for file in files:
      var (dir, name, ext) = splitFile(file)
      if ext != ".nupkg":
        continue
      let nugetCmd = nugetExecutable & " push \\\"$1\\\" -ApiKey $2 -Source $3" % [file, repoKey, repoUrl]
      echo run nugetCmd
      echo "completed."

template nugetrestore*(body: untyped) = 
  proc `nugetrestore Task`*() = 
    when not declaredInScope(packageId):
      var nugetExecutable {.inject.}: string
      var dir {.inject.}: string

    proc `nugetpack Body`() = body
    `nugetpack Body`()

    let nugetCmd = nugetExecutable & " restore " & dir
    echo run nugetCmd
