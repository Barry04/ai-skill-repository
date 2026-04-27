param(
    [string]$RepoRoot = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-ProjectSkillFile {
    param([string]$Root)

    $mainFile = Join-Path $Root ".project-skill.json"
    $exampleFile = Join-Path $Root ".project-skill.example.json"

    if (Test-Path $mainFile) {
        return $mainFile
    }

    if (Test-Path $exampleFile) {
        Copy-Item $exampleFile $mainFile -Force
        return $mainFile
    }

    $minimal = @'
{
  "$schema": "./schema/project-skill.schema.json",
  "version": 1,
  "updated_at": "1970-01-01T00:00:00Z",
  "skills": []
}
'@
    Set-Content -Path $mainFile -Value $minimal -Encoding UTF8
    return $mainFile
}

function Ensure-SkillMarkdownWithFrontmatter {
    param(
        [string]$SourceFile,
        [string]$TargetFile
    )

    $raw = Get-Content -Path $SourceFile -Raw -Encoding UTF8
    $frontmatter = @'
---
name: evolving-skill
description: Project-level evolving skill engine based on .project-skill.json with unified local path and auto-initialization.
---

'@
    $final = $frontmatter + $raw

    $targetDir = Split-Path -Path $TargetFile -Parent
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Set-Content -Path $TargetFile -Value $final -Encoding UTF8
}

$repoRootFull = (Resolve-Path $RepoRoot).Path
$sourceSkill = Join-Path $repoRootFull "skill\evolving-skill.md"

if (-not (Test-Path $sourceSkill)) {
    throw "Source skill not found: $sourceSkill"
}

$projectSkillFile = Ensure-ProjectSkillFile -Root $repoRootFull

$homeDir = [Environment]::GetFolderPath("UserProfile")
$targets = @(
    (Join-Path $homeDir ".claude\skills\evolving-skill\SKILL.md"),
    (Join-Path $homeDir ".cursor\skills\evolving-skill\SKILL.md")
)

foreach ($target in $targets) {
    Ensure-SkillMarkdownWithFrontmatter -SourceFile $sourceSkill -TargetFile $target
}

Write-Host "Installed unified skill to available tool locations."
Write-Host "Project skill data source: $projectSkillFile"
