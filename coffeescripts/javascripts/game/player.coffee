class Player

  # playerData: [
  #   [ 1, 1]
  #   [-1, 1]
  #   [-1, 1]
  # ]

  tileImage:
    0: '/images/green-tile.png'
    1: '/images/orange-tile.png'
    2: '/images/pink-tile.png'
    3: '/images/blue-tile.png'

  # playerInfo:
  #   posX: 2
  #   posY: 2
  #   id: 1
  # position: {x:0,y:0}

  initialize: (@context, @playerData) ->
    return

  draw: ->
    for row in @playerData.block
      for value in row
        do (value) =>
          x = @playerData.position.x * 32 + (_j * 32)
          y = @playerData.position.y * 32 + (_i * 32)
          if value > 0
            image = new Image
            image.src = @tileImage[@playerData.id]
            image.onload = => @context.drawImage(image, x, y)

window.FitItPlayer = Player