# SynapsCode — synteza rady (2026-11-04)

## Uczestnicy

| Soczewka | Rodowód | Transport |
|---|---|---|
| Grok 4.7 | xAI | Cursor Task |
| Grok 4.7 (runda +DSH) | xAI | Cursor Task |
| Muse Spark 1.3 | Meta | Fleet advisory (zamiast Codex) |

Płatny panel OpenRouter (`rada.ps1`): zablokowany — brak klucza OpenRouter w środowisku procesu. Claude/Gemini/GPT w Cursor weekly: niedostępne.

## Składniki

1. Branding Synaptivo (logo + kolory strony)
2. OpenCode (`anomalyco/opencode`, MIT) — shell v1
3. Ai-Stack (`PapeMati98/Ai-Stack`, Apache-2.0) — metoda / wycinek skilli, nie pełny stack dla obcych
4. DeepSeek Harness (`deepseek-ai/deepseek-harness`, MIT) — kandydat shella v2 (public preview)

## Werdykt

**GO-Z-POPRAWKAMI**

SynapsCode v1 = przypięty upstream OpenCode + profil Synaptivo (motyw, auth per-user, 1–3 skills) + instalator Windows + strona pobierania. Bez forka silnika. Pełny Ai-Stack zostaje warsztatem wewnętrznym. DSH nie wchodzi do oferty v1; jest eksperymentem bake-off pod v2.

## MUST-FIX

1. Zero forka OpenCode w MVP — tylko pin + profil + instalator.
2. Auth per-user: własne logowania CLI (`/connect` ChatGPT/Copilot/Claude itd.) **albo** klucz OpenRouter użytkownika; Synaptivo nie odsprzedaje cudzych subskrypcji.
3. Jeden shell w ofercie v1 (OpenCode).
4. Zachowanie not MIT/Apache i ścieżki aktualizacji upstream.

## SHOULD-FIX

1. Telemetria domyślnie wyłączona.
2. Fleet/maker-reviewer jako opt-in skill, nie obowiązkowy runtime.
3. Modele Synaps jako późniejszy provider w tym samym profilu.
4. Desktop rebrand (ikona/nazwa) dopiero po bake-off i tylko jeśli pin buildu jest utrzymywalny.

## Test rozstrzygający (bake-off)

Czysty Windows, to samo zadanie, ten sam skill, ten sam model przez OpenRouter:

- A: pin OpenCode + profil Synaptivo
- B: pin `dsh web` + custom provider, bez konta DeepSeek

Metryki: TTFV, miejsce sekretu, branding bez łatki core, powtórka po reinstalacji pinu.

## Odrzucenie ścieżek

- Odrzuć fork OpenCode, jeśli profil działa bez patcha.
- Odrzuć „wgrywamy cały Ai-Stack”, jeśli orkiestracja wymaga Fleet/Office/Hub operatora.
- Odrzuć DSH jako shell v1, jeśli pin preview nie powtarza się po reinstalacji albo pierwsza powierzchnia zostaje DeepSeek bez forka.
