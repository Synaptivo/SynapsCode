#Requires -Version 5.1
<#
.SYNOPSIS
  Install SynapsCode profile on top of pinned upstream OpenCode (no fork).

.DESCRIPTION
  1) Ensures OpenCode CLI at the pinned version when possible
  2) Copies Synaptivo theme, tui.json, opencode.json merge stub, skills, branding
  3) Never writes API keys; user runs /connect themselves

.NOTES
  Credentials stay in OpenCode's auth store. Synaptivo does not collect them.
#>
[CmdletBinding()]
param(
  [string]$ConfigHome = $(if ($env:XDG_CONFIG_HOME) { Join-Path $env:XDG_CONFIG_HOME "opencode" } else { Join-Path $env:USERPROFILE ".config\opencode" }),
  [switch]$SkipOpenCodeInstall
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$PinPath = Join-Path $PSScriptRoot "opencode-pin.json"
$Pin = Get-Content $PinPath -Raw | ConvertFrom-Json

Write-Host "SynapsCode installer"
Write-Host "  pin: $($Pin.tag)  $($Pin.url)"
Write-Host "  config: $ConfigHome"

if (-not $SkipOpenCodeInstall) {
  $existing = Get-Command opencode -ErrorAction SilentlyContinue
  if (-not $existing) {
    Write-Host "OpenCode not on PATH. Install pinned upstream $($Pin.tag) from:"
    Write-Host "  $($Pin.url)"
    Write-Host "Official options (pick one):"
    Write-Host "  irm https://opencode.ai/install | iex"
    Write-Host "  npm i -g opencode-ai@$($Pin.tag.TrimStart('v'))"
    Write-Host "  scoop / winget / GitHub release asset for Windows"
    Write-Host "Re-run this installer with -SkipOpenCodeInstall after opencode is on PATH,"
    Write-Host "or continue — profile/theme/skills will still be installed."
  } else {
    Write-Host "OpenCode already on PATH: $($existing.Source)"
    Write-Host "Verify version matches pin $($Pin.tag) (opencode --version). Update manually if needed."
  }
}

New-Item -ItemType Directory -Force -Path @(
  $ConfigHome,
  (Join-Path $ConfigHome "themes"),
  (Join-Path $ConfigHome "skills")
) | Out-Null

Copy-Item (Join-Path $Root "profile\themes\synaptivo.json") (Join-Path $ConfigHome "themes\synaptivo.json") -Force
Copy-Item (Join-Path $Root "profile\tui.json") (Join-Path $ConfigHome "tui.json") -Force

$targetConfig = Join-Path $ConfigHome "opencode.json"
$sourceConfig = Join-Path $Root "profile\opencode.json"
if (-not (Test-Path $targetConfig)) {
  Copy-Item $sourceConfig $targetConfig
  Write-Host "Wrote $targetConfig"
} else {
  $backup = "$targetConfig.synapscode-backup-$(Get-Date -Format yyyyMMddHHmmss)"
  Copy-Item $targetConfig $backup
  Copy-Item $sourceConfig $targetConfig -Force
  Write-Host "Replaced opencode.json (backup: $backup)"
}

foreach ($skillDir in Get-ChildItem (Join-Path $Root "skills") -Directory) {
  $dest = Join-Path $ConfigHome "skills\$($skillDir.Name)"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Copy-Item (Join-Path $skillDir.FullName "*") $dest -Recurse -Force
  Write-Host "Skill: $($skillDir.Name)"
}

$brandDest = Join-Path $ConfigHome "synapscode-branding"
New-Item -ItemType Directory -Force -Path $brandDest | Out-Null
Copy-Item (Join-Path $Root "branding\*") $brandDest -Force

Write-Host ""
Write-Host "Done. Next:"
Write-Host "  1. opencode"
Write-Host "  2. /theme  -> synaptivo"
Write-Host "  3. /connect -> OpenRouter or your own subscription provider"
Write-Host "  4. Read docs\\AUTH.md — Synaptivo never sells third-party seats"
Write-Host "NOTICE: OpenCode MIT + Ai-Stack Apache-2.0 — see NOTICE"
