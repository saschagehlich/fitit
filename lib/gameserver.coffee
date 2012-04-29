Player = require "./class/player"
Game   = require "./class/game"

module.exports = class
  queue: []
  games: []
  constructor: (@io) ->
    @io.on "connection", @onConnection

  onConnection: (socket) =>
    @queue.push socket

    socket.emit "joined_queue", @queue.length

    socket.inQueue = true
    socket.on "disconnect", =>
      if socket.inQueue
        if ~@queue.indexOf(socket)
          @queue.splice @queue.indexOf(socket), 1
          console.log "socket disconnected and removed from queue"

    @checkQueue()

  checkQueue: ->
    if @queue.length is 4
      game = new Game(@io)
      for socket in @queue
        player = new Player(socket)
        game.addPlayer(player)

      game.startGame()

      @games.push game