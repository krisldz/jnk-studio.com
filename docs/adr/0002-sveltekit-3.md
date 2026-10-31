# 0002 — SvelteKit 3 i konwencje frontendu

- Status: przyjęte
- Data: 2026-10-31

## Kontekst

Startujemy na SvelteKit 3.x (scaffold `sv create` zainstalował 3.1.1), Svelte 5.57,
Vite 8.3 (Rolldown), TypeScript 6. SvelteKit 3 zmienia kilka konwencji względem v2.

## Decyzja

Przyjmujemy konwencje SvelteKit 3, które oficjalne narzędzie `sv` generuje domyślnie:

- Konfiguracja Kita w `vite.config.ts` (plugin `sveltekit({ adapter: adapter() })`); brak `svelte.config.js`.
- Aliasy `#lib` / `#lib/*` (Node subpath imports, mapowane w `package.json`), import z rozszerzeniem
  (`#lib/api/types.ts`); `$lib` nie jest już używany.
- Zmienne środowiskowe deklarowane w `src/env.ts` (`defineEnvVars`), odczyt przez
  `$app/env/private` (serwer) i `$app/env/public`. Stare `$env/*` przestarzałe.
- `tsconfig.json` rozszerza `$app/tsconfig`; stan przez `$app/state` (nie `$app/stores`).

## Weryfikacja zgodności z Vite 8 / Rolldown

Potwierdzone przy inicjalizacji (`pnpm check` = 0 błędów, dev + build działają w Dockerze):

- `@tailwindcss/vite` 4.3 — OK
- `@inlang/paraglide-js` 2.18 (plugin Vite) — OK
- `bits-ui` 2.20 — zainstalowany, OK

Brak obejść; gdyby pojawił się problem z którąś zależnością na Vite 8, notujemy osobnym ADR.
