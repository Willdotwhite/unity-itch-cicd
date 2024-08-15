###
### How to setup this script:
### 1: Update $ItchUsername to be your itch username
### 2: Update $ProjectName to be the name of your project - this is the name of your project on itch
### 3: Update $UnityVersion - if you don't use Unity Hub (or it's installed somewhere else), update $UnityExeLocation as well!
### 4 (optional): Scroll down to lines 109 and 128 and add/remove the platforms you want to build your project for.
###               By default, this script builds your game for Windows 64 bit and WebGL
###
### How to run this script:
### * Download (or copy paste) this file into the root of your project
### * Open PowerShell
### * Navigate to the ROOT DIRECTORY OF YOUR PROJECT (using the 'cd' command)
### * Run this script by typing `.\snapshot-build-and-publish.ps1` and hitting Enter

$ItchUsername = "username"
$ProjectName = "your-project-name"
$UnityVersion = "2022.3.37f1"
$UnityExeLocation = "C:\Program Files\Unity\Hub\Editor\$UnityVersion\Editor\Unity.exe"

##
# Build in unity
##
function UnityBuild($BuildTarget, $BuildName) {

  Write-Host "[INFO]" -ForegroundColor Green
  Write-Host "[INFO] Starting build for: $BuildTarget" -ForegroundColor Green
  Write-Host "[INFO]" -ForegroundColor Green

  & $UnityExeLocation -batchmode -quit -nographics -projectPath "$PWD" -buildName "$BuildName" -buildTarget "$BuildTarget" -executeMethod Editor.Builder.Build | Write-Output

  if ($? -eq $false) {
    Write-Host "[ERROR]" -ForegroundColor Red
    Write-Host "[ERROR] Failed $BuildName - $BuildTarget " -ForegroundColor Red
    Write-Host "[ERROR]" -ForegroundColor Red
    Push-Location $Source
    exit 1
  }

  Write-Host "[INFO]" -ForegroundColor Green
  Write-Host "[INFO] Finished build for: $BuildTarget" -ForegroundColor Green
  Write-Host "[INFO]" -ForegroundColor Green
}

##
# Publish to Itch.io
##
function ItchIoPublish($BuildTarget, $Project, $Channel) {

  Write-Host "[INFO]" -ForegroundColor Green
  Write-Host "[INFO] Publishing ${BuildTarget} to ${Project}:${Channel}" -ForegroundColor Green
  Write-Host "[INFO]" -ForegroundColor Green

  butler push ./Build/${BuildTarget} ${Project}:${Channel}

  if ($? -eq $false) {
    Write-Host "[ERROR]" -ForegroundColor Red
    Write-Host "[ERROR] Failed to publish ${BuildTarget} to ${Project}:${Channel} " -ForegroundColor Red
    Push-Location $Source
    Write-Host "[ERROR]" -ForegroundColor Red
    exit 1
  }

  Write-Host "[INFO]" -ForegroundColor Green
  Write-Host "[INFO] Published ${BuildTarget} to ${Project}:${Channel}" -ForegroundColor Green
  Write-Host "[INFO]" -ForegroundColor Green
}


# Where this script is
$Script = (Get-Item $PSScriptRoot)

# Where the project root is
$Source = $Script.Parent.FullName

# Where the snapshot project will be
$Destination = "$($Script.Parent.Parent.FullName)\.$($Script.Parent.Name)-snapshot"

# Check if the destination already exists
if(Test-Path $Destination) {

  Write-Host "[INFO]" -ForegroundColor Green
  Write-Host "[INFO] Using an existing clone..." -ForegroundColor Green
  Write-Host "[INFO]" -ForegroundColor Green

} else {

  Write-Host "[INFO]" -ForegroundColor Green
  Write-Host "[INFO] Creating new clone..." -ForegroundColor Green
  Write-Host "[INFO]" -ForegroundColor Green

  mkdir $Destination

}

# Move the working directory to be the destination project
Push-Location $Destination

Write-Host "[INFO]" -ForegroundColor Green
Write-Host "[INFO] Cloning the game state to: $PWD" -ForegroundColor Green
Write-Host "[INFO]" -ForegroundColor Green

##
# Take a snapshot of the current project and mirror it into the destination.DESCRIPTION
# Future runs of this will be quicker as it only needs to copy/update files that do not exist in the destination.
# https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
##
robocopy $Source $Destination /mir /copy:DATSO /nfl /ndl /np /xd "Temp" "Build" "Logs" "obj"

Write-Host "[INFO]" -ForegroundColor Green
Write-Host "[INFO] Building the game in: $PWD" -ForegroundColor Green
Write-Host "[INFO]" -ForegroundColor Green

# The full list of build targets can be seen here:
# https://docs.unity3d.com/ScriptReference/BuildTarget.html
# If you do Mac/Mobile/Console builds, I can't help you - you're on your own!
UnityBuild -BuildTarget WebGL -BuildName $ProjectName
UnityBuild -BuildTarget StandaloneWindows64 -BuildName $ProjectName
# UnityBuild -BuildTarget StandaloneLinux64 -BuildName $ProjectName


Write-Host "[INFO]" -ForegroundColor Green
Write-Host "[INFO] Publishing the game in: $PWD" -ForegroundColor Green
Write-Host "[INFO]" -ForegroundColor Green

# More details can be seen here:
# https://itch.io/docs/butler/pushing.html
# Same rules as UnityBuild apply - if you go off piste, I won't be able to help!
ItchIoPublish -BuildTarget WebGL -Project "$ItchUsername/$ProjectName" -Channel webgl
ItchIoPublish -BuildTarget StandaloneWindows64 -Project "$ItchUsername/$ProjectName" -Channel windows
# ItchIoPublish -BuildTarget StandaloneLinux64 -Project "$ItchUsername/$ProjectName" -Channel linux

Write-Host "[INFO]" -ForegroundColor Green
Write-Host "[INFO] Success" -ForegroundColor Green
Write-Host "[INFO]" -ForegroundColor Green

Pop-Location
