module.exports =
  levels:
    [
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
      },
      {
        data: [
          [-1, -1, 1, 1, 1],
          [1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1],
          [1, 1, 1, -1, -1],
          [1, 1, 1, -1, -1]
        ],
        blocks: [
          [10, 1, 7, 3]
        ]
      },
      {
        data: [
          [-1, -1, -1, -1, -1],
          [-1, -1, 1, 1, 1],
          [-1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1],
          [-1, 1, 1, 1, 1]
        ],
        blocks: [
          [8, 11, 9, 13]
        ]
      },
      {
        data: [
          [-1, -1, -1, -1, 1],
          [-1, -1, 1, 1, 1],
          [-1, -1, 1, 1, 1],
          [1, 1, 1, 1, 1],
          [1, 1, -1, 1, 1]
        ],
        blocks: [
          [2, 3, 1, 12],
          [7, 11, 2, 12]
        ]
      },
      {
        data: [
          [1, 1, 1, 1, 1],
          [1, 1, 1, 1, 1],
          [1, 1, 1, -1, -1],
          [1, 1, 1, -1, -1],
          [-1, -1, -1, -1, -1]
        ],
        blocks: [
          [10, 11, 12, 3]
        ]
      }
    ]

  getRandomLevel: ->
    i = Math.floor(Math.random()*@levels.length)
    level = @levels[i]
    blockIndex = Math.floor(Math.random()*level.blocks.length)
    console.log "blockIndex", blockIndex
    level.blocks = level.blocks[blockIndex].slice(0)

    return level