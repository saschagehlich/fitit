class Player

  tileImageURLs:
    'green': '/images/green-tile.png'
    'orange': '/images/orange-tile.png'
    'pink': '/images/pink-tile.png'
    'blue': '/images/blue-tile.png'

  tileImages: {}

  constructor: (@context, @playerData) ->

    for key, image of @tileImageURLs
      i = new Image
      i.src = image

      @tileImages[key] = i

  draw: (boardData, overlappingTile) ->
    for row in @playerData.block
      for value in row
        do (value) =>
          playerPosition =
            x: @playerData.position.x + _j
            y: @playerData.position.y + _i
          x = playerPosition.x * 32
          y = playerPosition.y * 32
          
          if value > 0
            @context.drawImage(@tileImages[@playerData.color], x, y)

            # draw stop sign if not on fitted tile
            if boardData[playerPosition.y][playerPosition.x] is -1
              @context.drawImage overlappingTile, x, y

window.FitItPlayer = Player