Spaces = require "../data/spaces"
module.exports = class
  players: []
  playerId: 0
  constructor: (@io) ->
    @id = +new Date()

  addPlayer: (player) ->
    @playerId++
    player.id = @playerId

    @players.push(player)
    player.socket.join("game-#{@id}")

    players = {}
    for player in @players
      players[player.id] = player.safeObj()

    player.socket.emit "gamedata",
      board: @board
      players: players

    @broadcastPlayerJoin(player)

    player.socket.on "move", (direction) =>
      switch direction
        when 0
          player.position.x += 1
        when 1
          player.position.y += 1
        when 2
          player.position.x -= 1
        when 3
          player.position.y -= 1

      @broadcastMove player

    player.socket.on "rotation", (direction) =>
      player.rotation += direction

      if player.rotation > 3
        player.rotation = 0
      else if player.rotation < 0
        player.rotation = 3

      @broadcastMove player

    player.socket.on "disconnect", =>
      if ~@players.indexOf(player)
        @players.splice @players.indexOf(player), 1

      @broadcastPlayerLeave player

  startGame: ->
    hittingSpace = Spaces.getRandomSpace()
    @board = {}

    # create empty board
    for i in [0...13]
      for j in [0...15]
        unless @board.hasOwnProperty i
          @board[i] = {}

        @board[i][j] = -1

    # put hittingspace into board
    for i in [0...5]
      for j in [0...5]
        @board[4+i][5+j] = hittingSpace[i][j]

    @broadcastInitialData()

  broadcastInitialData: ->
    players = {}
    for player in @players
      players[player.id] = player.safeObj()

    @io.sockets.in("game-#{@id}").emit "gamedata",
      board: @board
      players: players    

  broadcastMove: (movingPlayer) ->
    for player in @players
      player.socket.emit "move", movingPlayer.safeObj()

  broadcastPlayerJoin: (newPlayer) ->
    for player in @players
      unless player is newPlayer
        player.socket.emit "player_join", newPlayer.safeObj()    

  broadcastPlayerLeave: (leftPlayer) ->
    for player in @players
      unless player is leftPlayer
        player.socket.emit "player_leave", leftPlayer.safeObj()    