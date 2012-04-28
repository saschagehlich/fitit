module.exports =
  spaces:
    [
      [
        [-1, -1, 1, 1, 1],
        [-1, 1, 1, 1, -1],
        [-1, -1, 1, 1, 1],
        [-1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1]
      ]
    ]

  getRandomSpace: ->
    i = Math.floor(Math.random()*@spaces.length)
    return @spaces[i]