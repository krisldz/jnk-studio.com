<script lang="ts">
	import { page } from '$app/state';
	import { afterNavigate } from '$app/navigation';
	import { locales, localizeHref, getLocale } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import type { Locale } from '#lib/api/types.ts';

	let open = $state(false);

	// Zamknij menu mobilne po każdej nawigacji.
	afterNavigate(() => {
		open = false;
	});

	const items = $derived([
		{ id: '/', n: '01', label: m.nav_start() },
		{ id: '/realizacje', n: '02', label: m.nav_projects() },
		{ id: '/o-nas', n: '03', label: m.nav_about() },
		{ id: '/oferta', n: '04', label: m.nav_offer() },
		{ id: '/kontakt', n: '05', label: m.nav_contact() }
	]);

	function isActive(id: string): boolean {
		const routeId = page.route.id;
		if (!routeId) return false;
		if (id === '/') return routeId === '/';
		return routeId === id || routeId.startsWith(`${id}/`);
	}

	const otherLocale = $derived((locales.find((l) => l !== getLocale()) ?? getLocale()) as Locale);
	const langHref = $derived(localizeHref(page.url.pathname, { locale: otherLocale }));
</script>

<header class="paper-grid border-b" style="border-color: var(--color-ink)">
	<div
		class="mx-auto flex max-w-[1440px] flex-wrap items-center justify-between gap-5 px-4 py-5 sm:px-8 lg:px-14"
	>
		<a
			href={localizeHref('/')}
			class="text-xl font-extrabold tracking-tight uppercase no-underline"
			style="font-stretch:125%">JNK Studio</a
		>

		<!-- Nawigacja desktop -->
		<nav
			class="mono hidden items-center gap-x-8 gap-y-2 text-xs uppercase lg:flex"
			aria-label="Menu"
		>
			{#each items as item (item.id)}
				<a
					href={localizeHref(item.id)}
					class="no-underline hover:underline"
					style="text-underline-offset:6px"
					class:underline={isActive(item.id)}
					aria-current={isActive(item.id) ? 'page' : undefined}
				>
					<span style="color: var(--color-muted-2)">{item.n}</span>
					{item.label}
				</a>
			{/each}
			<a
				href={localizeHref('/kontakt')}
				class="rounded-full px-5 py-3.5 font-medium no-underline"
				style="background: var(--color-accent)">{m.cta_talk()}</a
			>
			<a
				href={langHref}
				class="rounded-full border px-4 py-2.5 no-underline"
				style="border-color: var(--color-ink)"
				hreflang={otherLocale}>{m.lang_switch()}</a
			>
		</nav>

		<!-- Burger (mobile) -->
		<button
			type="button"
			class="burger flex lg:hidden"
			aria-label={open ? m.menu_close() : m.menu_open()}
			aria-expanded={open}
			aria-controls="mobile-menu"
			onclick={() => (open = !open)}
		>
			{#if open}
				<svg
					width="22"
					height="22"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="1.8"
					aria-hidden="true"><path d="M5 5l14 14M19 5L5 19" /></svg
				>
			{:else}
				<svg
					width="22"
					height="22"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="1.8"
					aria-hidden="true"><path d="M3 7h18M3 12h18M3 17h18" /></svg
				>
			{/if}
		</button>
	</div>

	{#if open}
		<nav
			id="mobile-menu"
			class="mono border-t lg:hidden"
			style="border-color: var(--color-ink); background: var(--color-paper)"
			aria-label="Menu mobilne"
		>
			<div class="flex flex-col px-4 pb-8 sm:px-8">
				{#each items as item (item.id)}
					<a
						href={localizeHref(item.id)}
						class="flex items-baseline gap-4 border-b py-4 text-xl uppercase no-underline"
						style="border-color: var(--color-ink)"
						class:underline={isActive(item.id)}
						aria-current={isActive(item.id) ? 'page' : undefined}
					>
						<span class="text-xs" style="color: var(--color-muted-2)">{item.n}</span>
						{item.label}
					</a>
				{/each}
				<div class="mt-7 flex items-center gap-4">
					<a
						href={localizeHref('/kontakt')}
						class="rounded-full px-6 py-4 text-sm font-medium uppercase no-underline"
						style="background: var(--color-accent)">{m.cta_talk()}</a
					>
					<a
						href={langHref}
						class="rounded-full border px-4 py-3 text-sm no-underline"
						style="border-color: var(--color-ink)"
						hreflang={otherLocale}>{m.lang_switch()}</a
					>
				</div>
			</div>
		</nav>
	{/if}
</header>

<style>
	/* Widoczność steruje Tailwind (flex lg:hidden); tu tylko wygląd. */
	.burger {
		align-items: center;
		justify-content: center;
		width: 48px;
		height: 48px;
		padding: 0;
		border: 1px solid var(--color-ink);
		border-radius: 999px;
		background: transparent;
		color: var(--color-ink);
		cursor: pointer;
	}
</style>
