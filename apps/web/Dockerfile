# SvelteKit (adapter-node). Wieloetapowy: dev (HMR), build, prod (runtime Node).
FROM node:25-slim AS base
ENV PNPM_HOME=/pnpm PATH=/pnpm:$PATH
RUN corepack enable
WORKDIR /app

# --- dev: Vite dev server z HMR; źródła i node_modules montowane przez compose ---
FROM base AS dev
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
EXPOSE 5173
CMD ["pnpm", "dev", "--host", "0.0.0.0", "--port", "5173"]

# --- build: instalacja + kompilacja + usunięcie zależności dev ---
FROM base AS build
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
COPY . .
RUN pnpm build && pnpm prune --prod

# --- prod: minimalny runtime Node ---
FROM node:25-slim AS prod
WORKDIR /app
COPY --from=build /app/build ./build
COPY --from=build /app/node_modules ./node_modules
COPY package.json .
USER node
ENV NODE_ENV=production PORT=3000
EXPOSE 3000
CMD ["node", "build"]
