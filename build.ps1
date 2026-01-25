param(
  [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Minify-Css {
  param([string]$Content)
  $out = $Content -replace '(?s)/\*.*?\*/', ''
  $out = $out -replace '\s+', ' '
  $out = $out -replace '\s*([{};:,])\s*', '$1'
  return $out.Trim()
}

function Minify-Js {
  param([string]$Content)
  $out = $Content -replace '(?s)/\*.*?\*/', ''
  $out = $out -replace '(?m)^\s*//.*$', ''
  $out = $out -replace '\s+', ' '
  $out = $out -replace '\s*([{}();,:=<>])\s*', '$1'
  return $out.Trim()
}

$stylePath = Join-Path $Root "style.css"
$scriptPath = Join-Path $Root "script.js"
$styleMinPath = Join-Path $Root "style.min.css"
$scriptMinPath = Join-Path $Root "script.min.js"

if (Test-Path $stylePath) {
  $styleContent = Get-Content -Raw -Path $stylePath
  Minify-Css $styleContent | Set-Content -NoNewline -Path $styleMinPath
}

if (Test-Path $scriptPath) {
  $scriptContent = Get-Content -Raw -Path $scriptPath
  Minify-Js $scriptContent | Set-Content -NoNewline -Path $scriptMinPath
}

Write-Host "Minified assets updated." -ForegroundColor Green
