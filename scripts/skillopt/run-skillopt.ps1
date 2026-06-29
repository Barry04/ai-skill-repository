param(
    [Parameter(Mandatory = $true)]
    [string]$Skill,

    [string]$RepoRoot,

    [string]$BestSkillPath,

    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $RepoRoot = Join-Path $PSScriptRoot "..\.."
}
$repoRootFull = (Resolve-Path $RepoRoot).Path
$sourceSkill = Join-Path $repoRootFull "skill\$Skill\SKILL.md"
$evalDir = Join-Path $repoRootFull "eval\$Skill"

if (-not (Test-Path $sourceSkill)) {
    throw "Source skill not found: $sourceSkill"
}
if (-not (Test-Path $evalDir)) {
    throw "Eval directory not found: $evalDir"
}

$runId = Get-Date -Format "yyyyMMdd-HHmmss"
$experimentDir = Join-Path $repoRootFull "experiments\skillopt\$Skill\$runId"
$proposalDir = Join-Path $repoRootFull "proposals\$Skill"
New-Item -ItemType Directory -Path $experimentDir -Force | Out-Null
New-Item -ItemType Directory -Path $proposalDir -Force | Out-Null

$candidatePath = Join-Path $experimentDir "best_skill.md"
if ($BestSkillPath) {
    Copy-Item -LiteralPath $BestSkillPath -Destination $candidatePath -Force
} elseif ($DryRun) {
    Copy-Item -LiteralPath $sourceSkill -Destination $candidatePath -Force
} else {
    throw "SkillOpt executable integration is not configured. Pass -BestSkillPath or use -DryRun to create a proposal from the current skill."
}

$scoreOutput = Join-Path $experimentDir "score.jsonl"
& (Join-Path $PSScriptRoot "score-skill.ps1") -Skill $Skill -RepoRoot $repoRootFull -CandidatePath $candidatePath -OutputPath $scoreOutput
if (-not $?) {
    throw "Regression scoring failed for candidate: $candidatePath"
}

$candidateText = Get-Content -Raw -Encoding UTF8 $candidatePath
$scoreText = Get-Content -Raw -Encoding UTF8 $scoreOutput
$proposalPath = Join-Path $proposalDir ("{0}-skillopt.md" -f (Get-Date -Format "yyyy-MM-dd-HHmmss"))

$mode = if ($DryRun) { "dry-run/mock" } elseif ($BestSkillPath) { "external best_skill.md" } else { "skillopt" }
$candidateFence = '````'
while ($candidateText.Contains($candidateFence)) {
    $candidateFence += '`'
}
$proposalLines = @(
    "# SkillOpt Proposal: $Skill",
    "",
    "## Source Skill",
    "",
    "``skill/$Skill/SKILL.md``",
    "",
    "## SkillOpt Run",
    "",
    "- Run id: ``$runId``",
    "- Candidate: ``experiments/skillopt/$Skill/$runId/best_skill.md``",
    "- Mode: $mode",
    "",
    "## Validation Summary",
    "",
    '```jsonl',
    $scoreText.TrimEnd(),
    '```',
    "",
    "## Proposed Diff",
    "",
    "Review with:",
    "",
    '```powershell',
    "git diff --no-index -- skill/$Skill/SKILL.md experiments/skillopt/$Skill/$runId/best_skill.md",
    '```',
    "",
    "## Risk Review",
    "",
    "- Candidate must keep reusable troubleshooting rules compact.",
    "- Candidate must not store secrets, production hosts, tokens, or long logs.",
    "- Candidate must not recommend broad business-code rewrites as the first diagnostic step.",
    "",
    "## Adoption Checklist",
    "",
    "- [ ] User approved adopting this proposal.",
    "- [ ] Diff was reviewed against the source skill.",
    "- [ ] Regression score passed after adoption.",
    "- [ ] ``AGENTS.md`` was updated only if a new skill was added.",
    "",
    "## Candidate Skill",
    "",
    "${candidateFence}markdown",
    $candidateText.TrimEnd(),
    $candidateFence
)
$proposal = $proposalLines -join [Environment]::NewLine

Set-Content -Path $proposalPath -Value $proposal -Encoding UTF8
Write-Host "Proposal written: $proposalPath"
