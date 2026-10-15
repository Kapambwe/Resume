<#
.SYNOPSIS
    Build and deploy the personal profile site to GitHub Pages.

.DESCRIPTION
    Builds the site locally, stages the static output in a temporary gh-pages
    repository, and force-pushes that branch to the GitHub remote.

    Default mode is Manual because this repository is a static site with no
    separate GitHub Actions pipeline required.

.EXAMPLE
    .\deploy.ps1

.EXAMPLE
    .\deploy.ps1 -SkipBuild

.NOTES
    Prerequisites: git and access to the repository remote.
#>
param(
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$ProjectName = "PersonalProfile"
$RepoRoot    = $PSScriptRoot
$BranchName  = "gh-pages"

function Write-Step {
    param([string]$Message)
    Write-Host "`n  -> $Message" -ForegroundColor Cyan
}

function Write-OK {
    param([string]$Message)
    Write-Host "    [OK] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "    [WARN] $Message" -ForegroundColor Yellow
}

function Write-Fail {
    param([string]$Message)
    Write-Host "    [FAIL] $Message" -ForegroundColor Red
    throw $Message
}

function Get-RemoteUrl {
    $remote = git -C $RepoRoot remote get-url origin 2>$null
    if (-not $remote) {
        Write-Fail "Git remote 'origin' was not found."
    }
    return $remote.Trim()
}

function Get-PagesUrl {
    param([string]$RemoteUrl)

    $pattern = 'github\.com[:/](?<owner>[^/]+)/(?<repo>[^/.]+)(?:\.git)?$'
    $match = [regex]::Match($RemoteUrl, $pattern)
    if (-not $match.Success) {
        return $null
    }

    $owner = $match.Groups["owner"].Value
    $repo  = $match.Groups["repo"].Value
    return "https://$owner.github.io/$repo/"
}

function Invoke-Build {
    Write-Step "Building site assets..."
    & (Join-Path $RepoRoot "build.ps1")
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "build.ps1 failed"
    }
    Write-OK "Build complete"
}

function New-PublishTree {
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("$ProjectName-$([Guid]::NewGuid().ToString('N'))")
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    Write-Step "Staging static files into $tempDir ..."

    $excludeNames = @(
        ".git",
        "deploy.ps1",
        "build.ps1",
        "watch.ps1"
    )

    Get-ChildItem -LiteralPath $RepoRoot -Force | Where-Object { $excludeNames -notcontains $_.Name } | ForEach-Object {
        $destination = Join-Path $tempDir $_.Name
        if ($_.PSIsContainer) {
            Copy-Item -LiteralPath $_.FullName -Destination $destination -Recurse -Force
        } else {
            Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
        }
    }

    $noJekyll = Join-Path $tempDir ".nojekyll"
    if (-not (Test-Path $noJekyll)) {
        "" | Out-File -FilePath $noJekyll -Encoding ascii
    }

    Write-OK "Static site staged"
    return $tempDir
}

function Initialize-DeployRepo {
    param(
        [string]$PublishDir,
        [string]$RemoteUrl
    )

    $gitDir = Join-Path $PublishDir ".git"
    if (Test-Path $gitDir) {
        Remove-Item -LiteralPath $gitDir -Recurse -Force
    }

    git -C $PublishDir init -b $BranchName | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "git init failed"
    }

    git -C $PublishDir remote add origin $RemoteUrl | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "git remote add failed"
    }

    git -C $PublishDir config user.name "Codex Deploy" | Out-Null
    git -C $PublishDir config user.email "codex@localhost" | Out-Null
}

function Deploy-ToGitHubPages {
    param(
        [string]$PublishDir,
        [string]$RemoteUrl
    )

    Initialize-DeployRepo -PublishDir $PublishDir -RemoteUrl $RemoteUrl

    Write-Step "Committing static site to $BranchName ..."
    git -C $PublishDir add -A
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm UTC"
    git -C $PublishDir commit -m "deploy: $ProjectName @ $timestamp" --allow-empty --quiet
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "git commit failed"
    }

    Write-Step "Force pushing to $BranchName ..."
    git -C $PublishDir push origin $BranchName --force
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "git push failed"
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  $ProjectName  [GitHub Pages Deploy]" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

$remoteUrl = Get-RemoteUrl
$pagesUrl  = Get-PagesUrl -RemoteUrl $remoteUrl

if (-not $SkipBuild) {
    Invoke-Build
} else {
    Write-Warn "Skipping build step"
}

$publishDir = New-PublishTree
try {
    Deploy-ToGitHubPages -PublishDir $publishDir -RemoteUrl $remoteUrl
    Write-Host ""
    Write-Host "  SUCCESS: $ProjectName deployed to GitHub Pages" -ForegroundColor Green
    if ($pagesUrl) {
        Write-Host "      URL: $pagesUrl" -ForegroundColor DarkCyan
    }
    Write-Host "      Branch: $BranchName" -ForegroundColor DarkCyan
}
finally {
    if (Test-Path $publishDir) {
        Remove-Item -LiteralPath $publishDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
