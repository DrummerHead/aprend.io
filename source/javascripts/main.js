document.addEventListener('DOMContentLoaded', function(){
'use strict';




// Set correct video ratio
//
var video = document.getElementById('video');

if(document.body.contains(video)){
  var youtubeIframe = video.querySelector('iframe');

  var setVideoRatio = function(){
    var videoWidth = video.clientWidth;
    youtubeIframe.setAttribute('style', 'height: ' + Math.floor(videoWidth / (1728/1080) + 30) + 'px');
  };

  setVideoRatio();
  window.addEventListener('resize', setVideoRatio);
}




});
