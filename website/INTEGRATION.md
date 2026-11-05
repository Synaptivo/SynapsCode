# Integracja SynapsCode ze stroną synaptivo.eu

Repo strony: `Synaptivo/synaptivo-ai-website`  
Lokalnie: `D:\Synaptivo sp. z o.o\Strona WWW 2026\synaptivo-ai-website`

## Cel

Dodać sekcję / stronę pobierania SynapsCode (PL+EN), Windows-only w v1, z disclaimerem MIT OpenCode.

## Docelowe pliki (do edycji w repo strony)

Sprawdź aktualne ścieżki przed PR — orientacyjnie:

| Cel | Propozycja ścieżki |
|---|---|
| Copy PL/EN | `src/data/` (np. nowy `synapscode.ts`) albo istniejący katalog produktów |
| Strona / routing | `src/pages/` lub router w `src/` — np. `/synapscode` / `/produkty/synapscode` |
| Asset logo | użyć `branding/logo-z-napisem.png` z paczki SynapsCode albo istniejącego `public/` |
| CTA download | link do GitHub Release zip SynapsCode (placeholder do podmiany po pierwszym release) |

## Copy

Źródło treści: `website/download-section.md` (ten katalog).

Wymagane elementy CTA:

- Nagłówek: SynapsCode
- 3 bulletpoints: subskrypcje `/connect`, OpenRouter BYOK, Windows v1
- Przycisk: Pobierz / Download → URL release
- Disclaimer: OpenCode = MIT autorów; SynapsCode = profil/instalator Synaptivo, nie fork autorstwa

## Zakazy

- Nie twierdzić o macOS/Linux, dopóki nie przetestowane
- Nie obiecywać „w cenie Claude/ChatGPT”
- Nie hostować cudzych kluczy API

## Acceptance strony

1. Strona renderuje PL i EN
2. CTA wskazuje na artefakt (nawet placeholder release)
3. Disclaimer widoczny bez scrollowania poniżej foldu sekcji
4. Brak `noindex` przypadkiem na stronie produktowej (chyba że shadow — decyzja Mateusza)
