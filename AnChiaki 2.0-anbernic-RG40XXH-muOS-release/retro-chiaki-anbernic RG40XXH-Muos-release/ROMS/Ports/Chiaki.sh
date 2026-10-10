#!/bin/bash
# PORTMASTER: chiaki, Chiaki.sh
#
# ---------------------------------------------------------------------------
# This is the ORIGINAL PortMaster launcher shipped by the port's own repository
# (packaging/portmaster/ROMS/Ports/Chiaki.sh), with exactly ONE change:
#
#   the SDL_GAMECONTROLLERCONFIG line.
#
# The upstream line maps guid 19000000010000000100000000010000 to the layout of
# the RG34XXSP. Measured on the RG40XX H with the port's own SDL2, the pad here
# reports the SAME GUID but a different button/axis layout, so the upstream
# line left SDL with no usable mapping:
#
#     SDL_IsGameController(0) = 0   -> no SDL_CONTROLLERBUTTONDOWN events
#
# i.e. gptokeyb had no game controller to translate, which is why no button ever
# worked. With the line below, verified on the device:
#
#     SDL_GameControllerAddMapping -> 1
#     isGameController = 1, gcName = muOS-Keys
#     axis order confirmed: rightx=a2 righty=a3 lefttrigger=a4 righttrigger=a5
#
# Everything else - LD_LIBRARY_PATH, LD_PRELOAD, the GL symlink, the display
# size logic, gptokeyb, the teardown - is left EXACTLY as upstream, because
# that combination is known to run on this hardware.
# ---------------------------------------------------------------------------

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/$directory/ports/chiaki"

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

cd "$GAMEDIR"

export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"
export LD_PRELOAD="$GAMEDIR/libs/libmaliegl.so"
export QT_PLUGIN_PATH="$GAMEDIR/libs/qt5/plugins"

# Point libGL.so.1 (as looked up in libs/ via LD_LIBRARY_PATH) at this
# device's own Mali GLESv2 driver instead of bundling a static copy in the
# release: a baked-in copy can't be produced by CI (it's a proprietary
# vendor blob, not available from any package or in this repo) and may not
# match every H700 unit's driver build anyway. Safe to always (re)create.
ln -sf /usr/lib/libGLESv2.so.2 "$GAMEDIR/libs/libGL.so.1" 2>/dev/null
export XKB_CONFIG_ROOT="$GAMEDIR/xkb"
export QT_XKB_CONFIG_ROOT="$GAMEDIR/xkb"
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_HIDECURSOR=0

# Detect the visible framebuffer size at runtime. virtual_size cannot be used
# for height because fbdev commonly reports two stacked buffers (for example
# 720x960 for a 720x480 panel).
SCREEN_WIDTH=""
SCREEN_HEIGHT=""
if [ -r /sys/class/graphics/fb0/modes ]; then
  SCREEN_MODE=$(head -n 1 /sys/class/graphics/fb0/modes)
  if [[ "$SCREEN_MODE" =~ ([0-9]+)x([0-9]+) ]]; then
    SCREEN_WIDTH="${BASH_REMATCH[1]}"
    SCREEN_HEIGHT="${BASH_REMATCH[2]}"
  fi
fi
if { [ -z "$SCREEN_WIDTH" ] || [ -z "$SCREEN_HEIGHT" ]; } && command -v fbset >/dev/null 2>&1; then
  read -r SCREEN_WIDTH SCREEN_HEIGHT < <(fbset -s 2>/dev/null | awk '/geometry/ { print $2, $3; exit }')
fi
SCREEN_WIDTH=${SCREEN_WIDTH:-640}
SCREEN_HEIGHT=${SCREEN_HEIGHT:-480}

export QT_QPA_EGLFS_WIDTH="$SCREEN_WIDTH"
export QT_QPA_EGLFS_HEIGHT="$SCREEN_HEIGHT"
export QT_QPA_EGLFS_DEPTH=16
export QT_OPENGL=es2
export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_QPA_GENERIC_PLUGINS=evdevkeyboard,evdevmouse
export QT_DEBUG_PLUGINS=1
export QT_LOGGING_RULES='qt.qpa.input.debug=true;qt.qpa.input.keymap.debug=true'
export QT_ENABLE_HIGHDPI_SCALING=0
# Describe the panel at a consistent 96 DPI so Qt point-sized text remains the
# same physical size across 720x480 and 640x480 displays.
export QT_QPA_EGLFS_PHYSICAL_WIDTH=$((SCREEN_WIDTH * 254 / 960))
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=$((SCREEN_HEIGHT * 254 / 960))
export MALI_WINDOW_WIDTH="$SCREEN_WIDTH"
export MALI_WINDOW_HEIGHT="$SCREEN_HEIGHT"
echo "Detected display: ${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
export SDL_AUDIODRIVER=alsa
# muOS stores its ALSA PipeWire plugin here (not the multiarch path ALSA guesses).
export ALSA_PLUGIN_DIR=/usr/lib/alsa-lib

