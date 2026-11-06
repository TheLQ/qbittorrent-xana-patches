rejust := just_executable() + " --justfile " + justfile()

default:
    {{ rejust }} --list

uplt-bump:
    cd upstream-libtorrent && {{ rejust }} _require_branch RC_2_0
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

upqb-bump:
    cd upstream-qbittorrent && {{ rejust }} _require_branch master
    cd upstream-qbittorrent && git pull

workqb-recreate:
    rm -rf work-qbittorrent || true
    git clone upstream-qbittorrent work-qbittorrent
    cd work-qbittorrent && git switch -c xpbranch
    cd work-qbittorrent && stg import --series ../qbittorrent.series --stripname

#

[no-cd]
_require_branch branch:
    #!/usr/bin/env bash
    branch=$(git branch --show-current)
    if [ "$branch" != "{{ branch }}" ]; then
        echo "error: on branch '${branch:-detached HEAD}', must be on {{ branch }}" >&2
        exit 1
    else
        echo "on branch {{ branch }}"
    fi

# to extract commit
# git format-patch HEAD^^^
# git apply
