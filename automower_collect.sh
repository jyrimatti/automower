#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -i dash -I channel:nixos-23.11-small -p nix dash coreutils gnused curl cacert flock bc jq
set -eu

stamp="$(date +%s)"

data="$(dash ./data.sh)"

echo "$data" | jq -r '.attributes.battery.batteryPercent' | { read -r d; echo "[$stamp,$d]"; } | dash ./automower_convert.sh "battery"
echo "$data" | jq -r 'if .attributes.metadata.connected then 1 else 0 end' | { read -r d; echo "[$stamp,$d]"; } | dash ./automower_convert.sh "connected"
echo "$data" | jq -r '.attributes.positions | last | [.latitude, .longitude] | @tsv' | {
    read -r lat lon;
    echo "INSERT INTO position SELECT $stamp, $lat, $lon WHERE ($lat,$lon) <> (SELECT COALESCE(MIN(latitude),0), COALESCE(MIN(longitude),0) FROM position WHERE instant = (SELECT MAX(instant) FROM position));";
} | dash ./automower_convert.sh "connected"

for x in numberOfChargingCycles\
         numberOfCollisions\
         totalChargingTime\
         totalCuttingTime\
         totalDriveDistance\
         totalRunningTime\
         totalSearchingTime\
    ; do
echo "$data" | jq -r ".attributes.statistics.$x" | { read -r d; echo "[$stamp,$d]"; } | dash ./automower_convert.sh "$x"
done
