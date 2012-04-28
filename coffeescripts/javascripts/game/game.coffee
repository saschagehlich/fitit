window.FitItGame = FitItGame = class
  constructor: (io) ->
    @socket = io.connect "http://localhost:8080"
    @socket.on "connect", @onConnect

    context = $('#screen').get(0).getContext('2d')

    board = new FitItBoard
    board.initialize context
    board.draw()

    player = new FitItPlayer
    player.initialize context
    player.draw()

  onConnect: =>
    @socket.on "board", @onBoard
    @socket.on "players", @onPlayers

  onBoard: (board) =>
    console.log "board", board

  onPlayers: (players) =>
    console.log "players", players