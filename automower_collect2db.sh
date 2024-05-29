#! /usr/bin/env nix-shell
#! nix-shell --pure --keep LD_LIBRARY_PATH -i dash -I channel:nixos-23.11-small -p nix dash sqlite coreutils gnused curl cacert flock bc jq
set -eu

export LC_ALL=C # "fix" Nix Perl locale warnings

dash ./automower_collect.sh | sqlite3 -cmd ".timeout 90000" ./automower.db
