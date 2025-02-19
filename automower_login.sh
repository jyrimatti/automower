#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p coreutils curl cacert flock findutils dash jq bkt
set -eu

. ./automower_env.sh

lock="${BKT_CACHE_DIR:-/tmp}/automower-login.lock"
if [ ! -f "$lock" ]; then
    echo 0 > "$lock"
fi

expires="$(date --utc --date="now +$(cat "$lock") seconds" +%s)"
now="$(date --utc --date="now +1 minute" +%s)"

if [ "$expires" -lt "$now" ]; then
    touch "$lock"
fi

flock "$lock" \
    bkt --discard-failures --ttl 24h --modtime "$lock" -- \
        curl --no-progress-meter -X POST -d "grant_type=client_credentials&client_id=${AUTOMOWER_CLIENTID}&client_secret=${AUTOMOWER_CLIENTSECRET}" https://api.authentication.husqvarnagroup.dev/v1/oauth2/token \
            | jq -r '[.expires_in,.access_token] | @tsv' \
            | {
                read -r expires_in access_token
                if [ -z "$access_token" ]; then
                    exit 1
                fi
                echo "$expires_in" > "$lock"
                echo "$access_token"
            }
