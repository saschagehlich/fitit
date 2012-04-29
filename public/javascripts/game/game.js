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
      this.socket.on("queue_length", this.onQueueLengthChanged);
      this.bindKeys();
      return this.bindNameInput();
    };

    _Class.prototype.startAnimationLoop = function() {
      var _this = this;
      return every(1000 / 30, function() {
        return _this.draw();
      });
    };

    _Class.prototype.onGamedata = function(data) {
      var key, newPlayer, player, _ref;
      $('.waiting').fadeOut('fast');
      $('canvas').fadeIn('fast');
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

    _Class.prototype.onQueueLengthChanged = function(newLength) {
      return $('.waiting-for').text(4 - parseInt(newLength));
    };

    _Class.prototype.bindKeys = function() {
      var _this = this;
      $(document).unbind("keydown");
      return $(document).keydown(function(event) {
        switch (event.keyCode) {
          case 37:
            _this.socket.emit('move', 2);
            return false;
          case 38:
            _this.socket.emit('move', 3);
            return false;
          case 39:
            _this.socket.emit('move', 0);
            return false;
          case 40:
            _this.socket.emit('move', 1);
            return false;
          case 32:
            _this.socket.emit('rotation', 1);
            return false;
          case 70:
            _this.socket.emit('flip');
            return false;
        }
      });
    };

    _Class.prototype.bindNameInput = function() {
      var _this = this;
      $('input').unbind("keydown");
      return $('input').keydown(function(event) {
        if (event.keyCode === 13 && $('input').val()) {
          _this.socket.emit('name', $('input').val());
          $('.enter-name').fadeOut('fast');
          return $('.waiting').fadeIn('fast');
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
      this.context.clearRect(0, 0, this.context.canvas.width, this.context.canvas.height);
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

  if (window.FitItHelper == null) {
    window.FitItHelper = {};
  }

  window.FitItHelper.centerWrapper = function() {
    var left, top, windowHeight, windowWidth, wrapperHeight, wrapperWidth;
    wrapperWidth = 970;
    wrapperHeight = 585;
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    left = (windowWidth - wrapperWidth) / 2;
    top = (windowHeight - wrapperHeight) / 2;
    return $('#wrapper').css({
      top: top,
      left: left
    });
  };

  $(function() {
    FitItHelper.centerWrapper();
    return $(window).resize(function() {
      return FitItHelper.centerWrapper();
    });
  });

}).call(this);
