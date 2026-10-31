<script lang="ts">
	import { localizeHref } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';

	const values = $derived([
		{ title: m.about_v1_title(), desc: m.about_v1_desc() },
		{ title: m.about_v2_title(), desc: m.about_v2_desc() },
		{ title: m.about_v3_title(), desc: m.about_v3_desc() }
	]);

	const team = $derived([
		{ role: m.about_m1_role(), offset: false },
		{ role: m.about_m2_role(), offset: true },
		{ role: m.about_m3_role(), offset: false }
	]);

	const stats = $derived([
		{ value: m.about_stat1_value(), label: m.about_stat1_label() },
		{ value: m.about_stat2_value(), label: m.about_stat2_label() },
		{ value: m.about_stat3_value(), label: m.about_stat3_label() }
	]);

	const timeline = $derived([
		{ year: m.about_tl1_year(), text: m.about_tl1_text(), big: true },
		{ year: m.about_tl2_year(), text: m.about_tl2_text(), big: false },
		{ year: m.about_tl3_year(), text: m.about_tl3_text(), big: false },
		{ year: m.about_tl4_year(), text: m.about_tl4_text(), big: true }
	]);
</script>

<svelte:head>
	<title>{m.nav_about()} · JNK Studio</title>
	<meta name="description" content={m.about_intro_lead()} />
</svelte:head>

<!-- HERO -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-20 sm:px-8 lg:px-14">
		<div
			class="mono mb-10 flex flex-wrap justify-between gap-3 text-xs uppercase"
			style="color: var(--color-muted)"
		>
			<span>{m.about_sheet()}</span>
			<span>{m.about_kicker()}</span>
		</div>
		<h1
			class="m-0 mb-16 text-[clamp(1.6rem,8vw,3.75rem)] font-extrabold uppercase lg:text-[9vw]"
			style="font-stretch:125%; letter-spacing:-0.035em; line-height:.88"
		>
			{m.about_hero_1()}<br /><span class="hl">{m.about_hero_mark()}</span><br />{m.about_hero_2()}
		</h1>
		<div class="flex flex-wrap items-start gap-x-14 gap-y-10">
			<div
				class="ph flex min-w-0 flex-[3_1_560px] items-center justify-center border p-4 text-center"
				role="img"
				aria-label={m.about_photo_ph()}
				style="height:480px; border-color: var(--color-ink)"
			>
				<span
					class="mono border px-2.5 py-1.5 text-xs"
					style="border-color: var(--color-ink); background: var(--color-paper)"
					>{m.about_photo_ph()}</span
				>
			</div>
			<div class="flex min-w-0 flex-[2_1_320px] flex-col gap-6 text-lg" style="line-height:1.6">
				<p
					class="m-0 text-2xl font-medium"
					style="font-stretch:110%; line-height:1.25; letter-spacing:-0.01em"
				>
					{m.about_intro_lead()}
				</p>
				<p class="m-0">{m.about_intro_1()}</p>
				<p class="m-0">{m.about_intro_2()}</p>
			</div>
		</div>
	</div>
</section>

