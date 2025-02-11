#! /usr/bin/env nix-shell
#! nix-shell --pure --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq bkt

mower="${1:-0}"

. ./automower_env.sh

access_token="$(dash ./automower_login.sh)"

lock="${BKT_CACHE_DIR:-/tmp}/automower.lock"

flock "$lock" \
    bkt --discard-failures --ttl 60s --stale 50s --modtime "$lock" -- \
        curl --no-progress-meter -L 'https://api.amc.husqvarna.dev/v1/mowers' -H 'Authorization-Provider: husqvarna' -H "Authorization: Bearer $access_token" -H "X-Api-Key: $AUTOMOWER_CLIENTID" | jq ".data[$mower]"
