window.FitItGame = FitItGame = class
  constructor: (io) ->
    @socket = io.connect "http://localhost:8080"
    @socket.on "connect", @onConnect

    @context = $('#screen').get(0).getContext('2d')

  onConnect: =>
    @socket.on "gamedata", @onGamedata
    @socket.on "move", @onPlayerMoved
    @bindKeys()

  onGamedata: (data) =>
    console.log "gamedata", data

    @board = new FitItBoard
    @board.initialize @context, data.board
    # board.draw()

    @players = {}
    for key, player of data.players
      newPlayer = new FitItPlayer
      newPlayer.initialize @context, player
      # newPlayer.draw()
      @players[player.id] = newPlayer

    @draw()

  bindKeys: ->
    $(document).keydown (event) =>
      console.log event
      switch event.keyCode
        when 37 # arrow left
          @socket.emit 'move', 2
        when 38 # arrow up
          @socket.emit 'move', 3
        when 39 # arrow right
          @socket.emit 'move', 0
        when 40 # arrow down
          @socket.emit 'move', 1
        
  onPlayerMoved: (playerData) =>
    @players[playerData.id].playerData = playerData
    @draw()


  draw: ->
    @board.draw()
    for key, player of @players
      player.draw()

