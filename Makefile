.PHONY: up down restart logs pull check-ports smoke backup restore

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

# Create a tar.gz backup of the named volume into ./backups (BACKUP overrides name)
backup:
	mkdir -p backups
	docker run --rm -v kuma-data:/data -v "$(PWD)/backups:/backup" busybox sh -c "cd /data && tar -czf /backup/${BACKUP:-kuma-data.$(shell date +%Y%m%d-%H%M%S).tgz} ."

# Restore from a tar.gz in ./backups (use: make restore BACKUP=path/to.tgz)
restore:
	@if [ -z "$(BACKUP)" ]; then echo "Usage: make restore BACKUP=backups/<file>.tgz"; exit 2; fi
	docker run --rm -v kuma-data:/data -v "$(PWD):/work" busybox sh -c "cd /data && tar -xzf /work/$(BACKUP)"
