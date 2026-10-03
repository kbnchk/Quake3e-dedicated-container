#!/bin/sh
set -eu

FS_GAME="${FS_GAME:-baseq3}"

mkdir -p "/q3/home/$FS_GAME" /q3/baseq3

for pak in /mnt/paks/*.pk3; do
    ln -sf "$pak" "/q3/baseq3/$(basename "$pak")"
done

# Optional mod files (e.g. CPMA): mount the mod directory at /mnt/mod and set
# FS_GAME to the mod name (e.g. cpma). Top-level entries are symlinked into
# /q3/$FS_GAME so the engine picks them up.
if [ -d /mnt/mod ]; then
    mkdir -p "/q3/$FS_GAME"
    for f in /mnt/mod/*; do
        ln -sf "$f" "/q3/$FS_GAME/$(basename "$f")"
    done
fi

if [ -f /config/server.cfg ]; then
    cp /config/server.cfg "/q3/home/$FS_GAME/server.cfg"
else
    cp /q3/server.cfg "/q3/home/$FS_GAME/server.cfg"
fi

set -- /q3/quake3e.ded.x64 \
    +set dedicated 1 \
    +set net_port 27960 \
    +set fs_basepath /q3 \
    +set fs_homepath /q3/home

if [ "$FS_GAME" != "baseq3" ]; then
    set -- "$@" +set fs_game "$FS_GAME"
fi

set -- "$@" \
    +set rconPassword "${RCON_PASSWORD:-}" \
    +exec server.cfg

exec "$@"
