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

    if @socket.playerName?
      @name = @socket.playerName

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

  flipBlock: ->
    newData = []
    for i in [0...@block.length]
      newData[i] = []
      for j in [@block[i].length-1..0]
        newData[i].push @block[i][j]

    @block = newData

  safeObj: ->
    return {
      id: @id
      name: @name
      block: @block
      position: @position
      color: @color
    }