module.exports =
  levels:
    [
      # {
      #   data: [
      #     [-1, -1, 1, 1, -1],
      #     [-1, 1, 1, 1, -1],
      #     [1, 1, 1, 1, -1],
      #     [1, 1, 1, 1, -1],
      #     [-1, -1, 1, 1, 1]
      #   ],
      #   blocks: [
      #     [10, 7, 4, 2],
      #     [2, 13, 7, 4],
      #     [3, 9, 2, 1],
      #     [2, 13, 9, 8],
      #     [8, 1, 4, 13],
      #     [12, 2, 10, 3]
      #   ]
      # },
      {
        data: [
          [1, 1, 1, 1, -1],
          [1, 1, 1, 1, -1],
          [1, 1, 1, 1, -1],
          [1, 1, 1, -1, -1],
          [-1, -1, -1, -1, -1]
        ],
        blocks: [
          [10, 2, 4, 3]
        ]
      }
    ]

  getRandomLevel: ->
    i = Math.floor(Math.random()*@levels.length)
    level = @levels[i]
    blockIndex = Math.round(Math.random()*(level.blocks.length-1))
    console.log "blockIndex", blockIndex
    level.blocks = level.blocks[blockIndex]

    return level