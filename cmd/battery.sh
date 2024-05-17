#! /usr/bin/env nix-shell
#! nix-shell -i dash --pure -I channel:nixos-23.11-small -p curl cacert flock findutils dash jq 

dash ./data.sh | jq -r '.attributes.battery.batteryPercent'
