module.exports = class
  constructor: (@io) ->
    @io.on "connection", @onConnection

  onConnection: (socket) ->
    console.log "new socket: #{socket.id}"