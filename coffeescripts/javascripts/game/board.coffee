class Board

  boardData: {}

  grid:
    width: 15
    height: 13

  # data[row][col]
  hittingSpace:
    0:
      2: 1
      3: 1
      4: 1
    1: 
      2: 1
      3: 1
      4: 1
    2:
      2: 1
      3: 1
      4: 1
    3:
      2: 1
      3: 1
      4: 1
    4:
      0: 1
      1: 1
      2: 1
      3: 1
      4: 1
    sum: 17

  initialize: (@context) ->
    # create initial board data
    for i in [0...@grid.height]
      for j in [0...@grid.width]
        @boardData[i] or= {}
        @boardData[i][j] = null

    # set checkable tiles
    for i in [0...5]
      for j in [0...5]
        @boardData[4+i][5+j] = @hittingSpace[i][j]

  draw: ->
    # clear canvas
    @context.clearRect(800, 640)

    for rowIndex, row of @boardData
      for colIndex, value of row
        do (value, colIndex, rowIndex) =>
          x = colIndex * 32
          y = rowIndex * 32
          image = new Image
          if value > 0
            image.src = '/images/fitting-tile.png'
          else
            image.src = '/images/default-tile.png'
          image.onload = => @context.drawImage(image, x, y)

window.FitItBoard = Board