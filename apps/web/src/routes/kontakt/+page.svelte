<script lang="ts">
	import { m } from '#lib/paraglide/messages.js';

	const types = $derived([
		{ id: 'dom', label: m.contact_type_dom() },
		{ id: 'wn', label: m.contact_type_wn() },
		{ id: 'usl', label: m.contact_type_usl() },
		{ id: 'kon', label: m.contact_type_kon() },
		{ id: 'inne', label: m.contact_type_inne() }
	]);

	let selectedType = $state('dom');
	let sent = $state(false);

	// TODO(etap formularza): podmienić na POST /api/v1/inquiries (Solid Queue + e-mail).
	function handleSubmit(event: SubmitEvent) {
		event.preventDefault();
		sent = true;
	}
</script>

<svelte:head>
	<title>{m.nav_contact()} · JNK Studio</title>
	<meta name="description" content={m.contact_reply()} />
</svelte:head>

<div class="contact-dark">
	<section>
		<div class="mx-auto max-w-[1440px] px-4 py-20 sm:px-8 lg:px-14">
			<div
				class="mono mb-10 flex flex-wrap justify-between gap-3 text-xs uppercase"
				style="color: var(--color-muted-light)"
			>
				<span>{m.contact_sheet()}</span>
				<span>{m.contact_reply()}</span>
			</div>
			<h1
				class="m-0 mb-20 text-6xl font-extrabold uppercase lg:text-[9vw]"
				style="font-stretch:125%; letter-spacing:-0.035em; line-height:.88"
			>
				{m.contact_hero_1()}<br /><span style="color: var(--color-accent)"
					>{m.contact_hero_2()}</span
				>
			</h1>

			<div class="flex flex-wrap gap-16">
				<!-- FORMULARZ -->
				<div class="min-w-0 flex-[3_1_520px]">
					{#if sent}
						<div
							class="flex flex-col items-start gap-6 border p-12"
							role="status"
							style="border-color: var(--color-line-dark)"
						>
							<span
								class="flex h-16 w-16 items-center justify-center rounded-full text-3xl"
								style="background: var(--color-accent); color: var(--color-ink)"
								aria-hidden="true">✓</span
							>
							<h2
								class="m-0 text-5xl font-extrabold uppercase"
								style="font-stretch:125%; line-height:.95"
							>
								{m.contact_sent_title()}
							</h2>
							<p class="m-0 max-w-[40ch] text-lg" style="line-height:1.55; color: var(--color-dim)">
								{m.contact_sent_body()}
							</p>
							<button
								type="button"
								class="mono rounded-full border px-6 py-4 text-xs uppercase"
								style="background: transparent; color: var(--color-light); border-color: var(--color-light); cursor: pointer"
								onclick={() => (sent = false)}>{m.contact_sent_again()}</button
							>
						</div>
					{:else}
						<form class="flex flex-col gap-9" onsubmit={handleSubmit}>
							<fieldset class="m-0 min-w-0 border-0 p-0">
								<legend
									class="mono mb-4 p-0 text-xs uppercase"
									style="color: var(--color-muted-light)"
								>
									{m.contact_type_legend()}
								</legend>
								<div class="mono flex flex-wrap gap-2 text-xs uppercase">
									{#each types as t (t.id)}
										{@const on = selectedType === t.id}
										<button
											type="button"
											class="chip"
											class:chip-on={on}
											aria-pressed={on}
											onclick={() => (selectedType = t.id)}>{t.label}</button
										>
									{/each}
								</div>
							</fieldset>

							<div class="flex flex-wrap gap-8">
								<label class="field mono flex flex-[1_1_220px] flex-col gap-1 text-xs uppercase">
									<span style="color: var(--color-muted-light)">{m.contact_f_name()}</span>
									<input type="text" name="name" autocomplete="name" required />
								</label>
								<label class="field mono flex flex-[1_1_220px] flex-col gap-1 text-xs uppercase">
									<span style="color: var(--color-muted-light)">{m.contact_f_email()}</span>
									<input type="email" name="email" autocomplete="email" required />
								</label>
							</div>
							<div class="flex flex-wrap gap-8">
								<label class="field mono flex flex-[1_1_220px] flex-col gap-1 text-xs uppercase">
									<span style="color: var(--color-muted-light)">{m.contact_f_phone()}</span>
									<input type="tel" name="phone" autocomplete="tel" />
								</label>
								<label class="field mono flex flex-[1_1_220px] flex-col gap-1 text-xs uppercase">
									<span style="color: var(--color-muted-light)">{m.contact_f_place()}</span>
									<input type="text" name="place" />
								</label>
							</div>
							<label class="field mono flex flex-col gap-1 text-xs uppercase">
								<span style="color: var(--color-muted-light)">{m.contact_f_message()}</span>
								<textarea name="message" rows="4"></textarea>
							</label>
							<label
								class="mono flex items-start gap-3 text-xs"
								style="line-height:1.6; color: var(--color-muted-light); text-transform:none"
							>
								<input
									type="checkbox"
									name="rodo"
									required
									style="width:20px;height:20px;margin:0;accent-color:var(--color-accent);flex:none"
								/>
								{m.contact_rodo()}
							</label>
							<button
								type="submit"
								class="mono self-start rounded-full px-8 py-5 text-sm font-medium uppercase"
								style="background: var(--color-accent); color: var(--color-ink); border:0; cursor:pointer"
								>{m.contact_send()}</button
							>
						</form>
					{/if}
				</div>

				<!-- DANE KONTAKTOWE -->
				<div class="flex flex-[1_1_280px] flex-col gap-8 text-xl" style="line-height:1.4">
					<div style="white-space: pre-line">
						<div class="mono mb-2 text-xs uppercase" style="color: var(--color-muted-light)">
							{m.contact_info_studio_label()}
						</div>
						{m.contact_info_studio()}
					</div>
					<div>
						<div class="mono mb-2 text-xs uppercase" style="color: var(--color-muted-light)">
							{m.contact_info_phone_label()}
						</div>
						<a href="tel:+48000000000">{m.contact_phone()}</a>
					</div>
					<div>
						<div class="mono mb-2 text-xs uppercase" style="color: var(--color-muted-light)">
							{m.contact_info_email_label()}
						</div>
						<a href="mailto:{m.contact_email()}">{m.contact_email()}</a>
					</div>
					<div>
						<div class="mono mb-2 text-xs uppercase" style="color: var(--color-muted-light)">
							{m.contact_info_hours_label()}
						</div>
						{m.contact_hours()}<br />
						<span class="text-base" style="color: var(--color-muted-light)"
							>{m.contact_hours_note()}</span
						>
					</div>
					<!-- Docelowe profile uzupełni redakcja; na razie placeholdery. -->
					<div class="mono flex flex-wrap gap-x-5 gap-y-2 text-xs uppercase">
						<!-- svelte-ignore a11y_invalid_attribute -->
						<a href="#" class="inline-flex min-h-11 items-center">{m.social_instagram()}</a>
						<!-- svelte-ignore a11y_invalid_attribute -->
						<a href="#" class="inline-flex min-h-11 items-center">{m.social_facebook()}</a>
						<!-- svelte-ignore a11y_invalid_attribute -->
						<a href="#" class="inline-flex min-h-11 items-center">{m.social_behance()}</a>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- MAPA -->
	<section
		class="paper-grid border-t"
		style="border-color: var(--color-ink); color: var(--color-ink)"
	>
		<div class="mx-auto max-w-[1440px] px-4 py-14 sm:px-8 lg:px-14">
			<div
				class="mono mb-4 flex justify-between gap-3 text-xs uppercase"
				style="color: var(--color-muted)"
			>
				<span>{m.contact_map_kicker()}</span>
				<span>N ↑</span>
			</div>
			<div
				class="ph relative flex items-center justify-center border"
				role="img"
				aria-label={m.contact_map_ph()}
				style="height:440px; border-color: var(--color-ink)"
			>
				<span
					class="mono border px-2.5 py-1.5 text-xs"
					style="border-color: var(--color-ink); background: var(--color-paper)"
					>{m.contact_map_ph()}</span
				>
				<span
					aria-hidden="true"
					style="position:absolute; left:58%; top:34%; width:28px; height:28px; border-radius:999px; background:var(--color-accent); border:3px solid var(--color-ink)"
				></span>
			</div>
		</div>
	</section>
</div>

<style>
	.contact-dark {
		background: var(--color-ink-900);
		color: var(--color-light);
	}
	.contact-dark a {
		color: var(--color-light);
	}
	.contact-dark a:hover {
		color: var(--color-accent);
	}
	.field input,
	.field textarea {
		font-family: var(--font-sans);
		font-size: 20px;
		text-transform: none;
		color: var(--color-light);
		background: transparent;
		border: 0;
		border-bottom: 1px solid var(--color-line-dark);
		padding: 12px 0;
		outline: none;
		width: 100%;
		box-sizing: border-box;
	}
	.field input:focus,
	.field textarea:focus {
		border-bottom-color: var(--color-accent);
	}
	.field textarea {
		resize: vertical;
	}
	.chip {
		font: inherit;
		cursor: pointer;
		border: 1px solid var(--color-line-dark);
		border-radius: 999px;
		padding: 12px 18px;
		min-height: 44px;
		background: transparent;
		color: var(--color-light);
	}
	.chip:hover {
		border-color: var(--color-light);
	}
	.chip-on {
		background: var(--color-accent);
		border-color: var(--color-accent);
		color: var(--color-ink);
	}
</style>
