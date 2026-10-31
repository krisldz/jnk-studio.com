// Klient Rails API — WYŁĄCZNIE po stronie serwera (używa tokenu z $app/env/private).
import { API_INTERNAL_URL, API_TOKEN } from '$app/env/private';
import type { Locale, ProjectsIndex, ProjectDetail } from '#lib/api/types.ts';

type FetchFn = typeof globalThis.fetch;

async function apiGet<T>(fetchFn: FetchFn, path: string, locale: Locale): Promise<T | null> {
	const url = new URL(`${API_INTERNAL_URL}${path}`);
	url.searchParams.set('locale', locale);

	const headers: Record<string, string> = { Accept: 'application/json' };
	if (API_TOKEN) headers.Authorization = `Bearer ${API_TOKEN}`;

	const res = await fetchFn(url, { headers });
	if (res.status === 404) return null;
	if (!res.ok) throw new Error(`Rails API ${path} → ${res.status}`);
	return (await res.json()) as T;
}

export const getProjects = (fetchFn: FetchFn, locale: Locale) =>
	apiGet<ProjectsIndex>(fetchFn, '/projects', locale);

export const getProject = (fetchFn: FetchFn, slug: string, locale: Locale) =>
	apiGet<ProjectDetail>(fetchFn, `/projects/${encodeURIComponent(slug)}`, locale);
