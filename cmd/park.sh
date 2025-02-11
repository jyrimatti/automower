#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq bkt

minutes="${1:-}"
getset="${2:-}"
value="${5:-}"
if [ "$value" = "true" ] || [ "$value" = "1" ]; then
  value="1";
else
  value="0";
fi

if [ "$getset" = "Set" ]; then
    if [ "$value" = "1" ]; then
        if [ "$minutes" = "" ]; then
            dash ./automower_set.sh '{ "data": {"type": "Park", "attributes": {"duration": '"$minutes"'}} }'
        else
            dash ./automower_set.sh '{ "data": {"type": "ParkUntilFurtherNotice"} }'
        fi
    else
        dash ./automower_set.sh '{ "data": {"type": "ResumeSchedule"} }'
    fi
else
    val="$(dash ./automower_get.sh | jq -r '.attributes.mower.activity')"
    if [ "$val" = "PARKED_IN_CS" ]; then
        echo 1
    else
        echo 0
    fi
fi
