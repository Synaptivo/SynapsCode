# Bake-off: OpenCode profile vs DeepSeek Harness

Status: planned (not part of v1 download)

Runner (checklist + environment capture, no secrets):

```powershell
.\experiments\Run-DshBakeoff.ps1
```

## Hypothesis

DeepSeek Harness may be a better *product shell* (Web UI + Cordis plugins) than branding OpenCode — but DSH is public preview with breaking changes. OpenCode remains v1 until this experiment passes.

## Setup (clean Windows user)

Same OpenRouter key (user-owned), same one-file skill text, same task: summarize a tiny repo and edit one file.

### Arm A — SynapsCode / OpenCode

1. Run `Install-SynapsCode.ps1 -SkipOpenCodeInstall:$false`
2. `/connect` OpenRouter; `/theme` synaptivo
3. Execute task with `maker-reviewer-lite`

### Arm B — DeepSeek Harness

1. `npx @deepseek-ai/dsh@<pin> web` (record exact version)
2. Configure OpenAI-compatible custom provider → OpenRouter (no DeepSeek account login)
3. Load equivalent skill/plugin without patching DSH core
4. Same task

## Pass criteria for promoting DSH to shell candidate

- Pin reinstall reproduces the run
- First UI surface can show Synaptivo without forking DSH core
- Secret stays in user-local credential file
- Skill loads without editing DSH internals

## Fail → keep OpenCode as shell

Any of: forced DeepSeek login for the task, core patch required for brand, pin breaks on reinstall, WSL-only path on Windows.
