# Uptime Kuma (Docker Compose)

This repository provides a minimal Docker Compose setup for running Uptime Kuma with persistent data and clear contributor guidelines.

## Contributing
- Read AGENTS.md for project structure, commands, coding conventions, testing checks, and PR expectations.
- When changing the Docker image, pin versions for reproducibility (see docker-compose.yml comments). You can override the image tag via `.env` using `KUMA_TAG`.

## Quick Start
- Copy env: `cp .env.sample .env` (adjust `KUMA_TAG` and `KUMA_HOST_PORT` as needed)
- Start: `docker compose up -d`
- Update image and redeploy: `docker compose pull && docker compose up -d`
- Logs: `docker compose logs -f uptime-kuma`

Data persists in `./data`. Exposes the UI on `http://localhost:${KUMA_HOST_PORT:-8010}`.

## Multi-Client Setup
- Option 1 (recommended): Single Kuma instance with Tags per client and multiple Status Pages. Import monitors via Settings → Import/Export using `monitors.template.json` as a starting point.
- Option 2: Multiple Kuma instances for isolation. Enable `docker-compose.override.yml` and set per-instance ports in `.env` (`KUMA_HOST_PORT_A=8010`, `KUMA_HOST_PORT_B=8011`, ...). Each instance must use a unique data folder (e.g., `./data-a`, `./data-b`).

## Import Example
- Use `monitors.template.json` as a template. Replace example domains with your endpoints (e.g., `https://tv.ozdust.me`, `https://jellyfin.ozdust.synology.me`, etc.).
- In Uptime Kuma: Settings → Import/Export → Import, and select the JSON file.

## Generate Import from CSV
- Prepare a CSV with header: `name,url,tag,interval`.
- Generate JSON: `python3 scripts/gen_kuma_import.py monitors.ozdust.csv monitors.ozdust.json` (or for miniverse).
- Import the resulting JSON in Uptime Kuma (Settings → Import/Export).

## Systemd (optional)
- Edit `systemd/uptime-kuma.service` and set `WorkingDirectory` to your repo path; then:
  - `sudo cp systemd/uptime-kuma.service /etc/systemd/system/`
  - `sudo systemctl daemon-reload && sudo systemctl enable --now uptime-kuma`
- For multi-instance with override: use the templated unit `systemd/uptime-kuma-multi@.service`:
  - `sudo cp systemd/uptime-kuma-multi@.service /etc/systemd/system/`
  - `sudo systemctl daemon-reload && sudo systemctl enable --now uptime-kuma-multi@a`

## Reverse Proxy Notes
- Nginx examples for ports 8010/8011/8012 in `docs/reverse-proxy/`.
- Caddy examples provided; Caddy can handle TLS automatically with public DNS.
- Ensure upstream points to the correct localhost port for each instance.

## Multi-Host Notes
- Use per-host env files (examples: `.env.miniverse.sample`, `.env.ozdust.sample`) and copy to `.env` on each machine.
- Optionally set `COMPOSE_PROJECT_NAME` to namespace containers/networks per host.
- Both hosts can expose port 8010 independently; choose different ports only if a conflict exists on a given machine.
