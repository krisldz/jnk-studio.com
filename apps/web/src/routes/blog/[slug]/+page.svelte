<script lang="ts">
	import type { PageProps } from './$types';
	import { page } from '$app/state';
	import { localizeHref, getLocale } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import ResponsiveImage from '#lib/components/ResponsiveImage.svelte';
	import type { Locale } from '#lib/api/types.ts';

	let { data }: PageProps = $props();
	const p = $derived(data.post);

	const dateFmt = new Intl.DateTimeFormat(getLocale(), {
		year: 'numeric',
		month: 'long',
		day: 'numeric'
	});
	const publishedLabel = $derived(p.published_at ? dateFmt.format(new Date(p.published_at)) : '');

	// hreflang: dla każdego języka pełny URL do właściwego (przetłumaczonego) slugu.
	const alternates = $derived(
		Object.entries(p.alternates).map(([locale, slug]) => ({
			locale,
			href: new URL(
				localizeHref(`/blog/${slug}`, { locale: locale as Locale }),
				page.url.origin
			).toString()
		}))
	);
</script>

<svelte:head>
	<title>{p.seo.title} · JNK Studio</title>
	<meta name="description" content={p.seo.description} />
	{#each alternates as alt (alt.locale)}
		<link rel="alternate" hreflang={alt.locale} href={alt.href} />
	{/each}
</svelte:head>

<article class="paper-grid">
	<div class="mx-auto max-w-[1100px] px-4 py-16 sm:px-8 lg:px-14 lg:py-24">
		<a
			href={localizeHref('/blog')}
			class="mono text-xs uppercase no-underline hover:underline"
			style="text-underline-offset:6px; color: var(--color-muted)">← {m.back_to_blog()}</a
		>

		<div
			class="mono mt-8 flex flex-wrap gap-x-4 gap-y-1 text-xs uppercase"
			style="color: var(--color-muted)"
		>
			{#if p.category}<span>{p.category.name}</span>{/if}
			{#if publishedLabel}<span>· {publishedLabel}</span>{/if}
			{#if p.reading_time}<span>· {p.reading_time} {m.blog_min_read()}</span>{/if}
		</div>

		<h1
			class="mt-4 mb-6 text-[clamp(1.75rem,7vw,2.25rem)] font-extrabold uppercase lg:text-6xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.95"
		>
			{p.title}
		</h1>
		<p class="max-w-[48ch] text-xl" style="line-height:1.4">{p.lead}</p>

		{#if p.author}
			<p class="mono mt-4 text-xs uppercase" style="color: var(--color-muted)">
				{m.label_author()}: {p.author}
			</p>
		{/if}

		<div class="mt-12">
			<ResponsiveImage cover={p.cover} ratio="3 / 2" sizes="(max-width: 1100px) 100vw, 1100px" />
		</div>

		{#if p.body}
			<!-- eslint-disable-next-line svelte/no-at-html-tags -->
			<div class="prose mt-12 max-w-[68ch] text-lg leading-relaxed">{@html p.body}</div>
		{/if}
	</div>
</article>
