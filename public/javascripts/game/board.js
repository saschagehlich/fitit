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

    Board.prototype.initialize = function(context, boardData) {
      this.context = context;
      this.boardData = boardData;
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
