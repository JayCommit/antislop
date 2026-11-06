# Copy this repository into Agent Skill folders (Windows).
# Default: --host all --scope user ($env:USERPROFILE). Project scope uses the current directory.
# SKILL.md is placed directly in the skill folder. Existing destinations are refused.
# This file was not executed for the v0.0.2 release checks (no Windows, no PowerShell on the Linux checker).

$ErrorActionPreference = 'Stop'

$SkillHost = 'all'
$Scope = 'user'

function Fail {
  param([string]$Message)
  [Console]::Error.WriteLine($Message)
  exit 1
}

function Show-Usage {
  $text = @'
Usage: powershell -NoProfile -File scripts\install.ps1 [--host HOST] [--scope SCOPE]

Copy this repository into Agent Skill directories so SKILL.md sits directly
inside the skill folder (never antislop\antislop\).

HOST: grok | grok-bot | cursor | openai | antigravity | claude | all
      (default all)
SCOPE: user | project
      user copies under $env:USERPROFILE (default)
      project copies under the current directory

Does not overwrite an existing destination. Skips .git and .verification.
macOS/Linux: scripts/install.sh with the same flags.
'@
  [Console]::Out.WriteLine($text)
}

$i = 0
while ($i -lt $args.Count) {
  $arg = [string]$args[$i]
  if ($arg -eq '--help' -or $arg -eq '-h' -or $arg -eq '-help') {
    Show-Usage
    exit 0
  }
  if ($arg -eq '--host' -or $arg -eq '-host' -or $arg -eq '--scope' -or $arg -eq '-scope') {
    if ($i + 1 -ge $args.Count) { Fail "Missing value for $arg" }
    $val = [string]$args[$i + 1]
    if ($arg -like '*host') { $SkillHost = $val } else { $Scope = $val }
    $i += 2
    continue
  }
  if ($arg -like '--host=*') {
    $SkillHost = $arg.Substring(7)
    $i += 1
    continue
  }
  if ($arg -like '--scope=*') {
    $Scope = $arg.Substring(8)
    $i += 1
    continue
  }
  Fail "Unknown argument: $arg"
}

$hostsOk = @('grok', 'grok-bot', 'cursor', 'openai', 'antigravity', 'claude', 'all')
if ($hostsOk -notcontains $SkillHost) { Fail "Unknown host: $SkillHost" }
if (@('user', 'project') -notcontains $Scope) { Fail "Unknown scope: $Scope" }

$scriptPath = $MyInvocation.MyCommand.Path
if ([string]::IsNullOrEmpty($scriptPath)) { Fail 'Cannot locate install.ps1' }
$repo = Split-Path -Parent (Split-Path -Parent $scriptPath)
$skillFile = Join-Path $repo 'SKILL.md'
if (-not (Test-Path -LiteralPath $skillFile)) { Fail "SKILL.md not found at repo root: $repo" }

if ($Scope -eq 'user') {
  if ([string]::IsNullOrEmpty($env:USERPROFILE)) { Fail 'USERPROFILE is not set' }
  $root = $env:USERPROFILE
} else {
  $root = (Get-Location).Path
}

# Snapshot before creating destinations so a project install inside this repo
# does not copy the new skill folder back into itself.
$items = @(Get-ChildItem -Force -LiteralPath $repo | Where-Object {
  $_.Name -ne '.git' -and $_.Name -ne '.verification'
})
if ($items.Count -eq 0) { Fail "Nothing to copy from $repo" }

$rels = New-Object System.Collections.Generic.List[string]

function Add-Rel {
  param([string]$Rel)
  if (-not $script:rels.Contains($Rel)) {
    [void]$script:rels.Add($Rel)
  }
}

function Add-HostRels {
  param([string]$Name)
  switch ($Name) {
    'grok' { Add-Rel '.grok/skills/antislop' }
    'grok-bot' { Add-Rel '.grok/skills/antislop' }
    'cursor' { Add-Rel '.cursor/skills/antislop' }
    'openai' { Add-Rel '.agents/skills/antislop' }
    'antigravity' {
      if ($script:Scope -eq 'user') {
        Add-Rel '.gemini/config/skills/antislop'
        Add-Rel '.gemini/antigravity-cli/skills/antislop'
      } else {
        Add-Rel '.agents/skills/antislop'
      }
    }
    'claude' { Add-Rel '.claude/skills/antislop' }
  }
}

if ($SkillHost -eq 'all') {
  Add-HostRels 'grok'
  Add-HostRels 'grok-bot'
  Add-HostRels 'cursor'
  Add-HostRels 'openai'
  Add-HostRels 'antigravity'
  Add-HostRels 'claude'
} else {
  Add-HostRels $SkillHost
}

if ($rels.Count -eq 0) { Fail "No destinations for host $SkillHost" }

function Join-SkillPath {
  param([string]$RootPath, [string]$Rel)
  $path = $RootPath
  foreach ($part in ($Rel -split '/')) {
    $path = Join-Path $path $part
  }
  return $path
}

$destinations = @()
foreach ($rel in $rels) {
  $dest = Join-SkillPath $root $rel
  if (Test-Path -LiteralPath $dest) { Fail "Installation already exists: $dest" }
  $destinations += $dest
}

Write-Output "Installing host=$SkillHost scope=$Scope from $repo"

foreach ($dest in $destinations) {
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($item in $items) {
    if ($item.PSIsContainer) {
      Copy-Item -LiteralPath $item.FullName -Destination $dest -Recurse
    } else {
      Copy-Item -LiteralPath $item.FullName -Destination $dest
    }
  }
  $installed = Join-Path $dest 'SKILL.md'
  $nested = Join-Path (Join-Path $dest 'antislop') 'SKILL.md'
  $gitDir = Join-Path $dest '.git'
  if (-not (Test-Path -LiteralPath $installed)) { Fail "Install failed: missing $installed" }
  if (Test-Path -LiteralPath $nested) { Fail "Install failed: double-nested $nested" }
  if (Test-Path -LiteralPath $gitDir) { Fail "Install failed: copied .git into $dest" }
  Write-Output "Installed $dest"
}
