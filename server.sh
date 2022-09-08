#!/usr/bin/env bash
PORT=9888
RUN_DIR=/tmp/macpipe
PIPEWIRE_DEV=/tmp/virtualspeaker
VIRTUAL_NAME=VirtualSpeaker

die(){ printf "$1\n" >&2 ; exit 1; }
info(){ printf "\033[34m!>\033[0m $1\n" >&2; }
check_dep(){ which "$1" &> /dev/null || die "Missing '$1'" ; }

#==============================================================================#
check_dep http-server
check_dep ffmpeg

case "$1" in
setup)
  # Install virtual device configuration
  sudo cp -v virtual.conf /etc/pipewire/pipewire.conf.d/virtual.conf

  # Set the VirtualSpeaker as the default output
  wpctl inspect @DEFAULT_AUDIO_SINK@|grep -q "node.name = \"$VIRTUAL_NAME\"" &&
    die "Already set as default: $VIRTUAL_NAME"

  SINK=$(wpctl status|sed -nE "s/[^0-9]*([0-9]+\.)\s+$VIRTUAL_NAME.*/\1/p")
  [ -z "$SINK" ] && 
    die "Can't find virtual sink: $VIRTUAL_NAME"
  wpctl set-default $SINK
;;
start)
  mkdir -p $RUN_DIR
  cp -v index.{html,js} $RUN_DIR
  cd $RUN_DIR

  setsid -f ffmpeg -re -sample_rate 44100  -f s16le -channels 2 \
    -i $PIPEWIRE_DEV -f hls \
    -hls_allow_cache 0 \
    -hls_time 2 \
    -hls_list_size 4 \
    -hls_delete_threshold 1 \
    -hls_flags delete_segments \
    -hls_start_number_source datetime \
    -preset superfast \
    -start_number 10 \
    ./stream.m3u8 &> $RUN_DIR/ffmpeg.log
  info "Started ffmpeg"

  setsid -f http-server -c-1 . -p$PORT &> /dev/null # Disable caching
  info "Started HTTP server on 0.0.0.0:$PORT..."
;;
stop)
  pkill -x ffmpeg
  pkill -x http-server
;;
*)
  die "usage: $(basename $0) <setup|start|stop>"
;;
esac
