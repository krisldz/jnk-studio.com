// Typy odpowiedzi Rails API. Docelowo generowane z docs/openapi.yaml
// (openapi-typescript); na razie utrzymywane ręcznie dla szkieletu.

export type Locale = 'pl' | 'en';

export interface ImageSource {
	width: number;
	url: string;
}

export interface Cover {
	alt: string | null;
	width: number | null;
	height: number | null;
	url: string;
	sources?: ImageSource[];
}

export interface CategoryRef {
	slug: string;
	name: string;
}

export interface ProjectSummary {
	slug: string;
	alternates: Partial<Record<Locale, string>>;
	title: string;
	lead: string;
	year: number | null;
	location: string | null;
	area_m2: number | null;
	featured: boolean;
	category: CategoryRef | null;
	cover: Cover | null;
}

export interface ProjectBlock {
	kind: string;
	alt?: string | null;
	credit?: string | null;
	url?: string;
	html?: string;
}

export interface ProjectDetail extends ProjectSummary {
	body: string | null;
	blocks: ProjectBlock[];
	seo: { title: string; description: string };
}

export interface ProjectsIndex {
	locale: Locale;
	projects: ProjectSummary[];
}
