Blocks = require "../data/blocks"
module.exports = class
  constructor: (@socket) ->
    @socket.player = this

    @name = "Arsch"
    @block = Blocks.getRandomBlock()
    
    @position =
      x: 0
      y: 0