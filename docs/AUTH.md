# SynapsCode authentication

## Principle

**Per-user credentials only.** SynapsCode configures OpenCode so *you* attach *your* providers. Synaptivo does not operate a shared Claude/ChatGPT/Copilot seat pool and does not ask for passwords to those services.

## Path A — Subscription logins (preferred when you already pay)

OpenCode already supports provider logins similar in spirit to Hermes/OpenClaw-style “use the CLI you pay for”:

1. Run `opencode`
2. `/connect`
3. Choose e.g. ChatGPT Plus/Pro, GitHub Copilot, Anthropic, Google, …
4. Complete the provider’s own device/OAuth or API-key flow

Keys/tokens land in OpenCode’s local auth store (`~/.local/share/opencode/auth.json` on typical installs). Do not commit that file.

## Path B — OpenRouter API key (fallback)

When you cannot or do not want to wire individual subscriptions:

1. Create an API key at [openrouter.ai](https://openrouter.ai/) under **your** account
2. `/connect` → OpenRouter → paste the key
3. `/models` → pick a model

SynapsCode’s `profile/opencode.json` prelists a few OpenRouter model ids as a starting catalog; you can extend it.

## Path C — Future Synaps models

Planned: a Synaptivo-issued OpenAI-compatible endpoint appears as another provider in the same profile. Same rule — the key belongs to the end user / their Synaptivo account, not a shared operator vault.

## Explicit non-goals

- Selling or proxying third-party consumer subscriptions
- Shipping Synaptivo operator `.env` or Fleet quota into customer installs
- Multi-tenant reverse-proxy that shares one DeepSeek/OpenAI login across customers
