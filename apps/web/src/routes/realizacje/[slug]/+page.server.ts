import type { PageServerLoad } from './$types';
import { error } from '@sveltejs/kit';
import { getLocale } from '#lib/paraglide/runtime.js';
import { getProject } from '#lib/server/api.ts';
import type { Locale } from '#lib/api/types.ts';

export const load: PageServerLoad = async ({ params, fetch, setHeaders }) => {
	const locale = getLocale() as Locale;
	const project = await getProject(fetch, params.slug, locale);

	if (!project) error(404, 'Nie znaleziono realizacji');

	setHeaders({ 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=600' });

	return { project };
};
