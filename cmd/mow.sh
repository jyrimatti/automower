#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq bkt

getset="${1:-}"
value="${4:-}"
if [ "$value" = "true" ] || [ "$value" = "1" ]; then
  value="1";
else
  value="0";
fi

if [ "$getset" = "Set" ]; then
    if [ "$value" = "1" ]; then
        dash ./automower_set.sh '{ "data": {"type": "Start"} }'
    else
        dash ./automower_set.sh '{ "data": {"type": "Pause"} }'
    fi
else
    val="$(dash ./automower_get.sh | jq -r '.attributes.mower.activity')"
    if [ "$val" = "MOWING" ]; then
        echo 1
    else
        echo 0
    fi
fi
