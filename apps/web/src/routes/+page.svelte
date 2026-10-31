<script lang="ts">
	import type { PageProps } from './$types';
	import { localizeHref } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import ResponsiveImage from '#lib/components/ResponsiveImage.svelte';

	let { data }: PageProps = $props();

	const services = $derived([
		{ n: '01', title: m.offer_s1_title(), desc: m.offer_s1_lead() },
		{ n: '02', title: m.offer_s2_title(), desc: m.offer_s2_lead() },
		{ n: '03', title: m.offer_s3_title(), desc: m.offer_s3_lead() },
		{ n: '04', title: m.offer_s4_title(), desc: m.offer_s4_lead() }
	]);
</script>

<svelte:head>
	<title>{m.home_meta_title()}</title>
	<meta name="description" content={m.home_hero_lead()} />
</svelte:head>

<!-- HERO -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 pt-14 sm:px-8 lg:px-14">
		<div
			class="mono mb-10 flex flex-wrap justify-between gap-3 text-xs uppercase"
			style="color: var(--color-muted)"
		>
			<span>{m.home_sheet()}</span>
			<span>{m.home_city()}</span>
			<span>{m.home_scale()}</span>
		</div>

		<div class="flex flex-wrap items-end gap-10">
			<h1
				class="m-0 min-w-0 flex-[3_1_640px] text-[clamp(1.6rem,8vw,3.75rem)] font-extrabold uppercase lg:text-[8.4vw]"
				style="font-stretch:125%; letter-spacing:-0.035em; line-height:.9"
			>
				{m.home_hero_pre()}
				<span class="hl">{m.home_hero_mark()}</span>
			</h1>
			<div class="flex flex-[1_1_280px] flex-col gap-6 pb-3">
				<p class="m-0 max-w-[36ch] text-lg" style="line-height:1.5">{m.home_hero_lead()}</p>
				<a
					href={localizeHref('/realizacje')}
					class="mono self-start border-b-2 pb-1.5 text-xs uppercase no-underline"
					style="border-color: var(--color-ink)">{m.home_hero_cta()}</a
				>
			</div>
		</div>

		<!-- linia wymiarowa -->
		<div
			class="mono my-14 mb-4 flex items-center gap-3 text-[11px]"
			style="color: var(--color-muted)"
			aria-hidden="true"
		>
			<div style="width:1px;height:16px;background:var(--color-ink)"></div>
			<div class="flex-1" style="height:1px;background:var(--color-ink)"></div>
			<span>12 000</span>
			<div class="flex-1" style="height:1px;background:var(--color-ink)"></div>
			<div style="width:1px;height:16px;background:var(--color-ink)"></div>
		</div>

		<div class="relative">
			<div
				class="ph flex items-center justify-center border p-4 text-center"
				role="img"
				aria-label={m.home_flagship_ph()}
				style="height:560px; border-color: var(--color-ink)"
			>
				<span
					class="mono border px-3.5 py-2 text-[13px]"
					style="border-color: var(--color-ink); background: var(--color-paper)"
					>{m.home_flagship_ph()}</span
				>
			</div>
		</div>
	</div>

	<!-- ticker -->
	<div class="section-dark mt-0 border-t" style="border-color: var(--color-ink)">
		<div
			class="mono mx-auto flex max-w-[1440px] flex-wrap gap-x-12 gap-y-3 px-4 py-4 text-[13px] uppercase sm:px-8 lg:px-14"
		>
			<span><span style="color: var(--color-accent)">●</span> {m.ticker_1()}</span>
			<span><span style="color: var(--color-accent)">●</span> {m.ticker_2()}</span>
			<span><span style="color: var(--color-accent)">●</span> {m.ticker_3()}</span>
			<span><span style="color: var(--color-accent)">●</span> {m.ticker_4()}</span>
		</div>
	</div>
</section>

