#! /usr/bin/env nix-shell
#! nix-shell -i dash --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -I channel:nixos-23.11-small -p curl cacert flock findutils dash jq 

val="$(dash ./data.sh | jq -r '.attributes.mower.activity')"
if [ "$val" = "CHARGING" ]; then
    echo 1
else
    echo 0
fi
