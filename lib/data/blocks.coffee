module.exports = class
  constructor: ->
    @blocks =
      1: [
        [1, 1, -1],
        [-1, 1, -1],
        [-1, 1, 1]
      ],
      2: [
        [1, 1],
        [1, -1],
        [1, -1]
      ],
      3: [
        [1, 1],
        [1, 1]
      ],
      4: [
        [1],
        [1]
      ],
      5: [
        [1, 1, 1, 1]
      ],
      6: [
        [1, 1, 1, 1]
      ],
      7: [
        [1, 1, 1],
        [-1, 1, 1]
      ],
      8: [
        [-1, 1, 1],
        [1, 1, -1]
      ],
      9: [
        [1, 1, 1]
      ],
      10: [
        [1, 1, 1, 1],
        [-1, -1, -1, 1]
      ],
      11: [
        [1, 1, 1],
        [-1, 1, -1]
      ],
      12: [
        [1, 1],
        [1, -1]
      ],
      13: [
        [-1, 1],
        [1, 1],
        [-1, 1],
        [-1, 1]
      ]

  getRandomBlock: ->
    i = Math.floor(Math.random() * Object.keys(@blocks).length)
    return @blocks[Object.keys(@blocks)[i]]

  getRandomBlockWithId: ->
    i = Math.floor(Math.random() * Object.keys(@blocks).length)
    return [@blocks[Object.keys(@blocks)[i]], Object.keys(@blocks)[i]]