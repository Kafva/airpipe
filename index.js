// Adapted from:
//  https://gist.github.com/CharlesHolbrow/8adfcf4915a9a6dd20b485228e16ead0

// .m3u8 ~ UTF8 m3u playlist
var url = '/stream.m3u8';
var element;
var player;

var log = function(text) {
  console.log(text);
  var e = document.createElement('div');
  e.innerHTML = text;
  document.body.appendChild(e);
}

var start = window.start = function ()  {
  stop();
  // Create a audio element
  element = window.element = document.createElement('audio');
  document.body.appendChild(element);

  if (Hls.isSupported()) {
      player = new Hls();
      player.attachMedia(element);
      player.on(Hls.Events.MEDIA_ATTACHED, function() {
          log('bound hls to DOM element');
          player.loadSource(url);
          player.on(Hls.Events.MANIFEST_PARSED, function(event, data) {
              log('manifest loaded with ' + data.levels.length + ' quality level(s)');
              element.play();
          });
      });
      player.on(Hls.Events.ERROR, function (event, data) {
          var errorType = data.type;
          var errorDetails = data.details;
          var errorFatal = data.fatal;

          switch(data.details) {
          case Hls.ErrorDetails.FRAG_LOAD_ERROR:
              log('error: FRAG_LOAD_ERROR'); debugger;
              break;
          case Hls.ErrorDetails.MEDIA_ERROR:
              log('error: MEDIA_ERROR'); debugger;
              break;
          case Hls.ErrorDetails.OTHER_ERROR:
              log('error" OTHER_ERROR'); debugger;
              break;
          default:
              log('default error:??')
              break;
          }
      });
  } 
  else if (element.canPlayType('application/vnd.apple.mpegurl') !== '') {
      element.src = url;
      element.addEventListener('loadedmetadata', function() {
          element.play();
      });
  } else {
      throw new Error('hls not supported');
  }
};

var stop = window.stop = function() {
  if (element) {
      element.pause();
      element.parentNode.removeChild(element);
      element = null;
      player = null;
  }
};

document.addEventListener("DOMContentLoaded", function() {log('hello!');});

