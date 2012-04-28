(function() {
  var FitItGame,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.FitItGame = FitItGame = (function() {

    function _Class(io) {
      this.onGamedata = __bind(this.onGamedata, this);

      this.onConnect = __bind(this.onConnect, this);
      this.socket = io.connect("http://localhost:8080");
      this.socket.on("connect", this.onConnect);
      this.context = $('#screen').get(0).getContext('2d');
    }

    _Class.prototype.onConnect = function() {
      return this.socket.on("gamedata", this.onGamedata);
    };

    _Class.prototype.onGamedata = function(data) {
      var board, key, newPlayer, player, _ref, _results;
      console.log("gamedata", data);
      board = new FitItBoard;
      board.initialize(this.context, data.board);
      board.draw();
      this.players = [];
      _ref = data.players;
      _results = [];
      for (key in _ref) {
        player = _ref[key];
        newPlayer = new FitItPlayer;
        newPlayer.initialize(this.context, player);
        newPlayer.draw();
        _results.push(this.players.push(newPlayer));
      }
      return _results;
    };

    return _Class;

  })();

}).call(this);
