class Player

  tileImageURLs:
    'green': '/images/green-tile.png'
    'green-transparent': '/images/green-tile-transparent.png'
    'orange': '/images/orange-tile.png'
    'orange-transparent': '/images/orange-tile-transparent.png'
    'pink': '/images/pink-tile.png'
    'pink-transparent': '/images/pink-tile-transparent.png'
    'blue': '/images/blue-tile.png'
    'blue-transparent': '/images/blue-tile-transparent.png'

  tileImages: {}

  constructor: (@context, @playerData) ->

    for key, image of @tileImageURLs
      i = new Image
      i.src = image

      @tileImages[key] = i

  draw: (boardData) ->
    for row in @playerData.block
      for value in row
        do (value) =>
          playerPosition =
            x: @playerData.position.x + _j
            y: @playerData.position.y + _i
          x = playerPosition.x * 32
          y = playerPosition.y * 32
          
          if value > 0
            # draw transparent tile if not on fitted tile
            if boardData[playerPosition.y][playerPosition.x] is -1
              @context.drawImage @tileImages[@playerData.color + '-transparent'], x, y
            else
              @context.drawImage(@tileImages[@playerData.color], x, y)

window.FitItPlayer = Player