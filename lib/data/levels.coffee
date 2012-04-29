module.exports =
  levels:
    [
      data: [
        [-1, -1, 1, 1, 1],
        [-1, 1, 1, 1, -1],
        [-1, -1, 1, 1, 1],
        [-1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1]
      ],
      blocks: [1, 2, 3, 4]
    ]

  getRandomLevel: ->
    i = Math.floor(Math.random()*@levels.length)
    return @levels[i]