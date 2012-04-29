module.exports =
  levels:
    [
      data: [
        [1, 1, 1, 1, -1],
        [1, 1, 1, 1, -1],
        [1, 1, 1, 1, -1],
        [1, 1, 1, -1, -1],
        [-1, -1, -1, -1, -1]
      ],
      blocks: 
        [
          [10,2,4,3],
          [9,12,2,13]
        ]
    ]

  getRandomLevel: ->
    i = Math.floor(Math.random()*@levels.length)
    level = @levels[i]
    blockIndex = Math.round(Math.random()*level.blocks.length-1)
    console.log blockIndex
    level.blocks = level.blocks[blockIndex]

    return level