#! /usr/bin/env nix-shell
#! nix-shell -i dash --pure --keep XDG_RUNTIME_DIR -I channel:nixos-23.11-small -p curl cacert flock findutils dash jq 

mower="${1:-0}"

. ./automower_env.sh
access_token="$(dash ./automower_login.sh)"

dash ./curl_cached.sh 'https://api.amc.husqvarna.dev/v1/mowers' -H 'Authorization-Provider: husqvarna' -H "Authorization: Bearer $access_token" -H "X-Api-Key: $AUTOMOWER_CLIENTID" | jq ".data[$mower]"
