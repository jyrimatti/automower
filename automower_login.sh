#! /usr/bin/env nix-shell
#! nix-shell --pure --keep LD_LIBRARY_PATH --keep XDG_RUNTIME_DIR -i dash -I channel:nixos-23.11-small -p curl cacert flock findutils dash jq
set -eu

. ./automower_env.sh

outputfile="${XDG_RUNTIME_DIR:-/tmp}/$(basename "$PWD")/access_token"
test -e "$(dirname "$outputfile")" || mkdir -p "$(dirname "$outputfile")"

(
    flock 8

    login() {
        curl --no-progress-meter -X POST -d "grant_type=client_credentials&client_id=${AUTOMOWER_CLIENTID}&client_secret=${AUTOMOWER_CLIENTSECRET}" https://api.authentication.husqvarnagroup.dev/v1/oauth2/token\
            | jq -r '.access_token,.expires_in'\
            | {
                read -r access_token
                echo "$access_token" > "$outputfile"
                read -r expires_in
                echo "$expires_in" > "$outputfile.expires_in"
            }
    }

    if [ ! -f "$outputfile" ] || [ ! -s "$outputfile" ]; then
        login
    else
        for i in $(find "$outputfile" -mmin +$(($(cat "$outputfile.expires_in") / 60 - 10))); do
            login
        done
    fi
) 8> "$outputfile.lock"

cat "$outputfile"
