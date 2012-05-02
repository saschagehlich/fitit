Blocks = require "./data/blocks"
module.exports = class
  constructor: ->
    @blocks = new Blocks()

  checkValidity: (level, block, position) ->
    for blockY in [0...block.length]
      for blockX in [0...block[blockY].length]
        if block[blockY][blockX] is 1 and level[position.y + blockY][position.x + blockX] isnt -1
          return false
    return true

  getRandomLevel: ->
    level = null
    while not level
      level = @generateLevel()
    return level

  generateLevel: ->
    usedBlockIds = []
    level = []
    for i in [0...5]
      row = []
      for j in [0...5]
        row.push -1
      level.push row

    blockId = 0
    for i in [1...5]
      blockDone = false
      blockDoneTries = 0
      blockDoneTriesMax = 10
      while not blockDone
        bid = null
        blockFound = false
        while not blockFound
          blockArr = @blocks.getRandomBlockWithId()
          block = blockArr[0]
          bid = blockArr[1]

          unless ~usedBlockIds.indexOf(bid)
            blockFound = true
        
        positionFound = false
        positionFoundTries = 0
        positionFoundTriesMax = 10
        while not positionFound
          for r in [0...Math.floor(Math.random()*10)]
            block = @rotate(block)

          for f in [0...Math.floor(Math.random()*10)]
            block = @flipBlock(block)

          randomPosition =
            x: Math.min(Math.floor(Math.random() * 4), 5 - block[0].length)
            y: Math.min(Math.floor(Math.random() * 4), 5 - block.length)

          if @checkValidity(level, block, randomPosition)
            level = @addBlockToLevel(i, level, block, randomPosition)
            positionFound = true
            usedBlockIds.push bid

          positionFoundTries++
          if positionFoundTriesMax is positionFoundTries
            break
        blockDoneTries++
        if blockDoneTries is blockDoneTriesMax
          return false

        if positionFound
          blockDone = true
    return { data: level, blocks: usedBlockIds }

  addBlockToLevel: (id, level, block, position) ->
    for blockY in [0...block.length]
      for blockX in [0...block[blockY].length]
        if block[blockY][blockX] is 1
          # level[position.y + blockY][position.x + blockX] = id
          level[position.y + blockY][position.x + blockX] = 1
    return level

  rotate: (block) ->
    newData = []
    for i in [block.length-1..0]
      for j in [0...block[i].length]
        unless newData.hasOwnProperty(j)
          newData[j] = []
        newData[j].push block[i][j]

    return newData

  flipBlock: (block) ->
    newData = []
    for i in [0...block.length]
      newData[i] = []
      for j in [block[i].length-1..0]
        newData[i].push block[i][j]

    return newData