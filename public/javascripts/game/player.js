(function() {
  var Player;

  Player = (function() {

    Player.name = 'Player';

    Player.prototype.tileImage = {
      0: '/images/green-tile.png',
      1: '/images/orange-tile.png',
      2: '/images/pink-tile.png',
      3: '/images/blue-tile.png'
    };

    function Player(context, playerData) {
      this.context = context;
      this.playerData = playerData;
      null;

    }

    Player.prototype.draw = function() {
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
              var image, x, y;
              x = _this.playerData.position.x * 32 + (_j * 32);
              y = _this.playerData.position.y * 32 + (_i * 32);
              if (value > 0) {
                image = new Image;
                image.src = _this.tileImage[_this.playerData.id];
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
