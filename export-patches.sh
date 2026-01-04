#!/bin/bash
set -x
cd qBittorrent
exec stg export -d .. --patch --numbered
