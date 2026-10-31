# JNK Studio

Wielojęzyczna strona portfolio pracowni architektury i wnętrz JNK Studio (SvelteKit, SSR)
oraz panel CMS w Rails. Całość w kontenerach Docker — identycznie lokalnie i na produkcji.

Pełna specyfikacja startowa: dokument „JNK Studio — dokumentacja startowa: strona www + CMS".

## Stos

| Warstwa     | Technologia                                                   |
| ----------- | ------------------------------------------------------------- |
| Frontend    | SvelteKit 3 + Svelte 5 (runes), Vite 8, TypeScript 6          |
| i18n UI     | Paraglide JS 2 (PL domyślny, EN pod `/en`)                    |
| Style / UI  | Tailwind CSS 4 (`@theme`), Bits UI                            |
| Backend/CMS | Ruby on Rails 8.1 (Ruby 4.0), API `/api/v1` + panel `/admin`  |
| Baza        | PostgreSQL 17; Solid Queue/Cache/Cable (bez Redisa)           |
| Media       | Active Storage + libvips (warianty WebP/AVIF)                 |
| Proxy       | Caddy 2 (jedna domena)                                        |

## Struktura

```
apps/web     # SvelteKit — strona publiczna (SSR)
apps/cms     # Rails 8.1 — JSON API + panel CMS
infra/caddy  # Caddyfile (dev i prod)
docs         # openapi.yaml, ADR-y
compose.yaml # środowisko dev
```

## Szybki start (dev)

Wymagany tylko Docker.

```bash
cp .env.example .env     # uzupełnij API_TOKEN (openssl rand -hex 32)
make up                  # albo: docker compose up
```

- Strona: http://localhost:8080 — realizacje: http://localhost:8080/realizacje (EN: `/en/realizacje`)
- API: http://localhost:8080/api/v1/projects (wymaga nagłówka `Authorization: Bearer <API_TOKEN>`)
- Mailpit (podgląd maili): http://localhost:8025

Pierwsze uruchomienie samo instaluje gemy i przygotowuje bazę (entrypoint dev), a następnie
ładuje seed z jedną realizacją w PL i EN.

Przydatne skróty: `make help`.

## Jakość

- Frontend: `pnpm --filter web lint` / `check` / `test:unit`
- Backend: `make console`, `docker compose exec backend bin/rubocop`, `bin/rails test`
- CI (GitHub Actions): lint → typy → testy obu aplikacji → build obrazów Docker.

## Konwencje

- Trunk-based, gałęzie `feat/… fix/… chore/…`, Conventional Commits, PR z zielonym CI.
- Kod i nazwy po angielsku; treści i dokumentacja projektowa po polsku.
- Decyzje architektoniczne jako ADR w `docs/adr/`.
- Sekrety nigdy w repo (`.env` poza repo, Rails credentials per środowisko).
