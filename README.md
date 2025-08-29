# Uptime Kuma (Docker Compose)

This repository provides a minimal Docker Compose setup for running Uptime Kuma with persistent data and clear contributor guidelines.

## Contributing
- Read AGENTS.md for project structure, commands, coding conventions, testing checks, and PR expectations.
- When changing the Docker image, pin versions for reproducibility (see docker-compose.yml comments). You can override the image tag via `.env` using `KUMA_TAG`.

## Quick Start
- Start: `docker compose up -d`
- Update image and redeploy: `docker compose pull && docker compose up -d`
- Logs: `docker compose logs -f uptime-kuma`

Data persists in `./data`. Exposes the UI on `http://localhost:8010`.
