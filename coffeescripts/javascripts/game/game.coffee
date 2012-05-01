window.every = (t, f) -> setInterval f, t
window.after = (t, f) -> setTimeout f, t

window.FitItGame = FitItGame = class
  name: null
  constructor: (io) ->
    @socket = io.connect "http://#{window.location.hostname}:8080"
    @socket.on "connect", @onConnect
    @context = $('#screen').get(0).getContext('2d')

    @prepareSounds()

    @overlappingTile = new Image()
    @overlappingTile.src = "/images/overlap-tile.png"

    $('.winning').click =>
      location.reload()
      # $('.winning').fadeOut "slow"
      # @changeToWaitingView()
      # @socket.emit "name", @name

  prepareSounds: ->
    if document.cookie.match /mute=on/i
      $('.sound').removeClass("on").addClass("off")
      soundManager.mute()

    $('.sound').click ->
      if $(this).hasClass "on"
        $(this).removeClass("on").addClass "off"
        soundManager.mute()

        document.cookie = "mute=on"
      else
        $(this).removeClass("off").addClass "on"
        soundManager.unmute()

        document.cookie = "mute=off"

    soundManager.onload = ->
      subway = soundManager.createSound
        id: "subway"
        url: [ '/audio/subway.mp3', '/audio/subway.aac', '/audio/subway.ogg' ]
        volume: 50
        autoLoad: true
        onload: ->
          loopBackground = ->
            subway.play
              onfinish: ->
                loopBackground()
          loopBackground()

      dingdong = soundManager.createSound
        id: "dingdong"
        url: [ '/audio/dingdong.mp3', '/audio/dingdong.aac', '/audio/dingdong.ogg' ]
        volume: 100
        autoLoad: true

      success = soundManager.createSound
        id: "success"
        url: [ '/audio/success.mp3', '/audio/success.aac', '/audio/success.ogg' ]
        volume: 100
        autoLoad: true

  onConnect: =>
    @socket.on "gamedata", @onGamedata
    @socket.on "move", @onPlayerMoved
    @socket.on "player_join", @onPlayerJoined
    @socket.on "player_leave", @onPlayerLeave
    @socket.on "queue_length", @onQueueLengthChanged
    @socket.on "winning", @onWinning
    @socket.on "game_ended", @onGameEnded

    @bindNameInput()

  onGameEnded: (err) =>
    alert "The game has ended due to this reason: #{err}"
    location.reload()

  onWinning: ->
    soundManager.play "success"
    after 1000, ->
      $('.winning').fadeIn 'fast'
      @players = {}

  onGamedata: (data) =>
    soundManager.play "dingdong"

    @changeToGameView(data.players)
    unless @board
      @board = new FitItBoard
    @board.initialize @context, data.board
    @players = {}
    for key, player of data.players
      newPlayer = new FitItPlayer @context, player
      @players[player.id] = newPlayer
    @startGameLoop()

  onQueueLengthChanged: (newLength) ->
    $('.waiting-for').text(4-parseInt(newLength))

  changeToWaitingView: ->
    $(document).unbind "keydown"
    $('.players, canvas#screen').fadeOut 'fast'
    $('.info, .waiting').fadeIn 'fast'

  changeToGameView: (players) ->
    @bindKeys()
    $('.info, .waiting').fadeOut 'fast'
    $('.players').empty()
    for key, player of players
      li = $('<li>')
      playerCanvas = $('<canvas>').attr(id: 'player-' + player.id, width: '32', height: '32').addClass('player-canvas')
      li.append playerCanvas
      li.append $('<span>').addClass('player-name').text(player.name)
      $('.players').append li

      @drawPlayerCanvas(playerCanvas, player.block, player.color)
    $('.players, canvas#screen').fadeIn 'fast'

  drawPlayerCanvas: (canvas, block, color) ->
    ###
      Draw the player's block into the canvas
    ###
    tile = new Image()
    tile.src = '/images/' + color + '-tile.png'

    tile.onload = ->
      tileSize = Math.floor(Math.min(canvas.width() / block[0].length, canvas.height() / block.length))

      context = $(canvas)[0].getContext '2d'
      
      for blockY in [0...block.length]
        for blockX in [0...block[blockY].length]
          if block[blockY][blockX] isnt -1
            paddingX = Math.round( ( 32 - ( block[blockY].length * tileSize ) ) / 2) * -1
            paddingY = Math.round( ( 32 - ( block.length * tileSize ) ) / 2) * -1
            context.drawImage tile, 0, 0, 32, 32, blockX * tileSize - paddingX, blockY * tileSize - paddingY, tileSize, tileSize


  bindKeys: ->
    $(document).unbind "keydown"
    $(document).keydown (event) =>
      switch event.keyCode
        when 37 # arrow left
          @socket.emit 'move', 2
          return false
        when 38 # arrow up
          @socket.emit 'move', 3
          return false
        when 39 # arrow right
          @socket.emit 'move', 0
          return false
        when 40 # arrow down
          @socket.emit 'move', 1
          return false
        when 32 # space
          @socket.emit 'rotation', 1
          return false
        when 70 # flip
          @socket.emit 'flip'
          return false

  bindNameInput: ->
    $('form').submit (event) =>
      event.preventDefault()
      if $('input').val()
        @name = $('input').val()

        @socket.emit 'name', $('input').val()
        # hide input
        $('.enter-name').fadeOut 'fast'
        $('.waiting').fadeIn 'fast'
        $('form').unbind "submit"
        $('form').submit ->
          return false
        
  onPlayerMoved: (playerData) =>
    if @players.hasOwnProperty(playerData.id)
      @players[playerData.id].playerData = playerData

  onPlayerJoined: (playerData) =>
    @players[playerData.id] = new FitItPlayer @context, playerData

  onPlayerLeave: (playerData) =>
    i = 0
    for key, player of @players
      if parseInt(key) is parseInt(playerData.id)
        delete @players[playerData.id]
        break
      i++


  startGameLoop: ->
    every 1000 / 30, =>
      @detectOverlappingPlayers()
      @draw()


  detectOverlappingPlayers: ->
    @overlappingData = {}

    for key, player of @players
      playerBlock = player.playerData.block
      playerPosition = player.playerData.position

      for playerBlockY in [0...playerBlock.length]
        for playerBlockX in [0...playerBlock[playerBlockY].length]
          # player tile position on board
          tilePositionY = playerPosition.y + playerBlockY
          tilePositionX = playerPosition.x + playerBlockX

          # set if undefined
          @overlappingData[tilePositionY] ?= {}
          @overlappingData[tilePositionY][tilePositionX] ?= -1
          
          # if current tile is an actual player tile
          if playerBlock[playerBlockY][playerBlockX] isnt -1

            # if no player tile is on the current tile postion
            if @overlappingData[tilePositionY][tilePositionX] is -1
              @overlappingData[tilePositionY][tilePositionX] = 0
            else
              # there is already a player tile on this position
              @overlappingData[tilePositionY][tilePositionX] = 1 # overlapping!

  drawOverlappingBlocks: ->
    for tilePositionY, overlappingRow of @overlappingData
      for tilePositionX, isOverlapping of overlappingRow
        if isOverlapping is 1
          @context.drawImage @overlappingTile, tilePositionX * 32, tilePositionY * 32  

  ###
    Only drawing code here, please!
  ###
  draw: ->
    @context.clearRect 0, 0, @context.canvas.width, @context.canvas.height
    @board.draw()
    for key, player of @players
      player.draw(@board.boardData, @overlappingTile)
    @drawOverlappingBlocks()


window.FitItHelper ?= {}
window.FitItHelper.centerWrapper = ->
  wrapperWidth = 970
  wrapperHeight = 585
  windowWidth = $(window).width()
  windowHeight = $(window).height()
  left = (windowWidth - wrapperWidth)/2
  top  = (windowHeight - wrapperHeight)/2
  $('#wrapper').css
    top: top
    left: left


$ ->
  FitItHelper.centerWrapper()
  $(window).resize ->
    FitItHelper.centerWrapper()
  $('input').focus()

