import type { Actions } from './$types';
import { fail } from '@sveltejs/kit';
import { getLocale } from '#lib/paraglide/runtime.js';
import { createInquiry, type InquiryInput } from '#lib/server/api.ts';

const str = (v: FormDataEntryValue | null) => (typeof v === 'string' ? v.trim() : '');

export const actions: Actions = {
	default: async ({ request, fetch }) => {
		const form = await request.formData();

		const input: InquiryInput = {
			name: str(form.get('name')),
			email: str(form.get('email')),
			phone: str(form.get('phone')),
			place: str(form.get('place')),
			inquiry_type: str(form.get('inquiry_type')),
			message: str(form.get('message')),
			consent: form.get('rodo') != null
		};

		// Zachowaj wpisane dane, by po błędzie nie znikły z formularza.
		const values = {
			name: input.name,
			email: input.email,
			phone: input.phone,
			place: input.place,
			inquiry_type: input.inquiry_type,
			message: input.message
		};

		if (!input.name || !input.email || !input.consent) {
			return fail(400, { values, invalid: true });
		}

		try {
			const result = await createInquiry(fetch, getLocale(), input);
			if (!result.ok) {
				return fail(400, { values, invalid: true });
			}
		} catch {
			return fail(502, { values, serverError: true });
		}

		return { success: true };
	}
};
