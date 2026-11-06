
default:
    @just --list

uplt-bump:
    cd upstream-libtorrent && git pull

worklt-recreate:
    rm -rf work-libtorrent || true
    git clone upstream-libtorrent work-libtorrent
    cd work-libtorrent && git switch -c xpbranch
    cd work-libtorrent && stg import --series ../libtorrent.series

worklt-export:
    rm -r work-ltexport || true
    cd work-libtorrent && stg export \
        --dir ../work-ltexport \
        --patch
    mv work-ltexport/*.patch .
    mv work-ltexport/series libtorrent.series
    rm -r work-ltexport

# to extract commit
# git format-patch HEAD^^^
# git apply
