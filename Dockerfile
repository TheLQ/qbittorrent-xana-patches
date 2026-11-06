FROM octo-docker-regxana:5120/xana/octobase

# Common build deps
RUN set -e -x && \
    # --no-install-recommends because sqlite?
    #  qt.sql.qsqldatabase: QSqlDatabase: can not load requested driver 'QSQLITE'
    apt-get install -y \
        # core
        build-essential \
        cmake \
        git \
        ninja-build \
        # libtorrent
        libboost-dev \
        libssl-dev \
        # qbittorrent
        qt6-tools-dev \
        qt6-base-dev \
        qt6-base-private-dev \
        qt6-svg-dev \
        zlib1g-dev \
        && \
    apt-get clean
    # pkg-config 

ADD libtorrent /work/libtorrent
RUN set -e -x && \
    cd /work/libtorrent && \
    rm -r build || true && \
    cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr/local -G Ninja && \
    cd build && \
    ninja && \
    ninja install

# qbittorrent
ADD qBittorrent /work/qBittorrent
RUN set -e -x && \
    cd /work/qBittorrent && \
    rm -r build src/base/version.h  || true && \
    cmake -B build -G "Ninja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DWEBUI=ON -DGUI=OFF -DTESTING=OFF && \
    cmake --build build

RUN set -e -x && \
    ls /work/qBittorrent/build