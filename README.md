# macpipe
Ever tried to connect Airpods (or really any bluetooth headset) on Linux? I have, and it's a bad time. The problem is not that it does not work, it is that it (ime) only works _sometimes_.

The idea for this hack:
1. Airpods can be connected without any issues to an Apple device, e.g. iPhone.
2. Connect _all_ audio streams on Linux box to a virtual Pipewire device.
3. Stream the audio as an HLS stream with `ffmpeg`.
4. Create a stub website that serves the stream and visit it from the iOS device with headset connected.
5. Profit 🤪

This solution obviously has problems, most notably the fact that all audio is delayed by 2~10 sec so videos are going to be out of sync.
However, if you are only concerned about audio (which I am) it is actually surprisingly usable.

# TODO
* Improve HLS stream
* Fixup html and seperate script

# Related resources
* https://gist.github.com/CharlesHolbrow/8adfcf4915a9a6dd20b485228e16ead0
* https://github.com/dailymotion/hls.js
* http://underpop.online.fr/f/ffmpeg/help/hls-2.htm.gz
