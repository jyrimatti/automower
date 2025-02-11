#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p nix dash sqlite coreutils gnused curl cacert flock bc jq bkt
set -eu

export LC_ALL=C # "fix" Nix Perl locale warnings

dash ./automower_collect.sh | sqlite3 -cmd ".timeout 90000" ./automower.db
