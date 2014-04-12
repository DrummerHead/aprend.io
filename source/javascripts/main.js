document.addEventListener('DOMContentLoaded', function(){
'use strict';





// This var holds functions to be executed by windows.resize
var queue = [];


// Fetch elements that we're interested in modifying
var video = document.getElementById('video');
var banner = document.querySelector('[role="banner"]');


// Function to get occupied height of an element
var getRawHeight = function(element){
  var cssProp = window.getComputedStyle(element);

  var marginTop = parseFloat(cssProp.marginTop);
  var paddingTop = parseFloat(cssProp.paddingTop);
  var height = parseFloat(cssProp.height);
  var paddingBottom = parseFloat(cssProp.paddingBottom);
  var marginBottom = parseFloat(cssProp.marginBottom);

  return marginTop + paddingTop + height + paddingBottom + marginBottom;
};

// Function to get just the occupied padding height of an element
var getPaddingHeight = function(element){
  var cssProp = window.getComputedStyle(element);

  var paddingTop = parseFloat(cssProp.paddingTop);
  var paddingBottom = parseFloat(cssProp.paddingBottom);

  return paddingTop + paddingBottom;
};


// Check if video element is actually in the page
if(document.body.contains(video)){
  var youtubeIframe = video.querySelector('iframe');

  // Function to modify video height as to preserve correct aspect ratio
  var setVideoRatio = function(event){
    var videoWidth = video.clientWidth;
    youtubeIframe.setAttribute('style', 'height: ' + Math.floor(videoWidth / (1728/1080) + 30) + 'px');
  };

  // Execute function, add it to queue
  setVideoRatio();
  queue.push(setVideoRatio);
}


// Check if banner (main header) element is actually in the page
if(document.body.contains(banner)){
  var brand = banner.querySelector('.brand');
  var navigation = banner.querySelector('[role="navigation"]');
  var social = banner.querySelector('.social');

  // Function to change banner from fixed to absolute depending on space
  // available (this avoids hidden elements due to position: fixed; and removes
  // need for unaesthetic scrollbars (if I were to solve the problem with
  // overflow: auto))
  var bannerNeverHides = function(event){
    var windowInnerWidth = event.innerWidth || event.currentTarget.innerWidth;

    if(windowInnerWidth > 1000){
      var bannerPadding = getPaddingHeight(banner);

      var brandHeight = getRawHeight(brand);
      var navigationHeight = getRawHeight(navigation);
      var socialHeight = getRawHeight(social);

      var totalHeight = bannerPadding + brandHeight + navigationHeight + socialHeight;

      var windowHeight = window.innerHeight;

      if(totalHeight > windowHeight){
        banner.setAttribute('style', 'position: absolute;');
      }
      else {
        banner.setAttribute('style', 'position: fixed;');
      }
    }
    else {
      banner.removeAttribute('style');
    }
  };

  bannerNeverHides(window);
  queue.push(bannerNeverHides);
}


window.addEventListener('resize', function(event){
  queue.forEach(function(func){
    func(event);
  });
});



});
