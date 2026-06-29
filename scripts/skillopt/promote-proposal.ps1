param(
    [Parameter(Mandatory = $true)]
    [string]$Skill,

    [Parameter(Mandatory = $true)]
    [string]$CandidatePath,

    [string]$RepoRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $RepoRoot = Join-Path $PSScriptRoot "..\.."
}
$repoRootFull = (Resolve-Path $RepoRoot).Path
$sourceSkill = Join-Path $repoRootFull "skill\$Skill\SKILL.md"

if (-not (Test-Path $sourceSkill)) {
    throw "Source skill not found: $sourceSkill"
}
if (-not (Test-Path $CandidatePath)) {
    throw "Candidate not found: $CandidatePath"
}

Write-Host "Promotion review only. This script does not modify skill/$Skill/SKILL.md."
Write-Host ""
Write-Host "Checklist:"
Write-Host "- User approved adopting this proposal."
Write-Host "- Diff below was reviewed."
Write-Host "- Regression scoring passes after manual adoption."
Write-Host "- AGENTS.md changes are only needed for new skills."
Write-Host ""

git diff --no-index -- $sourceSkill $CandidatePath
$exitCode = $LASTEXITCODE
if ($exitCode -eq 1) {
    exit 0
}
exit $exitCode
