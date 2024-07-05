#! /usr/bin/env nix-shell
#! nix-shell -i dash --pure --keep CREDENTIALS_DIRECTORY --keep XDG_RUNTIME_DIR -I channel:nixos-23.11-small -p curl cacert flock findutils dash jq 

data="$(dash ./data.sh)"
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