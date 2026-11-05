#Requires -Version 5.1
<#
.SYNOPSIS
  Checklist runner for OpenCode (SynapsCode) vs DeepSeek Harness bake-off.

.DESCRIPTION
  Does NOT run agents automatically against your code with secrets.
  Records environment versions and prints pass/fail criteria from dsh-bakeoff.md.
  Refuses API keys as parameters.
#>
[CmdletBinding()]
param(
  [string]$OutDir = "",
  [string]$DshPackage = "@deepseek-ai/dsh"
)

$ErrorActionPreference = "Stop"
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if (-not $OutDir) { $OutDir = Join-Path $ScriptDir "bakeoff-results" }
$Root = Split-Path -Parent $ScriptDir

function Assert-NoSecrets([string[]]$Values) {
  foreach ($v in $Values) {
    if ($v -match 'sk-or-[a-zA-Z0-9]{8,}' -or $v -match ('sk-' + '[a-zA-Z0-9]{20,}')) {
      throw "Refusing secrets on the command line. Configure providers inside each harness UI/CLI."
    }
  }
}
Assert-NoSecrets @($OutDir, $DshPackage)

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$report = Join-Path $OutDir "bakeoff-$stamp.json"

$opencode = Get-Command opencode -ErrorAction SilentlyContinue
$node = Get-Command node -ErrorAction SilentlyContinue
$npx = Get-Command npx -ErrorAction SilentlyContinue

$record = [ordered]@{
  started_at = (Get-Date).ToString("o")
  host = $env:COMPUTERNAME
  synapscode_root = $Root
  pin = (Get-Content (Join-Path $Root "install\opencode-pin.json") -Raw | ConvertFrom-Json)
  tools = [ordered]@{
    opencode_path = $(if ($opencode) { $opencode.Source } else { $null })
    opencode_version = $(if ($opencode) { (& opencode --version 2>&1 | Out-String).Trim() } else { $null })
    node_version = $(if ($node) { (& node --version 2>&1 | Out-String).Trim() } else { $null })
    npx_path = $(if ($npx) { $npx.Source } else { $null })
    dsh_package = $DshPackage
  }
  arms = [ordered]@{
    A_opencode_synapscode = [ordered]@{
      steps = @(
        "Run install/Install-SynapsCode.ps1",
        "opencode -> /connect OpenRouter (user key) -> /theme synaptivo",
        "Load maker-reviewer-lite; summarize tiny repo + one file edit"
      )
      pass_when = @(
        "Theme visible",
        "Task completes with user-owned key",
        "No operator .env required"
      )
    }
    B_deepseek_harness = [ordered]@{
      steps = @(
        "npx $DshPackage web (record exact resolved version)",
        "Custom OpenAI-compatible provider -> OpenRouter (no DeepSeek account required for pass)",
        "Same skill text / same task as arm A without patching DSH core"
      )
      pass_when = @(
        "Pin/reinstall reproduces",
        "Synaptivo surface without forking DSH core",
        "Secret stays user-local"
      )
    }
  }
  promote_dsh_to_shell_if = @(
    "Pin reinstall OK",
    "Brand without core fork",
    "User-local secret",
    "Skill loads without editing DSH internals"
  )
  keep_opencode_shell_if = @(
    "Forced DeepSeek login for the task",
    "Core patch required for brand",
    "Pin breaks on reinstall",
    "WSL-only on Windows"
  )
  secrets_accepted = $false
  status = "CHECKLIST_EMITTED"
  note = "Operator fills results manually after running both arms on a clean Windows user."
}

($record | ConvertTo-Json -Depth 8) | Set-Content -Path $report -Encoding utf8
Write-Host "Wrote $report"
Write-Host "Next: execute arms A and B on a clean Windows profile; update the JSON with outcomes."
Write-Host "See experiments/dsh-bakeoff.md"
