
default:
    @just --list

uplt-bump:
    cd upstream-libtorrent && git pull

worklt-recreate:
    rm -rf work-libtorrent || true
    git clone upstream-libtorrent work-libtorrent
    cd work-libtorrent && git switch -c xpbranch
    cd work-libtorrent && stg import --series ../libtorrent.series --stripname

worklt-export:
    rm -r work-ltexport || true
    cd work-libtorrent && stg export \
        --dir ../work-ltexport \
        --patch
    mv work-ltexport/*.patch .
    mv work-ltexport/series libtorrent.series
    rm -r work-ltexport

#

workqb-recreate:
    rm -rf work-qbittorrent || true
    git clone qBittorrent work-qbittorrent
    cd work-qbittorrent && git checkout '0c17d91d6326f86e0de0df02651bfa135530ec60'
    cd work-qbittorrent && git switch -c xpbranch
    cd work-qbittorrent && stg import --series ../qbittorrent.series --stripname

# to extract commit
# git format-patch HEAD^^^
# git apply
