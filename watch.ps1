param(
  [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $Root
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$scriptBlock = {
  Start-Sleep -Milliseconds 150
  & (Join-Path $using:Root "build.ps1") | Out-Null
}

Register-ObjectEvent $watcher Changed -Action $scriptBlock | Out-Null
Register-ObjectEvent $watcher Created -Action $scriptBlock | Out-Null

Write-Host "Watching for changes in style.css and script.js..." -ForegroundColor Cyan
while ($true) { Start-Sleep -Seconds 1 }
