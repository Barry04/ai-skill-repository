param(
    [string]$RepoRoot = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRootFull = (Resolve-Path $RepoRoot).Path
$sourceSkillDir = Join-Path $repoRootFull "skill"

if (-not (Test-Path $sourceSkillDir)) {
    throw "Skill directory not found: $sourceSkillDir"
}

$skillDirs = Get-ChildItem -Path $sourceSkillDir -Directory
if ($skillDirs.Count -eq 0) {
    throw "No skills found under $sourceSkillDir"
}

$homeDir = [Environment]::GetFolderPath("UserProfile")
$toolDirs = @(
    (Join-Path $homeDir ".claude\skills"),
    (Join-Path $homeDir ".cursor\skills")
)

$totalInstalled = 0
foreach ($skill in $skillDirs) {
    $skillName = $skill.Name
    foreach ($toolDir in $toolDirs) {
        $targetSkillDir = Join-Path $toolDir $skillName
        if (Test-Path $targetSkillDir) {
            Remove-Item -Path $targetSkillDir -Recurse -Force
        }
        Copy-Item -Path $skill.FullName -Destination $targetSkillDir -Recurse -Force
    }
    $totalInstalled++
    Write-Host "  installed: $skillName"
}

$agentsSource = Join-Path $repoRootFull "AGENTS.md"
if (Test-Path $agentsSource) {
    Write-Host "`nTip: AGENTS.md stays in the repo. Open this repo (or symlink it) so agents see the skill index."
}

Write-Host "`nDone. Installed $totalInstalled skill(s) to: $($toolDirs -join ', ')"
Write-Host "Source: $sourceSkillDir"
