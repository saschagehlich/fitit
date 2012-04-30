(function() {

  soundManager.url = "/swf";

  soundManager.debugMode = false;

  $(document).ready(function() {
    return window.game = new FitItGame(io);
  });

}).call(this);
