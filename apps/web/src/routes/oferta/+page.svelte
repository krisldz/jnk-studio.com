<script lang="ts">
	import { localizeHref } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';

	const services = $derived([
		{
			title: m.offer_s1_title(),
			lead: m.offer_s1_lead(),
			items: [m.offer_s1_i1(), m.offer_s1_i2(), m.offer_s1_i3(), m.offer_s1_i4()]
		},
		{
			title: m.offer_s2_title(),
			lead: m.offer_s2_lead(),
			items: [m.offer_s2_i1(), m.offer_s2_i2(), m.offer_s2_i3(), m.offer_s2_i4()]
		},
		{
			title: m.offer_s3_title(),
			lead: m.offer_s3_lead(),
			items: [m.offer_s3_i1(), m.offer_s3_i2(), m.offer_s3_i3(), m.offer_s3_i4()]
		},
		{
			title: m.offer_s4_title(),
			lead: m.offer_s4_lead(),
			items: [m.offer_s4_i1(), m.offer_s4_i2(), m.offer_s4_i3(), m.offer_s4_i4()]
		}
	]);

	const steps = $derived([
		{ title: m.offer_step1_title(), desc: m.offer_step1_desc() },
		{ title: m.offer_step2_title(), desc: m.offer_step2_desc() },
		{ title: m.offer_step3_title(), desc: m.offer_step3_desc() },
		{ title: m.offer_step4_title(), desc: m.offer_step4_desc() },
		{ title: m.offer_step5_title(), desc: m.offer_step5_desc() }
	]);

	const faqs = $derived([
		{ q: m.offer_q1(), a: m.offer_a1() },
		{ q: m.offer_q2(), a: m.offer_a2() },
		{ q: m.offer_q3(), a: m.offer_a3() },
		{ q: m.offer_q4(), a: m.offer_a4() }
	]);

	let openService = $state(0);
	let openFaq = $state(-1);
</script>

<svelte:head>
	<title>{m.nav_offer()} · JNK Studio</title>
	<meta name="description" content={m.offer_hero_lead()} />
</svelte:head>

<!-- HERO -->
<section style="background: var(--color-accent); border-bottom: 1px solid var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-20 sm:px-8 lg:px-14">
		<div class="mono mb-10 flex flex-wrap justify-between gap-3 text-xs uppercase">
			<span>{m.offer_sheet()}</span>
			<span>{m.offer_kicker()}</span>
		</div>
		<div class="flex flex-wrap items-end gap-x-14 gap-y-8">
			<h1
				class="lines m-0 w-full text-[clamp(1.6rem,8vw,3.75rem)] font-extrabold uppercase lg:text-[8.6vw]"
				style="font-stretch:125%; letter-spacing:-0.035em; line-height:.88"
			>
				{m.offer_hero()}
			</h1>
			<p class="m-0 max-w-[46ch] self-start text-lg lg:text-xl" style="line-height:1.5">
				{m.offer_hero_lead()}
			</p>
		</div>
	</div>
</section>

