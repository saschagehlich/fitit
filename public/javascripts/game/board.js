(function() {
  var Board;

  Board = (function() {

    Board.name = 'Board';

    function Board() {}

    Board.prototype.boardData = {};

    Board.prototype.grid = {
      width: 15,
      height: 13
    };

    Board.prototype.hittingSpace = {
      0: {
        2: 1,
        3: 1,
        4: 1
      },
      1: {
        2: 1,
        3: 1,
        4: 1
      },
      2: {
        2: 1,
        3: 1,
        4: 1
      },
      3: {
        2: 1,
        3: 1,
        4: 1
      },
      4: {
        0: 1,
        1: 1,
        2: 1,
        3: 1,
        4: 1
      },
      sum: 17
    };

    Board.prototype.initialize = function(context) {
      var i, j, _base, _i, _j, _k, _ref, _ref1, _results;
      this.context = context;
      for (i = _i = 0, _ref = this.grid.height; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        for (j = _j = 0, _ref1 = this.grid.width; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
          (_base = this.boardData)[i] || (_base[i] = {});
          this.boardData[i][j] = null;
        }
      }
      _results = [];
      for (i = _k = 0; _k < 5; i = ++_k) {
        _results.push((function() {
          var _l, _results1;
          _results1 = [];
          for (j = _l = 0; _l < 5; j = ++_l) {
            _results1.push(this.boardData[4 + i][5 + j] = this.hittingSpace[i][j]);
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    Board.prototype.draw = function() {
      var colIndex, row, rowIndex, value, _ref, _results;
      this.context.clearRect(800, 640);
      _ref = this.boardData;
      _results = [];
      for (rowIndex in _ref) {
        row = _ref[rowIndex];
        _results.push((function() {
          var _results1,
            _this = this;
          _results1 = [];
          for (colIndex in row) {
            value = row[colIndex];
            _results1.push((function(value, colIndex, rowIndex) {
              var image, x, y;
              x = colIndex * 32;
              y = rowIndex * 32;
              image = new Image;
              if (value > 0) {
                image.src = '/images/fitting-tile.png';
              } else {
                image.src = '/images/default-tile.png';
              }
              return image.onload = function() {
                return _this.context.drawImage(image, x, y);
              };
            })(value, colIndex, rowIndex));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return Board;

  })();

  window.FitItBoard = Board;

}).call(this);
