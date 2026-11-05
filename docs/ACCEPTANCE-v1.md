# SynapsCode v1 — acceptance evidence

Date: 2026-11-04 (parent continuation after agent-graph BLOCKED)

## Verified locally

```powershell
cd "D:\Synaptivo sp. z o.o\_worktrees\synapscode-graph-20261104"
python -m unittest tests.test_layout -v
powershell -NoProfile -File .\install\Install-SynapsCode.ps1 -DryRun -SkipOpenCodeInstall
powershell -NoProfile -File .\experiments\Run-DshBakeoff.ps1
```

## Checklist vs product promise

| Requirement | Evidence | Status |
|---|---|---|
| OpenCode pin, no fork | `install/opencode-pin.json`; no `anomalyco/opencode` source tree in repo | PASS (layout) |
| Synaptivo branding | `profile/themes/synaptivo.json` + `branding/*` | PASS |
| Per-user auth docs | `docs/AUTH.md` (subscriptions `/connect` + OpenRouter BYOK) | PASS (docs) |
| Installer | `install/Install-SynapsCode.ps1` (+ DryRun, secret refuse, receipt) | PASS (script) |
| Skills pack | `maker-reviewer-lite`, `operations-playbook` | PASS |
| Website integration brief | `website/download-section.md` + `website/INTEGRATION.md` | PASS (brief) |
| DSH bake-off | `experiments/dsh-bakeoff.md` + `Run-DshBakeoff.ps1` | PASS (harness) |
| Live `/connect` coding turn on clean Windows | needs human + user key | OPEN |
| GitHub release zip | https://github.com/Synaptivo/SynapsCode/releases/tag/v0.1.0 | PASS |
| synaptivo.eu download page live | needs PR into `synaptivo-ai-website` using release URL | OPEN |
| Synaps-hosted models | roadmap only | OPEN (out of v1) |

## Agent-graph note

Run `_runs/synapscode-graph-20261104` ended **BLOCKED** (~19:35): makers refused live-checkout / adapter crash. Parent completed remaining v1 packaging in the worktree without waiting on a retry.

## Remaining to call the *goal* complete

1. Publish GitHub (or Synaptivo) release zip of this tree
2. Wire CTA on synaptivo.eu per `website/INTEGRATION.md`
3. Human UAT: clean Windows user, installer, `/connect`, one coding turn
4. Optional: execute bake-off arms and decide DSH for v2 shell
