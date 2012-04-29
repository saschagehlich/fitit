Player = require "./class/player"
Game   = require "./class/game"

module.exports = class
  queue: []
  games: []
  constructor: (@io) ->
    @io.on "connection", @onConnection

  onConnection: (socket) =>
    socket.on "name", (name) =>
      @queue.push socket
      socket.playerName = name

      for waitingSocket in @queue
        waitingSocket.emit "joined_queue", @queue.length

      socket.inQueue = true
      socket.on "disconnect", =>
        if socket.inQueue
          if ~@queue.indexOf(socket)
            @queue.splice @queue.indexOf(socket), 1
            console.log "socket disconnected and removed from queue"

        for waitingSocket in @queue
          waitingSocket.emit "left_queue", @queue.length

      @checkQueue()

  checkQueue: ->
    if @queue.length is 4
      game = new Game(@io)
      for socket in @queue
        player = new Player(socket)
        player.name = socket.playerName
        game.addPlayer(player)

      @queue = []

      game.startGame()

      @games.push game