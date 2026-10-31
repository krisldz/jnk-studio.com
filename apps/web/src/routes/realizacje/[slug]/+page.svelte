<script lang="ts">
	import type { PageProps } from './$types';
	import { page } from '$app/state';
	import { localizeHref } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import ResponsiveImage from '#lib/components/ResponsiveImage.svelte';
	import type { Locale } from '#lib/api/types.ts';

	let { data }: PageProps = $props();
	const p = $derived(data.project);

	// hreflang: dla każdego języka pełny URL do właściwego (przetłumaczonego) slugu.
	const alternates = $derived(
		Object.entries(p.alternates).map(([locale, slug]) => ({
			locale,
			href: new URL(
				localizeHref(`/realizacje/${slug}`, { locale: locale as Locale }),
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
			href={localizeHref('/realizacje')}
			class="mono text-xs uppercase no-underline hover:underline"
			style="text-underline-offset:6px; color: var(--color-muted)">← {m.back_to_projects()}</a
		>

		<h1
			class="mt-8 mb-6 text-4xl font-extrabold uppercase lg:text-6xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.95"
		>
			{p.title}
		</h1>
		<p class="max-w-[48ch] text-xl" style="line-height:1.4">{p.lead}</p>

		<dl
			class="mono mt-10 grid grid-cols-2 gap-6 border-t pt-6 text-xs uppercase sm:grid-cols-3"
			style="border-color: var(--color-ink)"
		>
			{#if p.year}
				<div>
					<dt style="color: var(--color-muted)">{m.label_year()}</dt>
					<dd class="m-0 mt-1 text-base">{p.year}</dd>
				</div>
			{/if}
			{#if p.location}
				<div>
					<dt style="color: var(--color-muted)">{m.label_location()}</dt>
					<dd class="m-0 mt-1 text-base">{p.location}</dd>
				</div>
			{/if}
			{#if p.area_m2}
				<div>
					<dt style="color: var(--color-muted)">{m.label_area()}</dt>
					<dd class="m-0 mt-1 text-base">{p.area_m2} m²</dd>
				</div>
			{/if}
		</dl>

		<div class="mt-12">
			<ResponsiveImage cover={p.cover} ratio="3 / 2" sizes="(max-width: 1100px) 100vw, 1100px" />
		</div>

		{#if p.body}
			<!-- eslint-disable-next-line svelte/no-at-html-tags -->
			<div class="prose mt-12 max-w-[68ch] text-lg leading-relaxed">{@html p.body}</div>
		{/if}

		{#if p.blocks.length > 0}
			<div class="mt-12 grid grid-cols-1 gap-8 sm:grid-cols-2">
				{#each p.blocks as block, i (i)}
					{#if block.kind === 'image' && block.url}
						<ResponsiveImage
							cover={{ url: block.url, alt: block.alt ?? null, width: null, height: null }}
							ratio="4 / 3"
						/>
					{/if}
				{/each}
			</div>
		{/if}
	</div>
</article>
