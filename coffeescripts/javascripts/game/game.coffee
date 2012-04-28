window.FitItGame = FitItGame = class
  constructor: (io) ->
    @socket = io.connect "http://localhost:8080"
    @socket.on "connect", @onConnect

    @context = $('#screen').get(0).getContext('2d')

  onConnect: =>
    @socket.on "gamedata", @onGamedata

  onGamedata: (data) =>
    console.log "gamedata", data

    board = new FitItBoard
    board.initialize @context, data.board
    board.draw()

    @players = []
    for key, player of data.players
      newPlayer = new FitItPlayer
      newPlayer.initialize @context, player
      newPlayer.draw()
      @players.push newPlayer
