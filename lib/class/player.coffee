module.exports = class
  constructor: (@socket) ->
    @socket.player = this

    @name = "Arsch"
    @blockId = 0
    @block = null

    @color = null

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

  rotateBlock: ->
    @block = @rotate(@block)

  safeObj: ->
    return {
      id: @id
      block: @block
      position: @position
      color: @color
    }