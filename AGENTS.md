# Repository Guidelines

## Project Structure & Module Organization
- `docker-compose.yml`: Defines the `uptime-kuma` service using `louislam/uptime-kuma:latest`, maps host port `8010` to container `3001`, and mounts `./data:/app/data`.
- `data/`: Persistent application state (database, backups, certificates, uploads). Treat as important and back it up.
- `.vscode/`: Optional editor configuration for local development.

## Build, Test, and Development Commands
- `docker compose up -d`: Start Uptime Kuma in the background.
- `docker compose logs -f uptime-kuma`: Stream container logs for troubleshooting.
- `docker compose pull && docker compose up -d`: Update to the latest image and redeploy.
- `docker compose down`: Stop and remove the container (data persists).
- `docker compose exec uptime-kuma sh`: Open an interactive shell inside the container.
- `curl -sSf http://localhost:8010 > /dev/null`: Quick smoke test that the UI is reachable.

## Coding Style & Naming Conventions
- YAML: 2‑space indentation; quote port mappings (e.g., `"8010:3001"`).
- Service names: lowercase, hyphenated; `container_name` should match the service when added.
- Volumes: use repo‑relative paths (e.g., `./data:/app/data`) and avoid absolute host paths.

## Testing Guidelines
- Persistence check: create a monitor, run `docker compose restart`, confirm it remains after restart.
- Port/volume changes: run the curl smoke test and verify the login page loads on the expected port.
- This repo does not contain app unit tests (the app runs from the upstream image); focus on configuration validation.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `chore:` update image tag, `docs:` add backup notes).
- Include a concise description, rationale, and validation steps; add screenshots if UI behavior is relevant.
- Call out breaking changes (ports, paths, environment) and link related issues.
- For image updates, state tag before/after and, when possible, reference upstream release notes.

## Security & Configuration Tips
- Prefer pinning the image to a version (e.g., `louislam/uptime-kuma:1.23.0`) instead of `latest` for reproducibility.
- Back up `data/` regularly; it contains all configuration and monitoring history.
- Run behind a reverse proxy (TLS, auth) when exposed publicly; avoid publishing port `8010` to the internet directly.
- Optional: set timezone via `TZ` environment variable under the service (e.g., `TZ=UTC`).
