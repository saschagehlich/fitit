Spaces = require "../data/spaces"
module.exports = class
  players: []
  playerId: 0
  colors: ['green', 'orange', 'pink', 'blue']
  constructor: (@io) ->
    @id = +new Date()

  addPlayer: (player) ->
    @playerId++
    player.id = @playerId

    player.color = @colors[0]
    @colors.shift()

    @players.push(player)
    player.socket.join("game-#{@id}")

    players = {}
    for player in @players
      players[player.id] = player.safeObj()

    player.socket.emit "gamedata",
      board: @board
      players: players

    @broadcastPlayerJoin(player)

    player.socket.on "move", (direction) => @onPlayerMove player, direction
    player.socket.on "rotation", (direction) => @onPlayerRotation player, direction
    player.socket.on "disconnect", => @onPlayerDisconnect player

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


  onPlayerMove: (player, direction) =>
    if @checkBounds(player, direction)
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

  checkBounds: (player, direction) =>
    switch direction
      when 0 # right
        player.position.x + player.block[0].length < Object.keys(@board[0]).length
      when 1 # down
        player.position.y + player.block.length < Object.keys(@board).length
      when 2 # left
        player.position.x > 0
      when 3 # up
        player.position.y > 0

  onPlayerRotation: (player, rotation) =>
    player.rotation += direction

    if player.rotation > 3
      player.rotation = 0
    else if player.rotation < 0
      player.rotation = 3

    player.block = player.getRotatedBlock()

    @broadcastMove player

  onPlayerDisconnect: (player) =>
    if ~@players.indexOf(player)
        @players.splice @players.indexOf(player), 1

      @colors.push player.color
      @broadcastPlayerLeave player

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
      player.socket.emit "player_leave", leftPlayer.safeObj()    
