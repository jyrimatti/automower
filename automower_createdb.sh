#! /usr/bin/env nix-shell
#! nix-shell --pure -i dash -I channel:nixos-23.11-small -p dash sqlite
set -eu

sqlite3 automower.db < automower_create.sql