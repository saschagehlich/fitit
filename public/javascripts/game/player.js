(function() {
  var Player;

  Player = (function() {

    Player.name = 'Player';

    function Player() {}

    Player.prototype.playerData = [[1, 1], [-1, 1], [-1, 1]];

    Player.prototype.tileImage = {
      0: '/images/green-tile.png',
      1: '/images/orange-tile.png',
      2: '/images/pink-tile.png',
      3: '/images/blue-tile.png'
    };

    Player.prototype.playerInfo = {
      posX: 2,
      posY: 2,
      id: 1
    };

    Player.prototype.position = {
      x: 0,
      y: 0
    };

    Player.prototype.initialize = function(context) {
      this.context = context;
    };

    Player.prototype.draw = function() {
      var row, value, _i, _len, _ref, _results;
      _ref = this.playerData;
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
              var image, x, y;
              x = _this.playerInfo.posX * 32 + (_j * 32);
              y = _this.playerInfo.posY * 32 + (_i * 32);
              if (value > 0) {
                image = new Image;
                image.src = _this.tileImage[_this.playerInfo.id];
                console.log(image, x, y);
                return image.onload = function() {
                  return _this.context.drawImage(image, x, y);
                };
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
