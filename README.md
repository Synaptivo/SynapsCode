# SynapsCode

**Program like the Synaptivo team — on your machine, with your credentials.**

SynapsCode is a Synaptivo distribution around [OpenCode](https://github.com/anomalyco/opencode) (MIT): branded profile, per-user auth, and a small skill pack from [Ai-Stack](https://github.com/PapeMati98/Ai-Stack) (Apache-2.0). It does **not** fork the OpenCode engine.

## What you get

- Pinned official OpenCode CLI (`install/opencode-pin.json`)
- Synaptivo theme + logo assets
- Auth: connect your own provider subscriptions via OpenCode `/connect` (ChatGPT Plus/Pro, GitHub Copilot, Anthropic, …) **or** paste your own OpenRouter API key
- 1–3 portable skills (maker/reviewer method + operations playbook)
- Windows installer script

## What you do not get (v1)

- A fork of OpenCode or DeepSeek Harness
- Shared Claude/ChatGPT seats sold by Synaptivo
- Full internal Fleet / Agent Office / Knowledge Hub stack
- Synaps-hosted models (planned later as another provider in the same profile)

## Quick start (Windows)

```powershell
cd Produkty\SynapsCode
.\install\Install-SynapsCode.ps1
```

Then:

```powershell
opencode
```

In the TUI:

1. `/theme` → select `synaptivo`
2. `/connect` → OpenRouter **or** your subscription provider
3. `/models` → pick a model

## Auth policy

Credentials stay on **your** machine (`~/.local/share/opencode/auth.json` for OpenCode). Synaptivo never needs your Claude/OpenAI password. If you use OpenRouter, you create and own that key.

## License notices

- OpenCode: MIT — see `NOTICE`
- Vendored Ai-Stack skill(s): Apache-2.0 — see `NOTICE`
- Synaptivo branding and packaging: © Synaptivo sp. z o.o.

## Roadmap sketch

1. v1 — OpenCode pin + profile + installer + download page
2. Bake-off — DeepSeek Harness as alternative shell candidate
3. Synaps models — same provider slot, Synaptivo-issued endpoint
4. Optional fleet mode — opt-in maker/reviewer for users who install more of Ai-Stack
