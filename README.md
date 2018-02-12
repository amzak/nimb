# nimb
Ongoing attempt to make a decent, good looking build script system, based on Nim-language.

## Installation
1. Install Nim compiler
2. Checkout nimb repo
3. Execute:
```
nim c nimb.nim
nim c utils\nimbexec.nim
```
Add nimb dir to PATH

## Usage

1. Install
2. Create nimbfile.nims file in project root
3. Write some code to nims file
4. Run nimb command in project root

## Tasks

### assemblyInfo
```
nimbTask assemblyinfoOf:
  outputPath = solutionDir
  asmVersion = thisVersion
  copyright = "Copyright ©"
```
### nugetpack
```
nimbTask nugetpack:
  nugetExecutable = nugetExe
  packageId = "you_package_name"
  packageVersion = thisVersion.shortWithDirty
  title = solutionName
  binariesDir = binDir
  parts = solutionParts
  authors = "authors"
  description = "your_service_description"
  files = @[
    add "*.exe".exclude "*.vshost.exe",
    add "*.dll",
    add "*.pdb",
    add "*.config".exclude "*.vshost.exe.config"
  ]
  outputDir = artifactsDir
```
### nugetpush
```
nimbTask nugetpush:
  nugetExecutable = nugetExe
  fromDir = artifactsDir
  repoUrl = "your_repo_url"
  repoKey = "your_repo_key"
```
### nugetrestore
```
nimbTask nugetrestore:
  nugetExecutable = nugetExe
  dir = solutionDir
```
### nunitrun
```
nimbTask nunitrun:
  assembliesDir = testsDir
  packagesDir = nugetPackagesDir
```

# Example
```
mode = ScriptMode.Verbose;

import ospaths
import strutils
import buildtools
import version
import assemblyinfo
import nuget
import nunit
import filetools
import runner

const 
  solutionName = "your_project_name"
  scriptDescription = "automated build script for $1" % [solutionName]

  solutionDir = "src"
  nugetPackagesDir = "packages"
  toolsDir = "tools"
  buildsDir = "build"

  binDir = buildsDir / "bin"
  artifactsDir = buildsDir / "nuget"
  testsDir = buildsDir / "tests"

  solutionFile = solutionDir / solutionName.toSln

  buildConfigName = "Release"
  solutionParts = @["project_folder_name"]

  nugetExe = toolsDir / "nuget".toExe

  thisVersion = getVersion()

nimbTask assemblyinfoOf:
  outputPath = solutionDir
  asmVersion = thisVersion
  copyright = "Copyright ©"

nimbTask nugetpack:
  nugetExecutable = nugetExe
  packageId = "CompanyX." & solutionName
  packageVersion = thisVersion.shortWithDirty
  title = solutionName
  binariesDir = binDir
  parts = solutionParts
  authors = "CompanyX"
  description = "Some service"
  files = @[
    add "*.exe".exclude "*.vshost.exe",
    add "*.dll",
    add "*.pdb",
    add "*.config".exclude "*.vshost.exe.config"
  ]
  outputDir = artifactsDir

nimbTask nugetpush:
  nugetExecutable = nugetExe
  fromDir = artifactsDir
  repoUrl = "your_repo_url"
  repoKey = "your_repo_key"

nimbTask nugetrestore:
  nugetExecutable = nugetExe
  dir = solutionDir

nimbTask nunitrun:
  assembliesDir = testsDir
  packagesDir = nugetPackagesDir

nimbTask cleanBuildFolder:
  removeDir buildsDir
  makeDir buildsDir

nimbTask dotnetbuild:
  slnFile = solutionFile

nimbExecute:
  call nugetrestore
  call cleanBuildFolder
  call assemblyinfoOf
  call dotnetbuild
  call nunitrun
  call nugetpack
  call nugetpush
```
