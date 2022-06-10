.PHONY: default install help logs

.DEFAULT_GOAL := help
TTY = 
ifeq ($(OS),Windows_NT)
	TTY = winpty
endif

USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)

PWD = $(shell pwd)
export UID = $(USER_ID)
export GID = $(GROUP_ID)
export NODE_ENV ?= development
export GOMAXPROCS = $(shell nproc)

DOCKER_COMPOSE = $(TTY) docker-compose -f docker-compose.yml

ifeq "${CI}" "true"
	DOCKER_COMPOSE_RUN = $(TTY) docker-compose -f docker-compose.yml run --rm --no-deps -T
else
	DOCKER_COMPOSE_RUN = docker-compose -f docker-compose.yml run --rm --no-deps
endif

infos :
	ifeq ($(OS),Windows_NT)
		@echo "Windows"
	else
		@echo "Linux"
	endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-35s\033[0m %s\n", $$1, $$2}'

# =====================================================================
# Docker recipes - running dev. environment with Docker ===============
# =====================================================================

install: ## Install all deps
	$(DOCKER_COMPOSE_RUN) node ash -ci 'git config --global http.sslVerify false  && yarn config set "strict-ssl" false -g && yarn install'

start: ## Run ALL the services in development mode
	$(DOCKER_COMPOSE) up -d

stop: ## Stop the application in development mode
	$(DOCKER_COMPOSE) down

run-lint: ## Check linting
	$(DOCKER_COMPOSE_RUN) node ash -ci 'cd /usr/src && npm run lint'

logs: ## Display logs for all services
	$(DOCKER_COMPOSE) logs -f