#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.11-small -p rsync sqlite openssh
set -eu

remoteuser=$1
remotehost=$2
remotefile=$3

{
    echo 'PRAGMA locking_mode = EXCLUSIVE;'
    echo 'BEGIN EXCLUSIVE;'
    rsync -avzq --bwlimit=1000 -e "ssh -qo StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ./automower.db "$remoteuser@$remotehost:$remotefile" 1>&2
    echo 'COMMIT;'
    echo '.quit'
} | sqlite3 ./automower.db
