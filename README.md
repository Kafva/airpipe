# macpipe
> http://underpop.online.fr/f/ffmpeg/help/hls-2.htm.gz
HLS (Apple HTTP Livestreaming) is MUXer for livestreaming over HTTP which splits media into
.tmp files and creates a playlist.

```bash
# Create a HLS stream
ffmpeg -re -sample_rate 44100  -f s16le -channels 2  -i /tmp/virtualspeaker -f hls \
  -hls_allow_cache 0 \
  -hls_time 2 \
  -hls_list_size 4 \
  -hls_delete_threshold 1 \
  -hls_flags delete_segments \
  -hls_start_number_source datetime \
  -preset superfast \
  -start_number 10 \
  ./stream.m3u8

# Host a website that embeds the stream 
#   https://gist.github.com/CharlesHolbrow/8adfcf4915a9a6dd20b485228e16ead0
#   https://github.com/dailymotion/hls.js
http-server -c-1 . -p7777


# Visit the website on iOS
# This kiiiiiiiiiiiiiiinda works but is super delayed, maybe we can make the HLS seek
# further ahead with a shell hack hook during playerctl command

# The audio controls work but are also super delayed.

#== TODO ==#
# We would want to store audio.tmp files in RAM
# Restart stream on playerctl or volume event if we cant get syncing
# Force pipewire to redirect ALL audio to virtualspeaker

```

