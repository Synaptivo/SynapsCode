#Requires -Version 5.1
<#
.SYNOPSIS
  Install SynapsCode profile on top of pinned upstream OpenCode (no fork).

.DESCRIPTION
  Copies Synaptivo theme, tui.json, opencode.json, skills and branding into the
  user's OpenCode config home. Never writes API keys. OpenCode engine stays upstream.

.PARAMETER ConfigHome
  OpenCode config directory (default: ~/.config/opencode or $XDG_CONFIG_HOME/opencode).

.PARAMETER SkipOpenCodeInstall
  Only install the SynapsCode profile; do not attempt to locate/install OpenCode.

.PARAMETER DryRun
  Print actions without writing files.

.NOTES
  Credentials stay in OpenCode's auth store. Synaptivo does not collect them.
#>
[CmdletBinding()]
param(
  [string]$ConfigHome = $(if ($env:XDG_CONFIG_HOME) { Join-Path $env:XDG_CONFIG_HOME "opencode" } else { Join-Path $env:USERPROFILE ".config\opencode" }),
  [switch]$SkipOpenCodeInstall,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$PinPath = Join-Path $PSScriptRoot "opencode-pin.json"

function Assert-NoSecretArgs {
  param([string[]]$Values)
  $patterns = @(
    'sk-or-[a-zA-Z0-9]{8,}',
    'sk-[a-zA-Z0-9]{20,}',
    ('BEGIN' + ' PRIVATE ' + 'KEY'),
    '(?i)api[_-]?key\s*=\s*\S+'
  )
  foreach ($value in $Values) {
    if ([string]::IsNullOrEmpty($value)) { continue }
    foreach ($pat in $patterns) {
      if ($value -match $pat) {
        throw "Refusing to continue: argument looks like a secret. SynapsCode never accepts API keys as installer parameters — use OpenCode /connect instead."
      }
    }
  }
}

function Write-Step([string]$Message) {
  if ($DryRun) { Write-Host "[dry-run] $Message" } else { Write-Host $Message }
}

Assert-NoSecretArgs @($ConfigHome, $Root, "$SkipOpenCodeInstall", "$DryRun")

if (-not (Test-Path $PinPath)) { throw "Missing pin file: $PinPath" }
$Pin = Get-Content $PinPath -Raw | ConvertFrom-Json
foreach ($required in @("tag", "url")) {
  if (-not $Pin.$required) { throw "opencode-pin.json missing field: $required" }
}

Write-Host "SynapsCode installer"
Write-Host "  pin: $($Pin.tag)"
Write-Host "  pin url: $($Pin.url)"
Write-Host "  config: $ConfigHome"
if ($DryRun) { Write-Host "  mode: dry-run (no writes)" }

# Refuse installing into paths that look like secret stores
$forbiddenName = @("auth.json", ".env", "credentials.json", ".credentials.yaml")
foreach ($name in $forbiddenName) {
  if ($ConfigHome -match [regex]::Escape($name)) {
    throw "ConfigHome must be an OpenCode config directory, not a credential file path."
  }
}

if (-not $SkipOpenCodeInstall) {
  $existing = Get-Command opencode -ErrorAction SilentlyContinue
  if (-not $existing) {
    Write-Host "OpenCode not on PATH. Install pinned upstream $($Pin.tag) from:"
    Write-Host "  $($Pin.url)"
    Write-Host "Official options (pick one), then re-run with -SkipOpenCodeInstall if needed:"
    Write-Host "  irm https://opencode.ai/install | iex"
    Write-Host "  npm i -g opencode-ai@$($Pin.tag.TrimStart('v'))"
    Write-Host "  scoop / winget / GitHub Windows release asset"
  } else {
    Write-Host "OpenCode on PATH: $($existing.Source)"
    try {
      $verOut = & opencode --version 2>&1 | Out-String
      Write-Host "opencode --version:`n$verOut"
      if ($verOut -notmatch [regex]::Escape($Pin.tag.TrimStart('v')) -and $verOut -notmatch [regex]::Escape($Pin.tag)) {
        Write-Warning "Installed OpenCode version may not match pin $($Pin.tag). Update manually from $($Pin.url)."
      } else {
        Write-Host "Pin check: version string mentions pin tag (OK or close)."
      }
    } catch {
      Write-Warning "Could not run opencode --version: $_"
    }
  }
}

$themeSrc = Join-Path $Root "profile\themes\synaptivo.json"
$tuiSrc = Join-Path $Root "profile\tui.json"
$cfgSrc = Join-Path $Root "profile\opencode.json"
$skillsRoot = Join-Path $Root "skills"
$brandSrc = Join-Path $Root "branding"
foreach ($p in @($themeSrc, $tuiSrc, $cfgSrc, $skillsRoot, $brandSrc)) {
  if (-not (Test-Path $p)) { throw "Missing required package path: $p" }
}

$dirs = @(
  $ConfigHome,
  (Join-Path $ConfigHome "themes"),
  (Join-Path $ConfigHome "skills"),
  (Join-Path $ConfigHome "synapscode-branding")
)
foreach ($d in $dirs) {
  Write-Step "ensure dir $d"
  if (-not $DryRun) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

Write-Step "copy theme -> $(Join-Path $ConfigHome 'themes\synaptivo.json')"
Write-Step "copy tui.json"
if (-not $DryRun) {
  Copy-Item $themeSrc (Join-Path $ConfigHome "themes\synaptivo.json") -Force
  Copy-Item $tuiSrc (Join-Path $ConfigHome "tui.json") -Force
}

$targetConfig = Join-Path $ConfigHome "opencode.json"
if (Test-Path $targetConfig) {
  $backup = "$targetConfig.synapscode-backup-$(Get-Date -Format yyyyMMddHHmmss)"
  Write-Step "backup existing opencode.json -> $backup"
  if (-not $DryRun) {
    Copy-Item $targetConfig $backup
    Copy-Item $cfgSrc $targetConfig -Force
  }
} else {
  Write-Step "write $targetConfig"
  if (-not $DryRun) { Copy-Item $cfgSrc $targetConfig }
}

foreach ($skillDir in Get-ChildItem $skillsRoot -Directory) {
  $dest = Join-Path $ConfigHome "skills\$($skillDir.Name)"
  Write-Step "skill $($skillDir.Name) -> $dest"
  if (-not $DryRun) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item (Join-Path $skillDir.FullName "*") $dest -Recurse -Force
  }
}

Write-Step "branding -> $(Join-Path $ConfigHome 'synapscode-branding')"
if (-not $DryRun) {
  Copy-Item (Join-Path $brandSrc "*") (Join-Path $ConfigHome "synapscode-branding") -Force
}

$receipt = [ordered]@{
  product = "SynapsCode"
  installed_at = (Get-Date).ToString("o")
  opencode_pin = $Pin.tag
  opencode_pin_url = $Pin.url
  config_home = $ConfigHome
  dry_run = [bool]$DryRun
  secrets_written = $false
  notice = "See NOTICE for OpenCode MIT and Ai-Stack Apache-2.0"
}
$receiptPath = Join-Path $ConfigHome "synapscode-install-receipt.json"
Write-Step "receipt -> $receiptPath"
if (-not $DryRun) {
  ($receipt | ConvertTo-Json -Depth 5) | Set-Content -Path $receiptPath -Encoding utf8
}

Write-Host ""
Write-Host "Done."
Write-Host "  1. opencode"
Write-Host "  2. /theme  -> synaptivo"
Write-Host "  3. /connect -> OpenRouter OR your own subscription provider"
Write-Host "  4. docs/AUTH.md — Synaptivo never sells third-party seats"
Write-Host "  5. NOTICE — OpenCode MIT + Ai-Stack Apache-2.0"
