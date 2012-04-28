window.FitItGame = FitItGame = class
  constructor: (io) ->
    @socket = io.connect "http://#{window.location.hostname}:8080"
    @socket.on "connect", @onConnect

    @context = $('#screen').get(0).getContext('2d')

  onConnect: =>
    @socket.on "gamedata", @onGamedata
    @socket.on "move", @onPlayerMoved
    @socket.on "player_join", @onPlayerJoined
    @bindKeys()

  onGamedata: (data) =>
    @board = new FitItBoard
    @board.initialize @context, data.board
    # board.draw()

    @players = {}
    for key, player of data.players
      newPlayer = new FitItPlayer @context, player
      # newPlayer.draw()
      @players[player.id] = newPlayer

    @draw()

  bindKeys: ->
    $(document).keydown (event) =>
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
    if @players.hasOwnProperty(playerData.id)
      @players[playerData.id].playerData = playerData
    @draw()

  onPlayerJoined: (playerData) =>
    @players[playerData.id] = new FitItPlayer @context, playerData
    @draw()

  draw: ->
    @board.draw()
    for key, player of @players
      player.draw()

