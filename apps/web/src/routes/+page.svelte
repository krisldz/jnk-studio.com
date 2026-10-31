<script lang="ts">
	import { localizeHref } from '#lib/paraglide/runtime.js';
	import { m } from '#lib/paraglide/messages.js';
</script>

<svelte:head>
	<title>JNK Studio — pracownia architektury i wnętrz</title>
</svelte:head>

<section class="paper-grid">
	<div class="mx-auto max-w-[1440px] px-4 py-24 sm:px-8 lg:px-14 lg:py-32">
		<div class="mono mb-10 text-xs uppercase" style="color: var(--color-muted)">
			Arkusz 01 — Start · Skala 1:1
		</div>
		<h1
			class="m-0 max-w-[14ch] text-5xl font-extrabold uppercase lg:text-8xl"
			style="font-stretch:125%; letter-spacing:-0.035em; line-height:.9"
		>
			Rysujemy miejsca, w których
			<span style="background: var(--color-accent); padding:0 .12em">się żyje.</span>
		</h1>
		<a
			href={localizeHref('/realizacje')}
			class="mono mt-12 inline-block border-b-2 pb-1 text-sm uppercase no-underline"
			style="border-color: var(--color-ink)">{m.view_project()} ↓</a
		>
	</div>
</section>
