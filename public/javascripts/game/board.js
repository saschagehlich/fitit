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
      this.fittingImage = new Image();
      this.fittingImage.src = "/images/fitting-tile.png";
    };

    Board.prototype.draw = function() {
      var colIndex, row, rowIndex, value, _ref, _results;
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
              var x, y;
              x = colIndex * 32;
              y = rowIndex * 32;
              if (value > 0) {
                return _this.context.drawImage(_this.fittingImage, x, y);
              }
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
