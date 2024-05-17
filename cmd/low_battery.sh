#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.11-small -p jq nix dash flock
set -eu

ret="$(dash ./data.sh | jq -r '.attributes.battery.batteryPercent')"
if [ "$ret" -lt 10 ]; then
    echo 1
else
    echo 0
fi
