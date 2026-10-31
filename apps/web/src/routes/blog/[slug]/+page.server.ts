import type { PageServerLoad } from './$types';
import { error } from '@sveltejs/kit';
import { getLocale } from '#lib/paraglide/runtime.js';
import { getPost } from '#lib/server/api.ts';
import type { Locale } from '#lib/api/types.ts';

export const load: PageServerLoad = async ({ params, fetch, setHeaders }) => {
	const locale = getLocale() as Locale;
	const post = await getPost(fetch, params.slug, locale);

	if (!post) error(404, 'Nie znaleziono wpisu');

	setHeaders({ 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=600' });

	return { post };
};
