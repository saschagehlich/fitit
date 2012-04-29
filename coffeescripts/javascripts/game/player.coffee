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

  draw: ->
    for row in @playerData.block
      for value in row
        do (value) =>
          x = @playerData.position.x * 32 + (_j * 32)
          y = @playerData.position.y * 32 + (_i * 32)
          if value > 0
            @context.drawImage(@tileImages[@playerData.color], x, y)

window.FitItPlayer = Player