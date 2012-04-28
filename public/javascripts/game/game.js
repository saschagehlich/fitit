(function() {
  var FitItGame,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.every = function(t, f) {
    return setInterval(f, t);
  };

  window.FitItGame = FitItGame = (function() {

    function _Class(io) {
      this.onPlayerLeave = __bind(this.onPlayerLeave, this);

      this.onPlayerJoined = __bind(this.onPlayerJoined, this);

      this.onPlayerMoved = __bind(this.onPlayerMoved, this);

      this.onGamedata = __bind(this.onGamedata, this);

      this.onConnect = __bind(this.onConnect, this);
      this.socket = io.connect("http://" + window.location.hostname + ":8080");
      this.socket.on("connect", this.onConnect);
      this.context = $('#screen').get(0).getContext('2d');
    }

    _Class.prototype.onConnect = function() {
      this.socket.on("gamedata", this.onGamedata);
      this.socket.on("move", this.onPlayerMoved);
      this.socket.on("player_join", this.onPlayerJoined);
      this.socket.on("player_leave", this.onPlayerLeave);
      return this.bindKeys();
    };

    _Class.prototype.startAnimationLoop = function() {
      var _this = this;
      return every(1000 / 30, function() {
        return _this.draw();
      });
    };

    _Class.prototype.onGamedata = function(data) {
      var key, newPlayer, player, _ref;
      this.board = new FitItBoard;
      this.board.initialize(this.context, data.board);
      this.players = {};
      _ref = data.players;
      for (key in _ref) {
        player = _ref[key];
        newPlayer = new FitItPlayer(this.context, player);
        this.players[player.id] = newPlayer;
      }
      return this.startAnimationLoop();
    };

    _Class.prototype.bindKeys = function() {
      var _this = this;
      $(document).unbind("keydown");
      return $(document).keydown(function(event) {
        switch (event.keyCode) {
          case 37:
            return _this.socket.emit('move', 2);
          case 38:
            return _this.socket.emit('move', 3);
          case 39:
            return _this.socket.emit('move', 0);
          case 40:
            return _this.socket.emit('move', 1);
          case 32:
            return _this.socket.emit('rotation', 1);
        }
      });
    };

    _Class.prototype.onPlayerMoved = function(playerData) {
      if (this.players.hasOwnProperty(playerData.id)) {
        return this.players[playerData.id].playerData = playerData;
      }
    };

    _Class.prototype.onPlayerJoined = function(playerData) {
      return this.players[playerData.id] = new FitItPlayer(this.context, playerData);
    };

    _Class.prototype.onPlayerLeave = function(playerData) {
      var i, key, player, _ref, _results;
      i = 0;
      _ref = this.players;
      _results = [];
      for (key in _ref) {
        player = _ref[key];
        if (parseInt(key) === parseInt(playerData.id)) {
          delete this.players[playerData.id];
          break;
        }
        _results.push(i++);
      }
      return _results;
    };

    _Class.prototype.draw = function() {
      var key, player, _ref, _results;
      this.context.clearRect(this.context.width, this.context.height);
      this.board.draw();
      _ref = this.players;
      _results = [];
      for (key in _ref) {
        player = _ref[key];
        _results.push(player.draw());
      }
      return _results;
    };

    return _Class;

  })();

}).call(this);
