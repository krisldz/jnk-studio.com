// Klient Rails API — WYŁĄCZNIE po stronie serwera (używa tokenu z $app/env/private).
import { API_INTERNAL_URL, API_TOKEN } from '$app/env/private';
import type {
	Locale,
	ProjectsIndex,
	ProjectDetail,
	PostsIndex,
	PostDetail
} from '#lib/api/types.ts';

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

export const getPosts = (fetchFn: FetchFn, locale: Locale) =>
	apiGet<PostsIndex>(fetchFn, '/posts', locale);

export const getPost = (fetchFn: FetchFn, slug: string, locale: Locale) =>
	apiGet<PostDetail>(fetchFn, `/posts/${encodeURIComponent(slug)}`, locale);

export interface InquiryInput {
	name: string;
	email: string;
	phone?: string;
	place?: string;
	inquiry_type?: string;
	message?: string;
	consent: boolean;
}

export type InquiryResult =
	{ ok: true; id: number } | { ok: false; errors: Record<string, string[]> };

// POST /api/v1/inquiries — zapis zapytania z formularza kontaktowego.
// 201 → ok; 422 → błędy walidacji; inny status → wyjątek (obsłuż w akcji).
export async function createInquiry(
	fetchFn: FetchFn,
	locale: Locale,
	input: InquiryInput
): Promise<InquiryResult> {
	const url = new URL(`${API_INTERNAL_URL}/inquiries`);
	url.searchParams.set('locale', locale);

	const headers: Record<string, string> = {
		'Content-Type': 'application/json',
		Accept: 'application/json'
	};
	if (API_TOKEN) headers.Authorization = `Bearer ${API_TOKEN}`;

	const res = await fetchFn(url, {
		method: 'POST',
		headers,
		body: JSON.stringify({ inquiry: input })
	});

	if (res.status === 201 || res.status === 422) {
		return (await res.json()) as InquiryResult;
	}
	throw new Error(`Rails API /inquiries → ${res.status}`);
}
