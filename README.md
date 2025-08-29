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

## Multi-Host Notes
- Use per-host env files (examples: `.env.miniverse.sample`, `.env.ozdust.sample`) and copy to `.env` on each machine.
- Optionally set `COMPOSE_PROJECT_NAME` to namespace containers/networks per host.
- Both hosts can expose port 8010 independently; choose different ports only if a conflict exists on a given machine.
