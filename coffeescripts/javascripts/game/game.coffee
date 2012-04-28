window.every = (t, f) -> setInterval f, t

window.FitItGame = FitItGame = class
  constructor: (io) ->
    @socket = io.connect "http://#{window.location.hostname}:8080"
    @socket.on "connect", @onConnect

    @context = $('#screen').get(0).getContext('2d')

  onConnect: =>
    @socket.on "gamedata", @onGamedata
    @socket.on "move", @onPlayerMoved
    @socket.on "player_join", @onPlayerJoined
    @socket.on "player_left", @onPlayerLeave
    @bindKeys()
    @startAnimationLoop()

  startAnimationLoop: ->
    every 1000 / 30, =>
      @draw()
    # requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame ||window.webkitRequestAnimationFrame || window.msRequestAnimationFrame
    # start = window.mozAnimationStartTime # Only supported in FF. Other browsers can use something like Date.now().  
    # step = (timestamp) =>
    #   @draw()
    #   requestAnimationFrame(step)
    # requestAnimationFrame(step)

  onGamedata: (data) =>
    @board = new FitItBoard
    @board.initialize @context, data.board

    @players = {}
    for key, player of data.players
      newPlayer = new FitItPlayer @context, player
      @players[player.id] = newPlayer

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
        when 32 # space
          @socket.emit 'rotation', 1
        
  onPlayerMoved: (playerData) =>
    if @players.hasOwnProperty(playerData.id)
      @players[playerData.id].playerData = playerData

  onPlayerJoined: (playerData) =>
    @players[playerData.id] = new FitItPlayer @context, playerData

  onPlayerLeave: (playerData) =>
    i = 0
    for player in @players
      if player.id is playerData.id
        @players.splice i, 1
        break
      i++

  draw: ->
    @context.clearRect @context.width, @context.height
    @board.draw()
    for key, player of @players
      player.draw()

