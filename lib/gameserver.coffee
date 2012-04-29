Player = require "./class/player"
Game   = require "./class/game"

module.exports = class
  queue: []
  games: []
  constructor: (@io) ->
    @io.on "connection", @onConnection

  onConnection: (socket) =>
    # do we need to add the player to the queue?
    gameFound = false
    for game in @games
      if game.players.length < 4
        chosenGame = game
        gameFound = true

    if gameFound
      player = new Player(socket)
      chosenGame.addPlayer(player)
    else
      @queue.push socket

      for waitingSocket in @queue
        waitingSocket.emit "joined_queue", @queue.length

      socket.inQueue = true
      socket.on "disconnect", =>
        if socket.inQueue
          if ~@queue.indexOf(socket)
            @queue.splice @queue.indexOf(socket), 1

        for waitingSocket in @queue
          waitingSocket.emit "left_queue", @queue.length

      @checkQueue()

  checkQueue: ->
    # check whether there is a game with less than 4 players
    gameFound = false
    for game in @games
      if game.players.length < 4
        game.addPlayer(player)
        gameFound = true

    if @queue.length is 4 and not gameFound
      game = new Game(@io, this)
      for socket in @queue
        player = new Player(socket)
        # player.name = socket.playerName
        game.addPlayer(player)

      @queue = []

      game.startGame()

      @games.push game

  getLongestWaitingSocket: ->
    if @queue.length > 0
      socket = @queue[0]
      @queue.shift()
      return socket
    else
      return false