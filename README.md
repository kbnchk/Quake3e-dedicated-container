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
| `/mnt/mod` | Optional mod directory, e.g. CPMA (read-only) — top-level entries are symlinked into `/q3/$FS_GAME` |
| `/config/server.cfg` | Optional server config override (read-only) |

| Env | Default | Purpose |
|---|---|---|
| `RCON_PASSWORD` | empty | Remote console password |
| `TZ` | `Europe/Moscow` | Timezone |
| `FS_GAME` | `baseq3` | Mod directory name (`fs_game`). With `baseq3` the `fs_game` argument is omitted |

## Mods (CPMA example)

The image contains no mod data. Download the mod yourself (e.g. official CPMA from `cdn.playmorepromode.com`), extract it on the host and mount it:

```yaml
environment:
  FS_GAME: cpma
volumes:
  - /opt/quake3/baseq3:/mnt/paks:ro
  - /opt/quake3/cpma:/mnt/mod:ro
```

The mounted `server.cfg` is placed into the mod's home directory, so it is exec'd with CPMA cvars (`server_gameplay`, etc.). Extra maps (e.g. the official CPMA mappack `map_*.pk3`) go into `baseq3` alongside the paks — clients need them installed locally too.

## Health

The container healthcheck sends a UDP `getinfo` query to port 27960 and expects an `infoResponse`.
