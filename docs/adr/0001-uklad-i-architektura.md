# 0001 — Układ monorepo i architektura

- Status: przyjęte
- Data: 2026-10-31

## Kontekst

Budujemy wielojęzyczną stronę portfolio JNK Studio (SSR) oraz panel CMS, z których
zespół sam zarządza treścią. Pełna specyfikacja startowa żyje w dokumencie
„JNK Studio — dokumentacja startowa: strona www + CMS".

## Decyzja

Jedno repozytorium (monorepo) z dwiema aplikacjami za jednym reverse proxy:

- `apps/web` — SvelteKit (SSR, strona publiczna), warstwa prezentacji bez własnej bazy.
- `apps/cms` — Rails 8.1 (monolit): jedyne źródło danych (JSON API `/api/v1`) + panel CMS (`/admin`, Hotwire).
- `infra/caddy` — Caddy 2 jako proxy: `/admin`, `/api`, `/rails`, `/assets` → Rails; reszta → SvelteKit.
- Jedna domena eliminuje CORS i upraszcza cookies podglądu. SvelteKit pobiera dane z Rails
  wyłącznie po wewnętrznej sieci Dockera (`http://backend:3000`), z tokenem serwisowym.

Całe środowisko w Dockerze (dev i prod), bez Redisa — Solid Queue/Cache/Cable w Postgresie.

## Konsekwencje

- Kontrakt API opisany w `docs/openapi.yaml`; z niego generujemy typy TS dla frontu.
- Zmiana w Rails łamie build frontu (typy), nie produkcję.
- Pliki generowane w kontenerze (Gemfile.lock, db/schema.rb) są commitowane z hosta (bind mount).
