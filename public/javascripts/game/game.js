(function() {
  var FitItGame,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.every = function(t, f) {
    return setInterval(f, t);
  };

  window.after = function(t, f) {
    return setTimeout(f, t);
  };

  window.FitItGame = FitItGame = (function() {

    _Class.prototype.name = null;

    function _Class(io) {
      this.onPlayerLeave = __bind(this.onPlayerLeave, this);

      this.onPlayerJoined = __bind(this.onPlayerJoined, this);

      this.onPlayerMoved = __bind(this.onPlayerMoved, this);

      this.onGamedata = __bind(this.onGamedata, this);

      this.onGameEnded = __bind(this.onGameEnded, this);

      this.onConnect = __bind(this.onConnect, this);

      var _this = this;
      this.socket = io.connect("http://" + window.location.hostname + ":8080");
      this.socket.on("connect", this.onConnect);
      this.context = $('#screen').get(0).getContext('2d');
      this.prepareSounds();
      this.overlappingTile = new Image();
      this.overlappingTile.src = "/images/overlap-tile.png";
      $('.winning').click(function() {
        return location.reload();
      });
    }

    _Class.prototype.prepareSounds = function() {
      if (document.cookie.match(/mute=on/i)) {
        $('.sound').removeClass("on").addClass("off");
        soundManager.mute();
      }
      $('.sound').click(function() {
        if ($(this).hasClass("on")) {
          $(this).removeClass("on").addClass("off");
          soundManager.mute();
          return document.cookie = "mute=on";
        } else {
          $(this).removeClass("off").addClass("on");
          soundManager.unmute();
          return document.cookie = "mute=off";
        }
      });
      return soundManager.onload = function() {
        var dingdong, subway, success;
        subway = soundManager.createSound({
          id: "subway",
          url: ['/audio/subway.mp3', '/audio/subway.aac', '/audio/subway.ogg'],
          volume: 50,
          autoLoad: true,
          onload: function() {
            var loopBackground;
            loopBackground = function() {
              return subway.play({
                onfinish: function() {
                  return loopBackground();
                }
              });
            };
            return loopBackground();
          }
        });
        dingdong = soundManager.createSound({
          id: "dingdong",
          url: ['/audio/dingdong.mp3', '/audio/dingdong.aac', '/audio/dingdong.ogg'],
          volume: 100,
          autoLoad: true
        });
        return success = soundManager.createSound({
          id: "success",
          url: ['/audio/success.mp3', '/audio/success.aac', '/audio/success.ogg'],
          volume: 100,
          autoLoad: true
        });
      };
    };

    _Class.prototype.onConnect = function() {
      this.socket.on("gamedata", this.onGamedata);
      this.socket.on("move", this.onPlayerMoved);
      this.socket.on("player_join", this.onPlayerJoined);
      this.socket.on("player_leave", this.onPlayerLeave);
      this.socket.on("queue_length", this.onQueueLengthChanged);
      this.socket.on("winning", this.onWinning);
      this.socket.on("game_ended", this.onGameEnded);
      return this.bindNameInput();
    };

    _Class.prototype.startAnimationLoop = function() {
      var _this = this;
      return every(1000 / 30, function() {
        return _this.draw();
      });
    };

    _Class.prototype.onGameEnded = function(err) {
      alert("The game has ended due to this reason: " + err);
      return location.reload();
    };

    _Class.prototype.onWinning = function() {
      soundManager.play("success");
      return after(1000, function() {
        $('.winning').fadeIn('fast');
        return this.players = {};
      });
    };

    _Class.prototype.onGamedata = function(data) {
      var key, newPlayer, player, _ref;
      soundManager.play("dingdong");
      this.changeToGameView(data.players);
      if (!this.board) {
        this.board = new FitItBoard;
      }
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

    _Class.prototype.changeToWaitingView = function() {
      $(document).unbind("keydown");
      $('.players, canvas#screen').fadeOut('fast');
      return $('.info, .waiting').fadeIn('fast');
    };

    _Class.prototype.changeToGameView = function(players) {
      var key, li, player, playerCanvas;
      this.bindKeys();
      $('.info, .waiting').fadeOut('fast');
      $('.players').empty();
      for (key in players) {
        player = players[key];
        li = $('<li>');
        playerCanvas = $('<canvas>').attr({
          id: 'player-' + player.id,
          width: '32',
          height: '32'
        }).addClass('player-canvas');
        li.append(playerCanvas);
        li.append($('<span>').addClass('player-name').text(player.name));
        $('.players').append(li);
        this.drawPlayerCanvas(playerCanvas, player.block, player.color);
      }
      return $('.players, canvas#screen').fadeIn('fast');
    };

    _Class.prototype.drawPlayerCanvas = function(canvas, block, color) {
      /*
            Draw the player's block into the canvas
      */

      var tile;
      tile = new Image();
      tile.src = '/images/' + color + '-tile.png';
      return tile.onload = function() {
        var blockX, blockY, context, paddingX, paddingY, tileSize, _i, _ref, _results;
        tileSize = Math.floor(Math.min(canvas.width() / block[0].length, canvas.height() / block.length));
        context = $(canvas)[0].getContext('2d');
        _results = [];
        for (blockY = _i = 0, _ref = block.length; 0 <= _ref ? _i < _ref : _i > _ref; blockY = 0 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (blockX = _j = 0, _ref1 = block[blockY].length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; blockX = 0 <= _ref1 ? ++_j : --_j) {
              if (block[blockY][blockX] !== -1) {
                paddingX = Math.round((32 - (block[blockY].length * tileSize)) / 2) * -1;
                paddingY = Math.round((32 - (block.length * tileSize)) / 2) * -1;
                _results1.push(context.drawImage(tile, 0, 0, 32, 32, blockX * tileSize - paddingX, blockY * tileSize - paddingY, tileSize, tileSize));
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          })());
        }
        return _results;
      };
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
      return $('form').submit(function(event) {
        event.preventDefault();
        if ($('input').val()) {
          _this.name = $('input').val();
          _this.socket.emit('name', $('input').val());
          $('.enter-name').fadeOut('fast');
          $('.waiting').fadeIn('fast');
          $('form').unbind("submit");
          return $('form').submit(function() {
            return false;
          });
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
      var blockX, blockY, i, key, player, playerBlock, playerPosition, row, tempBoard, tile, tileX, tileY, _i, _j, _k, _l, _m, _ref, _ref1, _ref2, _ref3, _results;
      this.context.clearRect(0, 0, this.context.canvas.width, this.context.canvas.height);
      this.board.draw();
      tempBoard = [];
      for (i = _i = 0; _i < 13; i = ++_i) {
        row = [];
        for (i = _j = 0; _j < 15; i = ++_j) {
          row.push(-1);
        }
        tempBoard.push(row);
      }
      _ref = this.players;
      for (key in _ref) {
        player = _ref[key];
        /*
                Recognize block overlapping
        */

        playerBlock = player.playerData.block;
        playerPosition = player.playerData.position;
        for (blockY = _k = 0, _ref1 = playerBlock.length; 0 <= _ref1 ? _k < _ref1 : _k > _ref1; blockY = 0 <= _ref1 ? ++_k : --_k) {
          for (blockX = _l = 0, _ref2 = playerBlock[blockY].length; 0 <= _ref2 ? _l < _ref2 : _l > _ref2; blockX = 0 <= _ref2 ? ++_l : --_l) {
            tileY = playerPosition.y + blockY;
            tileX = playerPosition.x + blockX;
            if (playerBlock[blockY][blockX] !== -1) {
              if (tempBoard[tileY][tileX] === -1) {
                tempBoard[tileY][tileX] = player.playerData.id;
              } else {
                tempBoard[tileY][tileX] = 0;
              }
            }
          }
        }
        player.draw();
      }
      /*
            Draw overlapping tiles
      */

      _results = [];
      for (tileY = _m = 0, _ref3 = tempBoard.length; 0 <= _ref3 ? _m < _ref3 : _m > _ref3; tileY = 0 <= _ref3 ? ++_m : --_m) {
        _results.push((function() {
          var _n, _ref4, _results1;
          _results1 = [];
          for (tileX = _n = 0, _ref4 = tempBoard[tileY].length; 0 <= _ref4 ? _n < _ref4 : _n > _ref4; tileX = 0 <= _ref4 ? ++_n : --_n) {
            tile = tempBoard[tileY][tileX];
            if (tile === 0) {
              _results1.push(this.context.drawImage(this.overlappingTile, tileX * 32, tileY * 32));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).call(this));
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
    $(window).resize(function() {
      return FitItHelper.centerWrapper();
    });
    return $('input').focus();
  });

}).call(this);
