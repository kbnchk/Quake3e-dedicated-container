# Quake3e dedicated server container

Container image with the [Quake3e](https://github.com/ec-/Quake3e) dedicated server engine (pinned commit `2b375bd1e29a`), built in a multi-stage Debian image. The server runs in LAN dedicated mode on UDP port 27960.

No game data is included. You must own Quake III Arena and mount your own `baseq3` pak files (retail `pak0.pk3` + 1.32 point release pk3s).

## Usage

See [docker-compose.example.yml](docker-compose.example.yml). Quick start:

1. Put your `baseq3` pak files somewhere on the host (e.g. `/opt/quake3/baseq3`).
2. Copy the example compose, adjust the `baseq3` path and `RCON_PASSWORD`.
3. Optionally mount your own `server.cfg` to `/config/server.cfg` — it overrides the default config baked into the image. All server settings (hostname, map rotation, limits) are changed there, no image rebuild needed.
4. `docker compose up -d`

## Configuration

| Mount | Purpose |
|---|---|
| `/mnt/paks` | `baseq3` pak files (read-only) |
| `/config/server.cfg` | Optional server config override (read-only) |

| Env | Default | Purpose |
|---|---|---|
| `RCON_PASSWORD` | empty | Remote console password |
| `TZ` | `Europe/Moscow` | Timezone |

## Health

The container healthcheck sends a UDP `getinfo` query to port 27960 and expects an `infoResponse`.
