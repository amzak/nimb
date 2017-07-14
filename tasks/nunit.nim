import buildtools
import ../tools/runner
import ../contexts

template nunitrun*(context: TaskContext; body: untyped) = 
  proc `nunitrun Task`*() = 
    when not declaredInScope(outputPath):
      var assembliesDir {.inject.}: string
      var packagesDir {.inject.}: string
      var dotnetcoreProject {.inject.}: bool
      var framework {.inject.}: string

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
        if packageDir.contains("NUnit.Console"):
          result = packageDir      

    proc getNunitRunner(dir: string): string =
      let files = dir.listFiles()
      for file in files:        
        if file.contains("nunit3-console.exe"):
          return file

    let nunitPackageDir = getNunitPackageDir(packagesDir)

    let nunitRunnerExe = getNunitRunner(nunitPackageDir / "bin")

    var assembliesList = ""

    assembliesDir = assembliesDir.toAbsolutePath

    if dotnetcoreProject:
      assembliesDir = assembliesDir / framework
    
    for test in tests(assembliesDir):
      assembliesList &= test
      assembliesList &= " "

    echo assembliesList

    let nunitCmd = "$1 $2 /framework=net-4.5 /result=$3\\NUnit_report.xml /noheader -x86" % [nunitRunnerExe, assembliesList, assembliesDir]

    echo run(nunitCmd, context.err)