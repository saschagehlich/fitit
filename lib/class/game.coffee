Spaces = require "../data/spaces"
module.exports = class
  players: []
  constructor: (@io) ->
    @id = +new Date()

  addPlayer: (player) ->
    player.id = @players.length

    @players.push(player)
    player.socket.join("game-#{@id}")

    player.socket.on "move", (direction) =>
      switch direction
        when 0
          position.x += 1
        when 1
          position.y += 1
        when 2
          posiiton.x -= 1
        when 3
          position.y -= 1

      @broadcastMove player

    player.socket.on "disconnect", =>
      if ~@players.indexOf(player)
        @players.splice @players.indexOf(player), 1

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

  broadcastMove: (player) ->
    @io.sockets.in("game-#{@id}").emit "move", player.safeObj()
