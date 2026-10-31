<script lang="ts">
	import type { PageProps } from './$types';
	import { localizeHref } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import ResponsiveImage from '#lib/components/ResponsiveImage.svelte';

	let { data }: PageProps = $props();
</script>

<svelte:head>
	<title>{m.projects_title()} · JNK Studio</title>
	<meta name="description" content={m.projects_lead()} />
</svelte:head>

<section class="paper-grid">
	<div class="mx-auto max-w-[1440px] px-4 py-16 sm:px-8 lg:px-14 lg:py-28">
		<div class="mono mb-8 text-xs uppercase" style="color: var(--color-muted)">
			Arkusz — {m.projects_title()}
		</div>
		<h1
			class="m-0 text-5xl font-extrabold uppercase lg:text-7xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
		>
			{m.projects_title()}
		</h1>
		<p class="mt-6 max-w-[42ch] text-lg" style="color: var(--color-muted)">{m.projects_lead()}</p>

		{#if data.projects.length === 0}
			<p class="mono mt-16 text-sm uppercase" style="color: var(--color-muted)">
				{m.projects_empty()}
			</p>
		{:else}
			<div class="mt-16 grid grid-cols-1 gap-x-8 gap-y-14 md:grid-cols-2">
				{#each data.projects as project, i (project.slug)}
					<a href={localizeHref(`/realizacje/${project.slug}`)} class="group block no-underline">
						<ResponsiveImage cover={project.cover} ratio="4 / 3" />
						<div
							class="mono mt-4 flex flex-wrap justify-between gap-x-4 gap-y-1 border-t pt-4 text-xs uppercase"
							style="border-color: var(--color-ink)"
						>
							<span>
								<span style="color: var(--color-muted)">P—{String(i + 1).padStart(2, '0')}</span>
								&nbsp;{project.title}
							</span>
							<span style="color: var(--color-muted)">
								{project.category?.name ?? ''}{project.year ? ` · ${project.year}` : ''}
							</span>
						</div>
					</a>
				{/each}
			</div>
		{/if}
	</div>
</section>
