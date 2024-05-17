#! /usr/bin/env nix-shell
#! nix-shell -i dash --pure -I channel:nixos-23.11-small -p curl cacert flock findutils dash jq 

val="$(dash ./data.sh | jq -r '.attributes.mower.activity')"
if [ "$val" = "STOPPED_IN_GARDEN" ]; then
    echo 1
else
    echo 0
fi
