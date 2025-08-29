# Synology DSM Reverse Proxy (Uptime Kuma)

Use DSM 7.2.2 Control Panel → Login Portal → Advanced → Reverse Proxy.

## Which IP and Port?
- If the reverse proxy runs on the SAME host as Uptime Kuma:
  - Destination: Protocol HTTP, Hostname `127.0.0.1`, Port `8010` (or `8011`/`8012` for other instances)
- If the reverse proxy runs on a DIFFERENT host:
  - Destination: Protocol HTTP, Hostname = Kuma host IP, Port = exposed host port
    - Example (miniverse): `192.168.1.54:8010`
    - Example (ozdust): `192.168.1.36:8010`

Notes:
- Uptime Kuma serves HTTP on container port `3001`. We terminate TLS at DSM, so destination protocol remains HTTP.
- For multiple instances on one host, map each hostname to the proper port:
  - Instance A → 8010, Instance B → 8011, Instance C → 8012

## Example Rules
- status-miniverse.example.com → HTTP 127.0.0.1:8010 (if Kuma is on the same NAS)
- status.ozdust.me → HTTP 192.168.1.36:8010 (if Kuma is on a different machine)

## DSM Steps (GUI)
1) Control Panel → Login Portal → Advanced → Reverse Proxy → Create
2) Source:
   - Protocol: HTTPS
   - Hostname: your FQDN (e.g., `status.ozdust.me`)
   - Port: 443
3) Destination:
   - Protocol: HTTP
   - Hostname: `127.0.0.1` or the Kuma host IP
   - Port: `8010` (or `8011`/`8012`)
4) Custom headers:
   - Enable WebSocket (toggle on)
5) Certificate:
   - Control Panel → Security → Certificate → ensure the FQDN uses the correct certificate
6) Save and test your URL.

## Troubleshooting
- 404/Bad Gateway: Verify the destination IP/port and that Kuma is running (`docker compose ps`).
- Web UI not loading fully: Ensure WebSocket is enabled on the reverse proxy rule.
- Port conflicts: Run `make check-ports` or `scripts/check-port.sh 8010`.
