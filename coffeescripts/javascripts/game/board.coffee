class Board

  boardData: {}

  grid:
    width: 15
    height: 13

  initialize: (@context, @boardData) ->
    return

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