<script lang="ts">
	import { resolve } from '$app/paths';
	import { page } from '$app/state';
	import { locales, localizeHref, getLocale } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
	import './layout.css';
	import type { LayoutProps } from './$types';

	let { children }: LayoutProps = $props();

	const otherLocale = $derived(locales.find((l) => l !== getLocale()) ?? getLocale());
</script>

<div class="flex min-h-dvh flex-col">
	<header class="paper-grid border-b" style="border-color: var(--color-ink)">
		<div
			class="mx-auto flex max-w-[1440px] items-center justify-between gap-5 px-4 py-5 sm:px-8 lg:px-14"
		>
			<a
				href={resolve('/')}
				class="text-xl font-extrabold tracking-tight uppercase"
				style="font-stretch:125%">JNK Studio</a
			>
			<nav class="mono flex items-center gap-6 text-xs uppercase">
				<a
					href={localizeHref('/realizacje')}
					class="hover:underline"
					style="text-underline-offset:6px">{m.nav_projects()}</a
				>
				<a
					href={localizeHref(page.url.pathname, { locale: otherLocale })}
					class="rounded-full border px-4 py-2"
					style="border-color: var(--color-ink)">{m.lang_switch()}</a
				>
			</nav>
		</div>
	</header>

	<main class="flex-1">
		{@render children()}
	</main>

	<footer
		class="mono border-t px-4 py-6 text-xs uppercase sm:px-8 lg:px-14"
		style="border-color: var(--color-ink); color: var(--color-muted)"
	>
		JNK Studio · Skala 1:1
	</footer>
</div>
