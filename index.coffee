express    = require "express"
socketio   = require "socket.io"
gameserver = require "./lib/gameserver"

app = express.createServer()
io  = socketio.listen(app)


###
  Express.js routes
###

app.get "/", (req, res) ->
  res.render "index/index.jade"

###
  Launch gameserver
###
gs = global.gs = new gameserver(io)

app.listen 8080
console.log "Listening to 0.0.0.0:8080"