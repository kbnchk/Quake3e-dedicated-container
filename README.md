# Quake3e dedicated server container

Container image with the [Quake3e](https://github.com/ec-/Quake3e) dedicated server engine (upstream release tag pinned in `QUAKE3E_REF`, bumped by a weekly PR), built in a multi-stage Debian image. The server runs in LAN dedicated mode on UDP port 27960.

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

## Image tags and versioning

- The engine version is the upstream release tag in `QUAKE3E_REF` (e.g. `2026-10-14`). A weekly workflow opens a PR when a newer release appears; merging it to `main` rebuilds the image.
- Published to `ghcr.io/kbnchk/quake3e` as `:<release tag>` and `:latest`. Only the 2 newest image versions are kept in the registry; older ones are deleted automatically.
- Local build: `docker build -t quake3e .` (uses the ref from `QUAKE3E_REF`).

## Helm chart

The chart lives in [helm/quake3e](helm/quake3e) and is published as an OCI artifact on every change under `helm/`:

```
helm install quake3e oci://ghcr.io/kbnchk/charts/quake3e --version 0.1.0 \
  --set rcon.password=... --set paks.hostPath=/opt/quake3/baseq3
```

The image tag defaults to the chart `appVersion` (kept in sync with `QUAKE3E_REF` by the weekly bump PR). Bump the chart `version` in `Chart.yaml` manually when the chart itself changes. See `helm/quake3e/values.yaml` for options.
