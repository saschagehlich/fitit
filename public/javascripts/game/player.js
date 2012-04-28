(function() {
  var Player;

  Player = (function() {

    Player.name = 'Player';

    Player.prototype.tileImageURLs = {
      0: '/images/green-tile.png',
      1: '/images/orange-tile.png',
      2: '/images/pink-tile.png',
      3: '/images/blue-tile.png'
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
              var x, y;
              x = _this.playerData.position.x * 32 + (_j * 32);
              y = _this.playerData.position.y * 32 + (_i * 32);
              if (value > 0) {
                return _this.context.drawImage(_this.tileImages[_this.playerData.id], x, y);
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