<!-- PROJEKTY -->
<section class="section-dark">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mb-16 flex flex-wrap items-end justify-between gap-6">
			<div>
				<div class="mono mb-5 text-xs uppercase" style="color: var(--color-muted-light)">
					{m.home_projects_sheet()}
				</div>
				<h2
					class="lines m-0 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-8xl"
					style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
				>
					{m.home_projects_title()}
				</h2>
			</div>
			<a
				href={localizeHref('/realizacje')}
				class="mono rounded-full border px-6 py-4 text-xs uppercase no-underline"
				style="border-color: var(--color-light)">{m.home_projects_all()}</a
			>
		</div>

		{#if data.projects.length === 0}
			<div class="grid grid-cols-1 gap-8 md:grid-cols-2">
				{#each [0, 1, 2, 3] as i (i)}
					<div>
						<ResponsiveImage cover={null} dark ratio="16 / 11" />
						<div
							class="mono mt-4 flex justify-between border-t pt-4 text-xs uppercase"
							style="border-color: var(--color-ink-700)"
						>
							<span style="color: var(--color-muted-light)">P—{String(i + 1).padStart(2, '0')}</span
							>
							<span style="color: var(--color-muted-light)">{m.projects_empty()}</span>
						</div>
					</div>
				{/each}
			</div>
		{:else}
			<div class="grid grid-cols-1 gap-x-8 gap-y-14 md:grid-cols-2">
				{#each data.projects as project, i (project.slug)}
					<a href={localizeHref(`/realizacje/${project.slug}`)} class="group block no-underline">
						<ResponsiveImage cover={project.cover} dark ratio="16 / 11" />
						<div
							class="mono mt-4 flex flex-wrap justify-between gap-x-4 gap-y-1 border-t pt-4 text-xs uppercase"
							style="border-color: var(--color-ink-700)"
						>
							<span>
								<span style="color: var(--color-muted-light)"
									>P—{String(i + 1).padStart(2, '0')}</span
								>
								&nbsp;{project.title}
							</span>
							<span style="color: var(--color-muted-light)">
								{project.category?.name ?? ''}{project.year ? ` · ${project.year}` : ''}
							</span>
						</div>
					</a>
				{/each}
			</div>
		{/if}
	</div>
</section>

<!-- O NAS -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mono mb-10 text-xs uppercase" style="color: var(--color-muted)">
			{m.home_about_sheet()}
		</div>
		<p
			class="m-0 max-w-[22ch] text-3xl font-medium lg:text-5xl"
			style="font-stretch:110%; line-height:1.12; letter-spacing:-0.02em"
		>
			{m.home_about_pre()}
			<span class="hl">{m.home_about_mark()}</span>{m.home_about_post()}
		</p>
		<a
			href={localizeHref('/o-nas')}
			class="mono mt-12 inline-block border-b-2 pb-1.5 text-xs uppercase no-underline"
			style="border-color: var(--color-ink)">{m.home_about_more()}</a
		>
	</div>
</section>

<!-- OFERTA -->
<section style="background: var(--color-accent); border-bottom: 1px solid var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mb-14 flex flex-wrap items-end justify-between gap-6">
			<div>
				<div class="mono mb-5 text-xs uppercase">{m.home_offer_sheet()}</div>
				<h2
					class="lines m-0 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-8xl"
					style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
				>
					{m.home_offer_title()}
				</h2>
			</div>
			<p class="m-0 max-w-[34ch] text-lg" style="line-height:1.5">{m.home_offer_lead()}</p>
		</div>

		<div class="border-t-2" style="border-color: var(--color-ink)">
			{#each services as s (s.n)}
				<a
					href={localizeHref('/oferta')}
					class="svc flex flex-wrap items-center gap-x-10 gap-y-4 border-b py-8 no-underline"
					style="border-color: var(--color-ink)"
				>
					<span class="mono w-12 flex-none pt-1 text-sm">{s.n}</span>
					<span
						class="min-w-0 flex-[2_1_320px] text-2xl font-bold lg:text-[2.75rem]"
						style="font-stretch:115%; letter-spacing:-0.02em">{s.title}</span
					>
					<span class="hidden flex-[2_1_280px] text-base lg:block" style="line-height:1.5"
						>{s.desc}</span
					>
					<span class="svc-arrow text-3xl leading-none" aria-hidden="true">→</span>
				</a>
			{/each}
		</div>
		<a
			href={localizeHref('/oferta')}
			class="mono mt-12 inline-block border-b-2 pb-1.5 text-xs uppercase no-underline"
			style="border-color: var(--color-ink)">{m.home_offer_all()}</a
		>
	</div>
</section>

<!-- KONTAKT -->
<section class="section-dark">
	<div
		class="mx-auto flex max-w-[1440px] flex-wrap items-end justify-between gap-8 px-4 py-24 sm:px-8 lg:px-14 lg:py-28"
	>
		<h2
			class="lines m-0 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-7xl"
			style="font-stretch:125%; letter-spacing:-0.035em; line-height:.9"
		>
			{m.home_contact_title()}
		</h2>
		<div class="flex max-w-[38ch] flex-col items-start gap-5">
			<p class="m-0 text-lg" style="line-height:1.5; color: var(--color-dim)">
				{m.home_contact_lead()}
			</p>
			<a
				href={localizeHref('/kontakt')}
				class="mono rounded-full px-8 py-5 text-sm uppercase no-underline"
				style="background: var(--color-accent); color: var(--color-ink)">{m.home_contact_cta()}</a
			>
		</div>
	</div>
</section>

<style>
	.svc {
		color: var(--color-ink);
	}
	.svc-arrow {
		transition: transform 0.3s ease;
	}
	.svc:hover .svc-arrow {
		transform: translateX(8px);
	}
</style>
