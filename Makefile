ELIXIR_VENDOR := ./deps

.PHONY: up dev down install npm-install build clean

up: $(ELIXIR_VENDOR)
	docker/compose build
	docker/compose up -d
	docker/node npm ci --prefix assets

dev: $(ELIXIR_VENDOR)
	docker/compose up -d db
	docker/elixir iex -S mix phx.server

down:
	docker-compose down

restart: down up

build-containers:
	docker/compose build

deps-get:
	docker/elixir mix local.hex --force
	docker/elixir mix deps.get

$(ELIXIR_VENDOR):
	$(MAKE) deps-get
