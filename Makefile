.PHONY: up down restart logs pull check-ports smoke

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f uptime-kuma

pull:
	docker compose pull && docker compose up -d

check-ports:
	bash scripts/check-ports.sh

smoke:
	bash scripts/smoke.sh
