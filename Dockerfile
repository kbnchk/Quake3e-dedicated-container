FROM debian:bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ec-/Quake3e /src \
    && git -C /src checkout 2b375bd1e29a

WORKDIR /src

RUN make BUILD_CLIENT=0 BUILD_SERVER=1 -j"$(nproc)"

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends netcat-openbsd tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Europe/Moscow

WORKDIR /q3

COPY --from=builder /src/build/release-linux-x86_64/quake3e.ded.x64 /q3/quake3e.ded.x64
COPY server.cfg /q3/server.cfg
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /q3/quake3e.ded.x64 /entrypoint.sh

EXPOSE 27960/udp

ENTRYPOINT ["/entrypoint.sh"]
