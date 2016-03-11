template nunitrun*(body: untyped) = 
  proc `nunitrun Task`*() = 
    when not declaredInScope(outputPath):
      var assembliesDir {.inject.}: string
      var packagesDir {.inject.}: string

    proc `nunitrun Body`() = body
    `nunitrun Body`()

    iterator tests(dir: string): string =
        let files = dir.listFiles()
        for file in files:
          if file.contains(".Tests.dll") and not file.contains(".config"):
            yield file

    proc spaceJoin(iter: iterator (): string): string =
      echo "spaceJoin"
      result = ""
      for item in iter():
        echo item
        result &= item
        result &= " "

    proc getNunitPackageDir(dir: string): string = 
      let packagesDirs = dir.listDirs()
      for packageDir in packagesDirs:
        if packageDir.contains("NUnit.Runners"):
          result = packageDir      

    proc getNunitRunner(dir: string): string =
      let files = dir.listFiles()
      for file in files:        
        if file.contains("nunit-console-x86.exe"):
          return file


    let nunitPackageDir = getNunitPackageDir(packagesDir)

    let nunitRunnerExe = getNunitRunner(nunitPackageDir / "tools")

    var assembliesList = ""
    for test in tests(assembliesDir):
      assembliesList &= test
      assembliesList &= " "

    echo assembliesList

    let nunitCmd = "$1 $2 /framework=v4.0.30319 /xml=$3\\NUnit_report.xml /nologo /process=Single" % [nunitRunnerExe, assembliesList, assembliesDir]

    echo nunitCmd
    exec(nunitCmd)

