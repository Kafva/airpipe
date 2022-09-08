// Adapted from:
//  https://gist.github.com/CharlesHolbrow/8adfcf4915a9a6dd20b485228e16ead0

const URL = '/stream.m3u8'; // .m3u8 ~ UTF8 m3u playlist
const AUDIO = document.querySelector("audio");

const log = (...args) => {
  console.log("%c DEBUG ", 'background: #2b71e0; color: #f5e4f3', ...args)
}

const err = (...args) => {
  console.log("%c ERROR ", 'background: #ed493e; color: #f5e4f3', ...args)
}

window.onload = () => {

  if (Hls.isSupported()) {
    let player = new Hls();
    player.attachMedia(AUDIO);

    player.on(Hls.Events.MEDIA_ATTACHED, () => {
        log('Attaching player to audio element');
        player.loadSource(URL);
        player.on(Hls.Events.MANIFEST_PARSED, (_, data) => {
            log(`Manifest loaded with ${data.levels.length} quality level(s)`);
            AUDIO.play();
        });
    });

    player.on(Hls.Events.ERROR, (_, data) => err(data));

  } else {
    err("No HLS support!")
  }
}


