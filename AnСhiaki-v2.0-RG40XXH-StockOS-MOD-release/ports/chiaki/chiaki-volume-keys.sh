#!/bin/sh
set -eu
DEVICE=${1:?usage: chiaki-volume-keys.sh /dev/input/eventN}
exec evtest "$DEVICE" 2>/dev/null | while IFS= read -r event; do
  case "$event" in
    *"KEY_VOLUMEUP), value 1"*)
      amixer -q sset "lineout volume" 1+ || echo "ERROR: failed to increase lineout volume" >&2
      ;;
    *"KEY_VOLUMEDOWN), value 1"*)
      amixer -q sset "lineout volume" 1- || echo "ERROR: failed to decrease lineout volume" >&2
      ;;
  esac
done
