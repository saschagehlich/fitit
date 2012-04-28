Player = require "./class/player"
Game   = require "./class/game"

module.exports = class
  queue: []
  constructor: (@io) ->
    @io.on "connection", @onConnection
    @game   = new Game @io

    @game.startGame()

  # onConnection: (socket) =>
  #   @queue.push socket

  #   console.log "new socket, queue length: #{@queue.length}"

  #   socket.inQueue = true
  #   socket.on "disconnect", =>
  #     if socket.inQueue
  #       if ~@queue.indexOf(socket)
  #         @queue.splice @queue.indexOf(socket), 1
  #         console.log "socket disconnected and removed from queue"

  onConnection: (socket) =>
    player = new Player(socket)

    @game.addPlayer player