<!-- TRZY ZASADY -->
<section class="section-dark">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mono mb-5 text-xs uppercase" style="color: var(--color-muted-light)">
			{m.about_values_kicker()}
		</div>
		<h2
			class="m-0 mb-16 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-8xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
		>
			{m.about_values_title()}
		</h2>
		<div
			class="grid border-t"
			style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); border-color: var(--color-line-dark)"
		>
			{#each values as v, i (v.title)}
				<div
					class="flex flex-col gap-5 py-10"
					style={i < values.length - 1 ? 'border-right: 1px solid var(--color-line-dark)' : ''}
					class:pr-8={i < values.length - 1}
					class:pl-8={i > 0}
				>
					<span
						class="text-7xl font-extrabold lg:text-8xl"
						style="font-stretch:125%; line-height:1; color: var(--color-accent)"
						>{String(i + 1).padStart(2, '0')}</span
					>
					<h3 class="m-0 text-2xl font-bold" style="font-stretch:115%">{v.title}</h3>
					<p class="m-0 text-base" style="line-height:1.6; color: var(--color-dim)">{v.desc}</p>
				</div>
			{/each}
		</div>
	</div>
</section>

<!-- ZESPÓŁ -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mb-14 flex flex-wrap items-end justify-between gap-6">
			<div>
				<div class="mono mb-5 text-xs uppercase" style="color: var(--color-muted)">
					{m.about_team_kicker()}
				</div>
				<h2
					class="lines m-0 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-8xl"
					style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
				>
					{m.about_team_title()}
				</h2>
			</div>
			<p class="m-0 max-w-[34ch] text-lg" style="line-height:1.5">{m.about_team_lead()}</p>
		</div>
		<div
			class="grid gap-x-8 gap-y-12"
			style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr))"
		>
			{#each team as member, i (i)}
				<div class="flex flex-col gap-3.5 {member.offset ? 'lg:mt-14' : ''}">
					<div
						class="ph border"
						role="img"
						aria-label="Miejsce na portret"
						style="aspect-ratio: 4 / 5; border-color: var(--color-ink)"
					></div>
					<div class="mono text-xs uppercase" style="color: var(--color-muted)">{member.role}</div>
					<strong class="text-2xl font-bold" style="font-stretch:115%"
						>{m.about_member_name()}</strong
					>
					<p class="m-0 text-base" style="line-height:1.55">{m.about_member_bio()}</p>
				</div>
			{/each}
		</div>
	</div>
</section>

<!-- LICZBY + OŚ CZASU -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div class="mx-auto flex max-w-[1440px] flex-wrap gap-14 px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="flex flex-[1_1_300px] flex-col">
			{#each stats as stat, i (stat.label)}
				<div
					class="py-6"
					style="border-top: {i === 0 ? '2px' : '1px'} solid var(--color-ink);{i ===
					stats.length - 1
						? ' border-bottom: 1px solid var(--color-ink);'
						: ''}"
				>
					<div class="text-6xl font-extrabold lg:text-7xl" style="font-stretch:125%; line-height:1">
						{stat.value}
					</div>
					<div class="mono mt-2 text-xs uppercase" style="color: var(--color-muted)">
						{stat.label}
					</div>
				</div>
			{/each}
		</div>
		<div class="min-w-0 flex-[2_1_520px]">
			<div class="mono mb-6 text-xs uppercase" style="color: var(--color-muted)">
				{m.about_timeline_kicker()}
			</div>
			<div class="flex flex-col" style="border-left: 2px solid var(--color-ink)">
				{#each timeline as t, i (i)}
					<div
						class="relative flex flex-wrap gap-x-6 gap-y-1 pl-7"
						class:pb-10={i < timeline.length - 1}
					>
						<span
							class="absolute"
							style={t.big
								? 'left:-9px; top:4px; width:16px; height:16px; border-radius:999px; background:var(--color-accent); border:2px solid var(--color-ink); box-sizing:border-box'
								: 'left:-7px; top:6px; width:12px; height:12px; border-radius:999px; background:var(--color-ink)'}
						></span>
						<span class="mono w-16 flex-none text-sm">{t.year}</span>
						<span class="flex-[1_1_200px] text-lg" style="line-height:1.5">{t.text}</span>
					</div>
				{/each}
			</div>
		</div>
	</div>
</section>

<!-- CTA -->
<section style="background: var(--color-accent); border-bottom: 1px solid var(--color-ink)">
	<div
		class="mx-auto flex max-w-[1440px] flex-wrap items-center justify-between gap-6 px-4 py-20 sm:px-8 lg:px-14"
	>
		<h2
			class="m-0 text-[clamp(1.75rem,7.5vw,2.25rem)] font-extrabold uppercase lg:text-7xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.95"
		>
			{m.about_cta_title()}
		</h2>
		<a
			href={localizeHref('/kontakt')}
			class="mono rounded-full px-8 py-5 text-sm uppercase no-underline"
			style="background: var(--color-ink); color: var(--color-light)">{m.about_cta_btn()}</a
		>
	</div>
</section>
