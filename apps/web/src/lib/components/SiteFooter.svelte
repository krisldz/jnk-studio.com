<script lang="ts">
	import { m } from '#lib/paraglide/messages.js';
	import { localizeHref } from '#lib/paraglide/runtime.js';

	const year = new Date().getFullYear();

	const links = $derived([
		{ id: '/', label: m.nav_start() },
		{ id: '/realizacje', label: m.nav_projects() },
		{ id: '/o-nas', label: m.nav_about() },
		{ id: '/oferta', label: m.nav_offer() },
		{ id: '/blog', label: m.nav_blog() },
		{ id: '/kontakt', label: m.nav_contact() }
	]);
</script>

<footer class="section-dark border-t" style="border-color: var(--color-ink)">
	<div class="mx-auto max-w-[1440px] px-4 py-10 sm:px-8 lg:px-14">
		<div
			class="mono flex flex-wrap border text-xs uppercase"
			style="border-color: var(--color-line-dark)"
		>
			<div
				class="flex items-center border-r px-5 py-5 text-base font-extrabold tracking-tight"
				style="border-color: var(--color-line-dark); font-stretch:125%; flex: 1 1 200px"
			>
				JNK Studio
			</div>
			<div class="border-r px-5 py-5" style="border-color: var(--color-line-dark); flex: 1 1 160px">
				<div class="mb-1.5" style="color: var(--color-muted-light)">{m.footer_studio_label()}</div>
				{m.footer_studio()}
			</div>
			<div class="border-r px-5 py-5" style="border-color: var(--color-line-dark); flex: 1 1 160px">
				<div class="mb-1.5" style="color: var(--color-muted-light)">{m.footer_scale_label()}</div>
				{m.footer_scale()}
			</div>
			<div class="px-5 py-5" style="flex: 1 1 200px">
				<div class="mb-1.5" style="color: var(--color-muted-light)">© {year}</div>
				{m.footer_rights()}
			</div>
		</div>

		<nav
			class="mono mt-6 flex flex-wrap gap-x-6 gap-y-2 text-xs uppercase"
			aria-label={m.footer_nav_label()}
		>
			{#each links as link (link.id)}
				<a
					href={localizeHref(link.id)}
					class="no-underline hover:underline"
					style="text-underline-offset:6px">{link.label}</a
				>
			{/each}
		</nav>
	</div>
</footer>