# --- RG40XXH SDL gamepad mapping --------------------------------------------
# Verified physical button indices: L1=b4, R1=b5, L2=b10, R2=b11;
# analog axes a0-a3 remain unchanged.
# Same GUID as upstream, but the RG40XX H button/axis layout, verified on the
# device. Without a mapping SDL_IsGameController() is 0 and no button event is
# ever produced, so gptokeyb has nothing to act on.
export SDL_GAMECONTROLLERCONFIG="19000000010000000100000000010000,muOS-Keys,a:b0,b:b1,x:b3,y:b2,back:b8,guide:b6,start:b7,leftstick:b9,rightstick:b12,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b10,righttrigger:b11,platform:Linux,"

# gptokeyb2 uses PortMaster's interpose-enabled command and reads its SDL map
# from the explicit mapping file.
export SDL_GAMECONTROLLERCONFIG_FILE="$GAMEDIR/gamecontrollerdb.txt"
printf '%s\n' "$SDL_GAMECONTROLLERCONFIG" > "$SDL_GAMECONTROLLERCONFIG_FILE"

# Map physical M (b8) to BACK/Touchpad and Start (b7) to START/Options.
# Select (b6) maps to GUIDE; M + Start is the helper hotkey and Chiaki exit pair.
# Both Chiaki and gptokeyb2 use this mapping for the same exit combination.
CHIaki_MAPPING="$SDL_GAMECONTROLLERCONFIG"
GPTK_EXIT_MAPPING="19000000010000000100000000010000,muOS-Keys,a:b0,b:b1,x:b3,y:b2,back:b8,start:b7,guide:b6,leftstick:b9,rightstick:b12,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b10,righttrigger:b11,platform:Linux,"
printf '%s\n' "$GPTK_EXIT_MAPPING" > "$GAMEDIR/gamecontrollerdb-gptokeyb2-exit.txt"
if [ "${HOTKEY+x}" = x ]; then
  HOTKEY_WAS_SET=1
  OLD_HOTKEY="$HOTKEY"
else
  HOTKEY_WAS_SET=0
fi
export HOTKEY=back
export SDL_GAMECONTROLLERCONFIG="$GPTK_EXIT_MAPPING"
export SDL_GAMECONTROLLERCONFIG_FILE="$GAMEDIR/gamecontrollerdb-gptokeyb2-exit.txt"
echo "Exit combo: M/Menu (hotkey BACK, b8) + Start (START, b7)"
$GPTOKEYB2 "chiaki" -c "$GAMEDIR/chiaki-gptokeyb2.gptk" &
sleep 1

# Restore the controller mapping used by Chiaki itself.
export SDL_GAMECONTROLLERCONFIG="$CHIaki_MAPPING"
export SDL_GAMECONTROLLERCONFIG_FILE="$GAMEDIR/gamecontrollerdb.txt"
if [ "$HOTKEY_WAS_SET" = 1 ]; then
  export HOTKEY="$OLD_HOTKEY"
else
  unset HOTKEY
fi

# gptokeyb2 creates these uinput devices after it starts. Explicit paths
# avoid relying on Qt's device-discovery heuristics for the virtual devices.
KEYBOARD_NODE=""
MOUSE_NODE=""
for NAME_FILE in /sys/class/input/event*/device/name; do
  [ -r "$NAME_FILE" ] || continue
  IFS= read -r INPUT_NAME < "$NAME_FILE" || true
  EVENT_NAME=${NAME_FILE#/sys/class/input/}
  EVENT_NAME=${EVENT_NAME%%/*}
  case "$INPUT_NAME" in
    "Fake Keyboard Mouse") KEYBOARD_NODE="/dev/input/$EVENT_NAME" ;;
    "Fake Absolute Mouse") MOUSE_NODE="/dev/input/$EVENT_NAME" ;;
  esac
done
if [ -n "$KEYBOARD_NODE" ]; then
  export QT_QPA_EVDEV_KEYBOARD_PARAMETERS="$KEYBOARD_NODE"
  echo "Qt evdev keyboard device: $KEYBOARD_NODE (Fake Keyboard Mouse)"
else
  echo "WARNING: gptokeyb2 keyboard uinput device not found; Qt will use device discovery"
fi
if [ -n "$MOUSE_NODE" ]; then
  export QT_QPA_EVDEV_MOUSE_PARAMETERS="$MOUSE_NODE"
  echo "Qt evdev mouse device: $MOUSE_NODE"
else
  echo "WARNING: gptokeyb2 mouse uinput device not found; Qt will use device discovery"
fi
./chiaki
echo "chiaki exited: $?"

$ESUDO kill -9 $(pidof gptokeyb2) 2>/dev/null
$ESUDO systemctl restart oga_events 2>/dev/null &
printf "\033c" > /dev/tty0
