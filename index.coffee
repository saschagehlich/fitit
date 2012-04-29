express    = require "express"
socketio   = require "socket.io"
gameserver = require "./lib/gameserver"

app = express.createServer()
io  = socketio.listen(app)
io.set "log level", 1

app.configure ->
  
  # app.use(express.logger())
  app.use(express.cookieParser())
  app.use(express.bodyParser())
  app.use(express.methodOverride())

  app.use express.session
    secret: "oiw309409d9005"
    cookie:
      maxAge: 3600 * 24 * 30 * 1000

  app.use require("stylus").middleware
    src: __dirname + '/public'
    compress: true
    debug: true

  app.use express.compiler
    src: __dirname + '/coffeescripts'
    dest: __dirname + '/public'
    enable: ["coffeescript"]
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))


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