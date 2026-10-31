import type { PageServerLoad } from './$types';
import { getLocale } from '#lib/paraglide/runtime.js';
import { getProjects } from '#lib/server/api.ts';
import type { Locale } from '#lib/api/types.ts';

export const load: PageServerLoad = async ({ fetch, setHeaders }) => {
	const locale = getLocale() as Locale;
	const data = await getProjects(fetch, locale);

	setHeaders({ 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=600' });

	// Na stronie głównej pokazujemy do czterech wybranych realizacji.
	return { projects: (data?.projects ?? []).slice(0, 4) };
};
