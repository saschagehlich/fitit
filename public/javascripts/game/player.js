(function() {
  var Player;

  Player = (function() {

    Player.name = 'Player';

    Player.prototype.tileImageURLs = {
      'green': '/images/green-tile.png',
      'green-transparent': '/images/green-tile-transparent.png',
      'orange': '/images/orange-tile.png',
      'orange-transparent': '/images/orange-tile-transparent.png',
      'pink': '/images/pink-tile.png',
      'pink-transparent': '/images/pink-tile-transparent.png',
      'blue': '/images/blue-tile.png',
      'blue-transparent': '/images/blue-tile-transparent.png'
    };

    Player.prototype.tileImages = {};

    function Player(context, playerData) {
      var i, image, key, _ref;
      this.context = context;
      this.playerData = playerData;
      _ref = this.tileImageURLs;
      for (key in _ref) {
        image = _ref[key];
        i = new Image;
        i.src = image;
        this.tileImages[key] = i;
      }
    }

    Player.prototype.draw = function(boardData) {
      var row, value, _i, _len, _ref, _results;
      _ref = this.playerData.block;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        _results.push((function() {
          var _j, _len1, _results1,
            _this = this;
          _results1 = [];
          for (_j = 0, _len1 = row.length; _j < _len1; _j++) {
            value = row[_j];
            _results1.push((function(value) {
              var playerPosition, x, y;
              playerPosition = {
                x: _this.playerData.position.x + _j,
                y: _this.playerData.position.y + _i
              };
              x = playerPosition.x * 32;
              y = playerPosition.y * 32;
              if (value > 0) {
                if (boardData[playerPosition.y][playerPosition.x] === -1) {
                  return _this.context.drawImage(_this.tileImages[_this.playerData.color + '-transparent'], x, y);
                } else {
                  return _this.context.drawImage(_this.tileImages[_this.playerData.color], x, y);
                }
              }
            })(value));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return Player;

  })();

  window.FitItPlayer = Player;

}).call(this);
