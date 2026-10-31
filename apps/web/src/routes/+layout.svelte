<script lang="ts">
	import './layout.css';
	import SiteHeader from '#lib/components/SiteHeader.svelte';
	import SiteFooter from '#lib/components/SiteFooter.svelte';
	import type { LayoutProps } from './$types';

	let { children }: LayoutProps = $props();
</script>

<div class="flex min-h-dvh flex-col">
	<SiteHeader />

	<main class="flex-1">
		{@render children()}
	</main>

	<SiteFooter />
</div>
