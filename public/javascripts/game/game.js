(function() {
  var FitItGame,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.FitItGame = FitItGame = (function() {

    function _Class(io) {
      this.onPlayers = __bind(this.onPlayers, this);

      this.onBoard = __bind(this.onBoard, this);

      this.onConnect = __bind(this.onConnect, this);
      this.socket = io.connect("http://localhost:8080");
      this.socket.on("connect", this.onConnect);
    }

    _Class.prototype.onConnect = function() {
      this.socket.on("board", this.onBoard);
      return this.socket.on("players", this.onPlayers);
    };

    _Class.prototype.onBoard = function(board) {
      return console.log("board", board);
    };

    _Class.prototype.onPlayers = function(players) {
      return console.log("players", players);
    };

    return _Class;

  })();

}).call(this);
