#! /usr/bin/env nix-shell
#! nix-shell --pure --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq bkt

data="$1"

. ./automower_env.sh

access_token="$(dash ./automower_login.sh)"

touch "${BKT_CACHE_DIR:-/tmp}/automower.lock"

id="$(dash ./id.sh)"
curl --no-progress-meter -X POST -H 'Authorization-Provider: husqvarna' -H "Authorization: Bearer $access_token" -H "X-Api-Key: $AUTOMOWER_CLIENTID" -d "$data" "https://api.amc.husqvarna.dev/v1/mowers/$id/actions"