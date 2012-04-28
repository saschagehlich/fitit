class Player

  playerData: [
    [ 1, 1]
    [-1, 1]
    [-1, 1]
  ]

  tileImage:
    0: '/images/green-tile.png'
    1: '/images/orange-tile.png'
    2: '/images/pink-tile.png'
    3: '/images/blue-tile.png'

  playerInfo:
    posX: 2
    posY: 2
    id: 1
  position: {x:0,y:0}

  initialize: (@context) ->
    return

  draw: ->
    for row in @playerData
      for value in row
        do (value) =>
          x = @playerInfo.posX * 32 + (_j * 32)
          y = @playerInfo.posY * 32 + (_i * 32)
          if value > 0
            # Board.context.fillStyle = 'rgba(200,200,255,1)'
            # Board.context.fillRect x, y, 30, 30
            image = new Image
            image.src = @tileImage[@playerInfo.id]
            console.log image, x, y
            image.onload = => @context.drawImage(image, x, y)

window.FitItPlayer = Player