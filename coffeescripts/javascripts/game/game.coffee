window.FitItGame = FitItGame = class
  constructor: (io) ->
    @socket = io.connect "http://localhost:8080"
    @socket.on "connect", @onConnect

  onConnect: =>
    @socket.on "board", @onBoard
    @socket.on "players", @onPlayers

  onBoard: (board) =>
    console.log "board", board

  onPlayers: (players) =>
    console.log "players", players