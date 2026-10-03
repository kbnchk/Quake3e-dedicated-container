#!/bin/sh
set -eu

mkdir -p /q3/home/baseq3 /q3/baseq3

for pak in /mnt/paks/*.pk3; do
    ln -sf "$pak" "/q3/baseq3/$(basename "$pak")"
done

cp /q3/server.cfg /q3/home/baseq3/server.cfg

exec /q3/quake3e.ded.x64 \
    +set dedicated 1 \
    +set net_port 27960 \
    +set fs_basepath /q3 \
    +set fs_homepath /q3/home \
    +set rconPassword "${RCON_PASSWORD:-}" \
    +exec server.cfg
