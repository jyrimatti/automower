#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash  -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq bkt

val="$(dash ./automower_get.sh | jq -r '.attributes.mower.activity')"
if [ "$val" = "LEAVING" ]; then
    echo 1
else
    echo 0
fi
