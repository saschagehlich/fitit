class Board

  boardData: {}

  grid:
    width: 15
    height: 13

  initialize: (@context, @boardData) ->
    @fittingImage = new Image()
    @fittingImage.src = "/images/fitting-tile.png"
    return

  draw: ->
    for rowIndex, row of @boardData
      for colIndex, value of row
        do (value, colIndex, rowIndex) =>
          x = colIndex * 32
          y = rowIndex * 32
          if value > 0
            @context.drawImage(@fittingImage, x, y)

window.FitItBoard = Board