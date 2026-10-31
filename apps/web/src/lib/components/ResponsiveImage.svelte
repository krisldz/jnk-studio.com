<script lang="ts">
	import type { Cover } from '#lib/api/types.ts';

	let {
		cover,
		ratio = '4 / 3',
		sizes = '(max-width: 640px) 100vw, 50vw',
		dark = false,
		class: className = ''
	}: {
		cover: Cover | null;
		ratio?: string;
		sizes?: string;
		dark?: boolean;
		class?: string;
	} = $props();

	const srcset = $derived(
		cover?.sources?.length ? cover.sources.map((s) => `${s.url} ${s.width}w`).join(', ') : undefined
	);
</script>

{#if cover}
	<img
		src={cover.url}
		{srcset}
		{sizes}
		width={cover.width ?? undefined}
		height={cover.height ?? undefined}
		alt={cover.alt ?? ''}
		loading="lazy"
		decoding="async"
		class={className}
		style="aspect-ratio:{ratio};width:100%;height:auto;object-fit:cover;display:block"
	/>
{:else}
	<div
		class="{dark ? 'ph-d' : 'ph'} {className}"
		role="img"
		aria-label="Miejsce na zdjęcie"
		style="aspect-ratio:{ratio};width:100%"
	></div>
{/if}
