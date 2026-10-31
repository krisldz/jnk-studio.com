# 0003 — Segmenty URL dla EN (prowizorka szkieletu)

- Status: tymczasowe (do rozstrzygnięcia w „Otwartych decyzjach")
- Data: 2026-10-31

## Kontekst

Specyfikacja przewiduje tłumaczone segmenty ścieżek: `/realizacje` (PL) ↔ `/en/projects` (EN),
definiowane w opcji `urlPatterns` pluginu Paraglide, przy jednej kanonicznej nazwie pliku trasy.
To jedna z otwartych decyzji (segmenty tłumaczone vs te same co PL).

## Decyzja (na teraz)

W szkielecie używamy domyślnej strategii prefiksu Paraglide: EN pod `/en/<segment PL>`
(np. `/en/realizacje`). Slugi treści są już w pełni tłumaczone w bazie, więc hreflang i przełącznik
języka działają poprawnie (`/en/realizacje/mokotow-apartment`).

## Dług do spłaty

Gdy zapadnie decyzja o tłumaczonych segmentach, dodajemy `urlPatterns` w konfiguracji Paraglide
(`/realizacje` ↔ `/en/projects`, `/o-nas` ↔ `/en/about` itd.). Nazwy plików tras pozostają kanoniczne;
zmiana nie dotyka architektury ani API.
