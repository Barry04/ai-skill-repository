param(
    [string]$RepoRoot = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRootFull = (Resolve-Path $RepoRoot).Path
$sourceSkill = Join-Path $repoRootFull "skill\evolving-skill\SKILL.md"

if (-not (Test-Path $sourceSkill)) {
    throw "Source skill not found: $sourceSkill"
}

$homeDir = [Environment]::GetFolderPath("UserProfile")
$targets = @(
    (Join-Path $homeDir ".claude\skills\evolving-skill\SKILL.md"),
    (Join-Path $homeDir ".cursor\skills\evolving-skill\SKILL.md")
)

foreach ($target in $targets) {
    $targetDir = Split-Path -Path $target -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Copy-Item $sourceSkill $target -Force
}

$agentsSource = Join-Path $repoRootFull "AGENTS.md"
if (Test-Path $agentsSource) {
    Write-Host "Tip: AGENTS.md stays in the repo. Open this repo (or symlink it) so agents see the skill index."
}

Write-Host "Installed evolving-skill to available tool locations."
Write-Host "Source: $sourceSkill"
