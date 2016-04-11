import strutils
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

    var xml = 
      """
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
      """ % [packageId, packageVersion, title, authors, description, filesXml]

    mkDir(outputDir)
    
    for part in parts:
      let nuspecDir = binariesDir / part / packageId & ".nuspec"
      writeFile(nuspecDir, xml)
      let nugetCmd = nugetExecutable & " pack \"$1\" -OutputDirectory \"$2\"" % [nuspecDir, outputDir]
      echo nugetCmd
      echo staticExec(nugetCmd)

proc add*(param: string): string= 
  result = "src=$1" % [param]

proc add*(str: string, param: string): string= 
  result = str & " src=$1" % [param]

proc exclude*(str: string, param: string): string= 
  result = str & " exclude=$1" % [param]