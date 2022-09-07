#!/usr/bin/env bash
PORT=9888
RUN_DIR=/tmp/macpipe
PIPEWIRE_DEV=/tmp/virtualspeaker

die(){ printf "$1\n" >&2 ; exit 1; }
info(){ printf "\033[34m!>\033[0m $1\n" >&2; }

#==============================================================================#

case "$1" in
start)
  info "Starting ffmpeg..."
  ffmpeg -re -sample_rate 44100  -f s16le -channels 2 \
    -i $PIPEWIRE_DEV -f hls \
    -hls_allow_cache 0 \
    -hls_time 2 \
    -hls_list_size 4 \
    -hls_delete_threshold 1 \
    -hls_flags delete_segments \
    -hls_start_number_source datetime \
    -preset superfast \
    -start_number 10 \
    ./stream.m3u8


  info "Starting HTTP server on 0.0.0.0:$PORT..."
  mkdir -p $RUN_DIR
  setsid -f http-server -c-1 $RUN_DIR -p$PORT &> /dev/null # Disable caching
;;
stop)
  pkill -x ffmpeg
  pkill -x http-server
;;
*)
  die "usage: $(basename $0) <start|stop>"
;;

esac
