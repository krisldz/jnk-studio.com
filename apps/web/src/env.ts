import { defineEnvVars } from '@sveltejs/kit/env';

// Zmienne środowiskowe (SvelteKit 3). Prywatne → $app/env/private (tylko serwer),
// publiczne → $app/env/public. Odczyt w runtime (static: false).
export const variables = defineEnvVars({
	API_INTERNAL_URL: {
		description: 'Adres wewnętrzny Rails API (tylko po stronie serwera).',
		schema: (value) => value ?? 'http://backend:3000/api/v1'
	},
	API_TOKEN: {
		description: 'Token serwisowy autoryzujący SvelteKit w Rails API.',
		schema: (value) => value ?? ''
	}
});
