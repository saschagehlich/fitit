Blocks = require "../data/blocks"
module.exports = class
  constructor: (@socket) ->
    @socket.player = this

    @name = "Arsch"
    @block = Blocks.getRandomBlock()
    
    @rotation = 0
    @position =
      x: 0
      y: 0

  safeObj: ->
    return {
      id: @id
      block: @block
      position: @position
    }