express = require('express')
app = express()
swig = require('swig')
http = require('http').Server(app)
io = require('socket.io')(http)
uuid = require('node-uuid')
Usermanager = require('./usermanager')


app.engine('html', swig.renderFile)
app.set('view engine', 'html')
app.set('views', __dirname + '/views')
app.set('view cache', true)
swig.setDefaults({ cache: false })

app.use('/static', express.static(__dirname + '/static'))

app.get '/', (req, res) ->
  res.redirect('/room/' + uuid.v4())

app.get '/room/:room_id', (req, res) ->
  room_id = req.params.room_id
  res.render('room', {room_id: room_id})

io.on 'connection', Usermanager.connect_user

  # socket.on 'chat message', (msg) ->
  #   console.log('message by ' + 0 + ': ' + msg)
  #   io.emit 'chat message', {username: 0, text: msg}
  # socket.on 'disconnect', () ->
  #   console.log('user ' + 0 + ' disconnected')

  # socket.on 'auth', (data) ->
  #   socket.emit 'auth', {
  #     token: uuid.v4()
  #     id: 0
  #   }
  #   console.log 'connected user ' + data.name + ' with token ' + data.token

port = process.env.PORT || 9000

http.listen port, () ->
  console.log('listening on *:' + port)

