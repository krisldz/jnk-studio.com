# JNK Studio — skróty developerskie. Całe środowisko w Dockerze.
.DEFAULT_GOAL := help
COMPOSE := docker compose

.PHONY: help up down restart logs ps build console dbconsole migrate seed \
        setup test lint fmt bundle attach-web shell-backend

help: ## Pokaż tę pomoc
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

up: ## Postaw całe środowisko (proxy, web, backend, jobs, db, mail)
	$(COMPOSE) up

build: ## Przebuduj obrazy
	$(COMPOSE) build

down: ## Zatrzymaj i usuń kontenery
	$(COMPOSE) down

restart: ## Restart usług
	$(COMPOSE) restart

logs: ## Logi (follow)
	$(COMPOSE) logs -f

ps: ## Status usług
	$(COMPOSE) ps

console: ## Konsola Rails (backend)
	$(COMPOSE) exec backend bin/rails console

dbconsole: ## Konsola bazy (backend)
	$(COMPOSE) exec backend bin/rails dbconsole

migrate: ## Migracje bazy
	$(COMPOSE) exec backend bin/rails db:migrate

seed: ## Załaduj dane startowe
	$(COMPOSE) exec backend bin/rails db:seed

setup: ## Pierwsze uruchomienie: build + przygotowanie bazy
	$(COMPOSE) build
	$(COMPOSE) run --rm backend bin/rails db:prepare

bundle: ## Przeinstaluj gemy (backend)
	$(COMPOSE) run --rm backend bundle install

shell-backend: ## Powłoka w kontenerze backend
	$(COMPOSE) exec backend bash

attach-web: ## Powłoka w kontenerze web
	$(COMPOSE) exec web sh

test: ## Testy obu aplikacji
	$(COMPOSE) exec backend bin/rails test
	pnpm --filter web test:unit -- --run

lint: ## Lint obu aplikacji
	$(COMPOSE) exec backend bin/rubocop
	pnpm --filter web lint

fmt: ## Formatowanie frontu
	pnpm --filter web format
