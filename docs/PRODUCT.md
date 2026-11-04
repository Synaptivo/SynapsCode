# SynapsCode product definition (v1)

## Promise

Download SynapsCode from Synaptivo, install on Windows, program with the same *method* Synaptivo uses (small TODO, second-lineage review), using **your** model access.

## Composition

| Layer | Choice |
|---|---|
| Runtime shell | Pinned upstream OpenCode (no fork) |
| Brand | Synaptivo theme + logos |
| Method | `maker-reviewer-lite` + selected Ai-Stack skills |
| Auth | `/connect` subscriptions and/or OpenRouter BYOK |
| Future shell candidate | DeepSeek Harness (bake-off only) |

## Distribution

- Artifact: this repository / release zip + `Install-SynapsCode.ps1`
- Site: download section on synaptivo.eu (see `website/download-section.md`)
- Updates: bump `install/opencode-pin.json` and re-test installer; do not silently patch OpenCode sources

## Acceptance (v1)

1. Fresh Windows profile: installer completes without API keys in the repo
2. Theme `synaptivo` selectable; logos present under config branding dir
3. User can `/connect` OpenRouter **or** a subscription provider and complete one coding turn
4. `maker-reviewer-lite` skill is loadable
5. NOTICE present; no claim that Synaptivo authored OpenCode
