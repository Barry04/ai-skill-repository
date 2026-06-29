param(
    [Parameter(Mandatory = $true)]
    [string]$Skill,

    [string]$RepoRoot,

    [string]$CandidatePath,

    [string]$OutputPath,

    [switch]$AllowMissingEval
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $RepoRoot = Join-Path $PSScriptRoot "..\.."
}
$repoRootFull = (Resolve-Path $RepoRoot).Path
$skillPath = Join-Path $repoRootFull "skill\$Skill\SKILL.md"
$evalDir = Join-Path $repoRootFull "eval\$Skill"
$caseDir = Join-Path $evalDir "cases"

if (-not $CandidatePath) {
    $CandidatePath = $skillPath
}

if (-not (Test-Path $CandidatePath)) {
    throw "Candidate skill not found: $CandidatePath"
}

if (-not (Test-Path $caseDir)) {
    $message = "No eval cases found for skill '$Skill' at $caseDir"
    if ($AllowMissingEval) {
        Write-Warning $message
        exit 0
    }
    throw $message
}

$cases = Get-ChildItem -Path $caseDir -Filter "*.json" | Sort-Object Name
if ($cases.Count -eq 0) {
    $message = "No eval case JSON files found for skill '$Skill' at $caseDir"
    if ($AllowMissingEval) {
        Write-Warning $message
        exit 0
    }
    throw $message
}

$candidateText = Get-Content -Raw -Encoding UTF8 $CandidatePath
$results = @()
$totalScore = 0
$totalMax = 0
$failedForbidden = $false

foreach ($caseFile in $cases) {
    $case = Get-Content -Raw -Encoding UTF8 $caseFile.FullName | ConvertFrom-Json
    $maxScore = [int]$case.score_points
    $expected = @($case.expected)
    $forbidden = @($case.forbidden)

    $matchedExpected = @()
    $missingExpected = @()
    foreach ($phrase in $expected) {
        if ($candidateText.IndexOf([string]$phrase, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            $matchedExpected += [string]$phrase
        } else {
            $missingExpected += [string]$phrase
        }
    }

    $matchedForbidden = @()
    foreach ($phrase in $forbidden) {
        if ($candidateText.IndexOf([string]$phrase, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            $matchedForbidden += [string]$phrase
        }
    }

    $score = 0
    if ($expected.Count -gt 0) {
        $score = [Math]::Floor(($matchedExpected.Count / $expected.Count) * $maxScore)
    }
    if ($matchedForbidden.Count -gt 0) {
        $score = 0
        $failedForbidden = $true
    }

    $passed = ($missingExpected.Count -eq 0 -and $matchedForbidden.Count -eq 0)
    $notes = if ($passed) {
        "passed"
    } else {
        "missing=[$($missingExpected -join ', ')]; forbidden=[$($matchedForbidden -join ', ')]"
    }

    $result = [ordered]@{
        case_id = [string]$case.id
        score = [int]$score
        max_score = [int]$maxScore
        passed = [bool]$passed
        notes = $notes
    }
    $results += [pscustomobject]$result
    $totalScore += $score
    $totalMax += $maxScore
}

if ($OutputPath) {
    $outputFull = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
        $OutputPath
    } else {
        Join-Path $repoRootFull $OutputPath
    }
    $outputDir = Split-Path -Parent $outputFull
    if ($outputDir -and -not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    $results | ForEach-Object { $_ | ConvertTo-Json -Compress } | Set-Content -Encoding UTF8 $outputFull
}

$failedResults = @($results | Where-Object { -not $_.passed })
$summary = [ordered]@{
    skill = $Skill
    candidate = (Resolve-Path $CandidatePath).Path
    cases = $cases.Count
    score = [int]$totalScore
    max_score = [int]$totalMax
    passed = [bool]($failedResults.Count -eq 0)
}

$results | ForEach-Object { $_ | ConvertTo-Json -Compress }
Write-Host ("SUMMARY " + ($summary | ConvertTo-Json -Compress))

if (-not $summary.passed -or $failedForbidden) {
    exit 1
}
