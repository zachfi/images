FROM  alpine:3.17

RUN   adduser -S -D -H -h /xmrig miner

RUN apk add git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev
RUN git clone https://github.com/xmrig/xmrig.git
RUN mkdir xmrig/build && cd xmrig/build && cmake .. && make -j4

USER miner
WORKDIR    /xmrig/build
ENTRYPOINT  ["./xmrig"]
