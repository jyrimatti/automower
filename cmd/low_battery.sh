#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p jq nix dash flock bkt
set -eu

ret="$(dash ./automower_get.sh | jq -r '.attributes.battery.batteryPercent')"
if [ "$ret" -lt 10 ]; then
    echo 1
else
    echo 0
fi
