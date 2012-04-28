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

  rotate: (block) ->
    newData = []
    for i in [block.length-1..0]
      for j in [0...block[i].length]
        unless newData.hasOwnProperty(j)
          newData[j] = []
        newData[j].push block[i][j]

    return newData

  getRotatedBlock: ->
    block = @block
    for i in [0...@rotation]
      block = @rotate(block)

    return block

  safeObj: ->
    return {
      id: @id
      block: @getRotatedBlock()
      position: @position
    }