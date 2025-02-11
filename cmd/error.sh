#! /usr/bin/env nix-shell
#! nix-shell --pure --keep CREDENTIALS_DIRECTORY --keep BKT_SCOPE --keep BKT_CACHE_DIR
#! nix-shell -i dash -I channel:nixos-24.11-small -p curl cacert flock findutils dash jq bkt

data="$(dash ./automower_get.sh)"
echo "$data"\
  | jq -r '[.attributes.mower.state, .attributes.metadata.connected] | @tsv'\
  | { 
      read -r state connected
      if [ "$state" != "IN_OPERATION" ] && [ "$state" != "OFF" ]; then
          echo 1
      elif [ "$connected" = "false" ]; then
          echo 1
      else
          echo 0
      fi
  }