Levels = require "../data/levels"
Blocks = require "../data/blocks"
Player = require "../class/player"
EventEmitter = require("events").EventEmitter

module.exports = class extends EventEmitter
  players: []
  playerId: 0
  colors: ['green', 'orange', 'pink', 'blue']
  tmpColors: []

  constructor: (@io, @server) ->
    @id = +new Date()
    @tmpColors = @colors.slice(0)

    @level = Levels.getRandomLevel()
    @board = {}

    # create empty board
    for i in [0...13]
      for j in [0...15]
        unless @board.hasOwnProperty i
          @board[i] = {}

        @board[i][j] = -1

    # put level into board
    for i in [0...5]
      for j in [0...5]
        @board[4+i][5+j] = @level.data[i][j]

  addPlayer: (player) ->
    @playerId++
    player.id = @playerId

    player.color = @tmpColors[0]
    player.blockId = @level.blocks[0]
    player.block = Blocks.blocks[player.blockId]

    switch @colors.indexOf(player.color)
      when 0
        player.position = { x: 1, y: 1 }
      when 1
        player.position = { x: Object.keys(@board[0]).length - player.block[0].length - 1, y: 1 }
      when 2
        player.position = { x: Object.keys(@board[0]).length - player.block[0].length - 1, y: Object.keys(@board).length - player.block.length - 1 }
      when 3
        player.position = { x: 1, y: Object.keys(@board).length - player.block.length - 1 }

    @tmpColors.shift()
    @level.blocks.shift()

    @players.push(player)
    player.socket.join("game-#{@id}")

    players = {}
    for player in @players
      players[player.id] = player.safeObj()

    player.socket.emit "gamedata",
      board: @board
      players: players

    @broadcastPlayerJoin(player)

    player.socket.on "move", (direction) => @onPlayerMove player, direction
    player.socket.on "rotation", (direction) => @onPlayerRotation player, direction
    player.socket.on "flip", => @onPlayerFlip player
    player.socket.on "disconnect", => @onPlayerDisconnect player

  startGame: ->
    @broadcastInitialData()


  checkBounds: (player, direction) =>
    switch direction
      when 0 # right
        player.position.x + player.block[0].length < Object.keys(@board[0]).length
      when 1 # down
        player.position.y + player.block.length < Object.keys(@board).length
      when 2 # left
        player.position.x > 0
      when 3 # up
        player.position.y > 0

  checkSolved: =>
    matchedTiles = 0
    fittingTiles = 0
    boardCopy = {}

    for key, val of @board
      boardCopy[key] ?= {}
      for k, v of val
        boardCopy[key][k] = v
        if v is 1
          fittingTiles++

    for player in @players
      for i in [0...player.block.length]
        for j in [0...player.block[i].length]
          y = player.position.y + i
          x = player.position.x + j
          if boardCopy[y][x] is 1 and player.block[i][j] is 1
            boardCopy[y][x] = 2
            matchedTiles++

    # console.log "#{matchedTiles} / #{fittingTiles}"
    if matchedTiles is fittingTiles
      @emit "solved"
      usersToKick = @players.slice(0)
      for player in usersToKick
        player.socket.emit "winning"
        player.socket.leave("game-#{@id}")
        @players.splice @players.indexOf(player), 1

  fixPlayerPosition: (player) =>
    if parseInt(player.position.x) + parseInt(player.block[0].length) >= Object.keys(@board[0]).length
      player.position.x = Object.keys(@board[0]).length - player.block[0].length

    if parseInt(player.position.y) + parseInt(player.block.length) >= Object.keys(@board).length
      player.position.y = Object.keys(@board).length - player.block.length

  onPlayerMove: (player, direction) =>
    if @checkBounds(player, direction)
      switch direction
        when 0
          player.position.x += 1
        when 1
          player.position.y += 1
        when 2
          player.position.x -= 1
        when 3
          player.position.y -= 1

      @broadcastMove player
      @checkSolved()

  onPlayerRotation: (player, direction) =>
    player.rotateBlock()
    @fixPlayerPosition player
    @broadcastMove player
    @checkSolved()

  onPlayerFlip: (player) =>
    player.flipBlock()
    @broadcastMove player
    @checkSolved()

  onPlayerDisconnect: (player) =>
    if ~@players.indexOf(player)
      @players.splice @players.indexOf(player), 1
      
      @tmpColors.push player.color
      @level.blocks.push player.blockId
      @broadcastPlayerLeave player

      # is there a player in the queue? ADD DAT BITCH!
      if waitingSocket = @server.getLongestWaitingSocket()
        player = new Player(waitingSocket)
        @addPlayer player

  broadcastInitialData: ->
    players = {}
    for player in @players
      players[player.id] = player.safeObj()

    @io.sockets.in("game-#{@id}").emit "gamedata",
      board: @board
      players: players    

  broadcastMove: (movingPlayer) ->
    for player in @players
      player.socket.emit "move", movingPlayer.safeObj()

  broadcastPlayerJoin: (newPlayer) ->
    for player in @players
      unless player is newPlayer
        player.socket.emit "player_join", newPlayer.safeObj()    

  broadcastPlayerLeave: (leftPlayer) ->
    for player in @players
      player.socket.emit "player_leave", leftPlayer.safeObj()    
