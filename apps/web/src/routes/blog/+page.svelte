<script lang="ts">
	import type { PageProps } from './$types';
	import { localizeHref, getLocale } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import ResponsiveImage from '#lib/components/ResponsiveImage.svelte';

	let { data }: PageProps = $props();

	const dateFmt = new Intl.DateTimeFormat(getLocale(), {
		year: 'numeric',
		month: 'long',
		day: 'numeric'
	});
	const formatDate = (iso: string | null) => (iso ? dateFmt.format(new Date(iso)) : '');
</script>

<svelte:head>
	<title>{m.blog_title()} · JNK Studio</title>
	<meta name="description" content={m.blog_lead()} />
</svelte:head>

<section class="paper-grid">
	<div class="mx-auto max-w-[1440px] px-4 py-16 sm:px-8 lg:px-14 lg:py-28">
		<div class="mono mb-8 text-xs uppercase" style="color: var(--color-muted)">
			Arkusz — {m.blog_title()}
		</div>
		<h1
			class="m-0 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-7xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
		>
			{m.blog_title()}
		</h1>
		<p class="mt-6 max-w-[42ch] text-lg" style="color: var(--color-muted)">{m.blog_lead()}</p>

		{#if data.posts.length === 0}
			<p class="mono mt-16 text-sm uppercase" style="color: var(--color-muted)">
				{m.blog_empty()}
			</p>
		{:else}
			<div class="mt-16 grid grid-cols-1 gap-x-8 gap-y-14 md:grid-cols-2 lg:grid-cols-3">
				{#each data.posts as post (post.slug)}
					<a href={localizeHref(`/blog/${post.slug}`)} class="group block no-underline">
						<ResponsiveImage cover={post.cover} ratio="3 / 2" />
						<div
							class="mono mt-4 flex flex-wrap justify-between gap-x-4 gap-y-1 border-t pt-4 text-xs uppercase"
							style="border-color: var(--color-ink)"
						>
							<span style="color: var(--color-muted)">{post.category?.name ?? m.nav_blog()}</span>
							<span style="color: var(--color-muted)">
								{formatDate(post.published_at)}{post.reading_time
									? ` · ${post.reading_time} ${m.blog_min_read()}`
									: ''}
							</span>
						</div>
						<h2
							class="mt-3 text-2xl font-extrabold uppercase group-hover:underline"
							style="font-stretch:110%; letter-spacing:-0.02em; line-height:1; text-underline-offset:6px"
						>
							{post.title}
						</h2>
						<p class="mt-3 text-base" style="color: var(--color-muted); line-height:1.5">
							{post.lead}
						</p>
					</a>
				{/each}
			</div>
		{/if}
	</div>
</section>
