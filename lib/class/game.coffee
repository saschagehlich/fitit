Spaces = require "../data/spaces"
module.exports = class
  players: []
  constructor: (@io) ->
    @id = +new Date()

  addPlayer: (player) ->
    player.id = @players.length

    @players.push(player)
    player.socket.join("game-#{@id}")

    player.socket.on "disconnect", =>
      if ~@players.indexOf(player)
        @players.splice @players.indexOf(player), 1

  startGame: ->
    hittingSpace = Spaces.getRandomSpace()
    @board = {}

    # create empty board
    for i in [0...15]
      for j in [0...13]
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
      players[player.id] = {
        id: player.id
        block: player.block
        position: player.position
        rotation: player.rotation
      }

    @io.sockets.in("game-#{@id}").emit "gamedata",
      board: @board
      players: players
