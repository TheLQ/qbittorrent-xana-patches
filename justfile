rejust := just_executable() + " --justfile " + justfile()

default:
    {{ rejust }} --list

uplt-bump:
    cd upstream-libtorrent && {{ rejust }} _require_branch RC_2_0
    cd upstream-libtorrent && git pull
    git submodule update --init --recursive

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

qb-bump:
    cd upstream-qbittorrent && {{ rejust }} _require_branch master
    cd upstream-qbittorrent && git pull 
    git submodule update --init --recursive

qb-recreate:
    rm -rf work-qbittorrent || true
    git clone upstream-qbittorrent work-qbittorrent
    cd work-qbittorrent && git switch -c xpbranch
    cd work-qbittorrent && stg import --series ../qbittorrent.series --stripname

qb-series:
    cd work-qbittorrent && stg series

qb-status:
    cd work-qbittorrent && stg status

qb-write-patch name:
    rm -r work-qbittorrent/patches-xpbranch || true
    cd work-qbittorrent && stg export {{ name }}
    ls work-qbittorrent/patches-xpbranch
    cp work-qbittorrent/patches-xpbranch/{{ name }} {{ name }}.patch
    rm -r work-qbittorrent/patches-xpbranch
    git diff {{ name }}.patch

qb-last-drop:
    cd work-qbittorrent && stg series
    cd work-qbittorrent && stg delete $(stg top)
    cd work-qbittorrent && stg series

qb-last-show:
    cd work-qbittorrent && stg series
    cd work-qbittorrent && stg show $(stg top)

qb-rename from to:
    cd work-qbittorrent && stg rename {{ from }} {{ to }} 

qb-show patch:
    cd work-qbittorrent && stg show {{ patch }}

qb-squash to_update update_with message:
    cd work-qbittorrent && stg squash \
        --name={{ to_update }} \
        '--message={{ message }}' \
        {{ to_update }} {{ update_with }} 
    cd work-qbittorrent && stg series

# qb-import-from-git qb-serialize-array-1webui ../qbup/qBittorrent 565044244d64b21a65138b37455344c8f528a3f0
qb-import-from-git patch fromdir commit:
    cd '{{ fromdir }}' && git format-patch -1 {{ commit }} --stdout > '{{ justfile_directory() }}/tmp.patch'   
    cd work-qbittorrent && stg import ../tmp.patch
    rm tmp.patch
    cd work-qbittorrent && stg rename $(stg top) {{ patch }}
    {{ rejust }} qb-write-patch {{ patch }}

qb-export:
    rm -r work-qbexport || true
    cd work-qbittorrent && stg export \
        --dir ../work-qbexport \
        --patch
    mv work-qbexport/*.patch .
    mv work-qbexport/series qbittorrent.series
    rm -r work-qbexport
    sed -i -E 's/^index [0-9a-f]+\.\.[0-9a-f]+/index 000000..000000/' qb-*.patch

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
