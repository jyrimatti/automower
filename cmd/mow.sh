#! /usr/bin/env nix-shell
#! nix-shell -i dash --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq 

getset="${1:-}"
value="${4:-}"
if [ "$value" = "true" ] || [ "$value" = "1" ]; then
  value="1";
else
  value="0";
fi

. ./automower_env.sh
access_token="$(dash ./automower_login.sh)"

if [ "$getset" = "Set" ]; then
    id="$(dash ./id.sh)"
    if [ "$value" = "1" ]; then
        data='{ "data": {"type": "Start"} }'
    else
        data='{ "data": {"type": "Pause"} }'
    fi
    curl --no-progress-meter -X POST -H 'Authorization-Provider: husqvarna' -H "Authorization: Bearer $access_token" -H "X-Api-Key: $AUTOMOWER_CLIENTID" -d "$data" "https://api.amc.husqvarna.dev/v1/mowers/$id/actions"
else
    val="$(dash ./data.sh | jq -r '.attributes.mower.activity')"
    if [ "$val" = "MOWING" ]; then
        echo 1
    else
        echo 0
    fi
fi
