---
name: maker-reviewer-lite
description: Lightweight Synaptivo method — one model builds, a different lineage reviews, then a targeted repair. Portable; does not require Fleet, Agent Office, or Knowledge Hub.
---

# Maker / Reviewer Lite

Use this skill when the user wants Synaptivo-style quality without installing the full Ai-Stack.

## Workflow

1. Restate the goal and write a short TODO (requirements, done_when, out of scope).
2. **Maker pass** — implement the smallest change that could satisfy done_when.
3. Run the real checks the project already has (tests, typecheck, lint, build).
4. **Reviewer pass** — switch to a *different model family* (e.g. Claude built → Gemini/Grok/OpenAI reviews). Reviewer is read-only: compare artifact to done_when; list concrete failures only.
5. If review fails, one **targeted repair** against those findings; re-run checks; re-review once.
6. Stop after one repair loop unless the user explicitly continues.

## Rules

- Never mark done on a single model's self-assessment alone.
- Do not invent Fleet, Office, or Hub dependencies.
- Credentials stay the user's (`/connect` or their OpenRouter key).
- Prefer English skill text so external users can follow it.

## Done when

- Checks pass.
- A second lineage has accepted or the user waived review in writing.