<!-- USŁUGI (akordeon) -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mono mb-6 text-xs uppercase" style="color: var(--color-muted)">
			{m.offer_services_hint()}
		</div>
		<div class="border-t-2" style="border-color: var(--color-ink)">
			{#each services as s, i (s.title)}
				{@const isOpen = openService === i}
				<div class="border-b" style="border-color: var(--color-ink)">
					<button
						type="button"
						class="acc flex w-full flex-wrap items-center gap-x-10 gap-y-4 text-left"
						aria-expanded={isOpen}
						onclick={() => (openService = isOpen ? -1 : i)}
					>
						<span class="mono w-12 flex-none text-sm">{String(i + 1).padStart(2, '0')}</span>
						<span
							class="acc-t min-w-0 flex-[1_1_320px] text-3xl font-bold lg:text-5xl"
							style="font-stretch:115%; letter-spacing:-0.02em">{s.title}</span
						>
						<span class="acc-i" class:acc-i-open={isOpen} aria-hidden="true">+</span>
					</button>
					{#if isOpen}
						<div class="flex flex-wrap gap-10 pb-12 lg:pl-[88px]">
							<div
								class="ph min-w-0 flex-[2_1_360px] border"
								role="img"
								aria-label="Miejsce na zdjęcie ilustrujące usługę"
								style="height:300px; border-color: var(--color-ink)"
							></div>
							<div class="flex min-w-0 flex-[2_1_360px] flex-col gap-5">
								<p class="m-0 text-lg" style="line-height:1.55">{s.lead}</p>
								<ul
									class="mono m-0 list-none border-t p-0 text-sm uppercase"
									style="border-color: var(--color-ink)"
								>
									{#each s.items as it (it)}
										<li class="flex gap-3 border-b py-3" style="border-color: var(--color-ink)">
											<span style="color: var(--color-muted)">—</span>{it}
										</li>
									{/each}
								</ul>
							</div>
						</div>
					{/if}
				</div>
			{/each}
		</div>
	</div>
</section>

<!-- PROCES -->
<section class="section-dark">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mono mb-5 text-xs uppercase" style="color: var(--color-muted-light)">
			{m.offer_process_kicker()}
		</div>
		<h2
			class="lines m-0 mb-16 text-[clamp(1.75rem,7.5vw,2.25rem)] font-extrabold uppercase lg:text-8xl"
			style="font-stretch:125%; letter-spacing:-0.03em; line-height:.92"
		>
			{m.offer_process_title()}
		</h2>
		<div class="grid gap-0" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr))">
			{#each steps as step, i (step.title)}
				<div
					class="py-7 pr-6"
					style={i === 0
						? 'border-top: 4px solid var(--color-accent)'
						: 'border-top: 1px solid var(--color-line-dark)'}
				>
					<div class="mono mb-6 text-xs" style="color: var(--color-muted-light)">
						{m.offer_process_kicker()}
						{String(i + 1).padStart(2, '0')}
					</div>
					<h3 class="m-0 mb-3 text-2xl" style="font-stretch:115%">{step.title}</h3>
					<p class="m-0 text-sm" style="line-height:1.55; color: var(--color-dim)">{step.desc}</p>
				</div>
			{/each}
		</div>
	</div>
</section>

<!-- FAQ -->
<section class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div
		class="mx-auto flex max-w-[1440px] flex-wrap gap-x-14 gap-y-8 px-4 py-24 sm:px-8 lg:px-14 lg:py-32"
	>
		<div class="flex-[1_1_300px]">
			<div class="mono mb-5 text-xs uppercase" style="color: var(--color-muted)">
				{m.offer_faq_kicker()}
			</div>
			<h2
				class="lines m-0 text-[clamp(1.75rem,7.5vw,2.25rem)] font-extrabold uppercase lg:text-6xl"
				style="font-stretch:125%; letter-spacing:-0.03em; line-height:.95"
			>
				{m.offer_faq_title()}
			</h2>
		</div>
		<div class="min-w-0 flex-[2_1_560px] border-t-2" style="border-color: var(--color-ink)">
			{#each faqs as f, i (f.q)}
				{@const isOpen = openFaq === i}
				<div class="border-b" style="border-color: var(--color-ink)">
					<button
						type="button"
						class="faq flex w-full items-center justify-between gap-6 text-left"
						aria-expanded={isOpen}
						onclick={() => (openFaq = isOpen ? -1 : i)}
					>
						<span class="text-xl font-semibold" style="font-stretch:110%">{f.q}</span>
						<span class="mono flex-none text-xl" aria-hidden="true">{isOpen ? '−' : '+'}</span>
					</button>
					{#if isOpen}
						<p class="m-0 max-w-[60ch] pb-7 text-base" style="line-height:1.6">{f.a}</p>
					{/if}
				</div>
			{/each}
		</div>
	</div>
</section>

<!-- CTA -->
<section class="section-dark">
	<div
		class="mx-auto flex max-w-[1440px] flex-wrap items-end justify-between gap-8 px-4 py-24 sm:px-8 lg:px-14"
	>
		<h2
			class="lines m-0 text-[clamp(1.75rem,7.5vw,3rem)] font-extrabold uppercase lg:text-8xl"
			style="font-stretch:125%; letter-spacing:-0.035em; line-height:.9"
		>
			{m.offer_cta_title_1()}
			<br /><span style="color: var(--color-accent)">{m.offer_cta_title_2()}</span>
		</h2>
		<div class="flex max-w-[38ch] flex-col items-start gap-5">
			<p class="m-0 text-lg" style="line-height:1.5; color: var(--color-dim)">
				{m.offer_cta_lead()}
			</p>
			<a
				href={localizeHref('/kontakt')}
				class="mono rounded-full px-8 py-5 text-sm uppercase no-underline"
				style="background: var(--color-accent); color: var(--color-ink)">{m.offer_cta_btn()}</a
			>
		</div>
	</div>
</section>

<style>
	.acc {
		font: inherit;
		color: inherit;
		background: transparent;
		border: 0;
		cursor: pointer;
		padding: 32px 0;
		min-height: 44px;
	}
	.acc:hover .acc-t {
		text-decoration: underline;
		text-underline-offset: 8px;
		text-decoration-thickness: 2px;
	}
	.acc-i {
		width: 56px;
		height: 56px;
		flex: none;
		border-radius: 999px;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 28px;
		border: 1px solid var(--color-ink);
		transition: transform 0.3s ease;
	}
	.acc-i-open {
		transform: rotate(45deg);
		background: var(--color-accent);
		border-color: var(--color-accent);
	}
	.faq {
		font: inherit;
		color: inherit;
		background: transparent;
		border: 0;
		cursor: pointer;
		padding: 24px 0;
		min-height: 44px;
	}
	.faq:hover {
		color: #000;
	}
</style>
