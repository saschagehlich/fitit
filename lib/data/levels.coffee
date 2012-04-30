module.exports =
  levels:
    [
      {
        id: 1
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
        id: 2
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
        id: 3
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
        id: 4
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
        id: 5
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
    copy = {
      data: @levels[i].data
    }
    blockIndex = Math.floor(Math.random()*@levels[i].blocks.length)
    copy.blocks = @levels[i].blocks[blockIndex].slice(0)

    return copy