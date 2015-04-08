# AppDispatcher = require '../dispatcher/AppDispatcher.coffee'
EventBus = require '../utils/EventBus.coffee'
ChatConstants = require '../constants/ChatConstants.coffee'
io = require 'socket.io-client'
UserdataStore = require '../ui/stores/UserdataStore.coffee'


SignalingHandler = (room_id) ->
  socket = io()

  socket.on 'remote_user_logon', (data) ->
    EventBus.publish ChatConstants.EVENT_REMOTE_USER_LOGGED_ON,
      user_id: data.user_id
      username: data.username
      create_offer: data.you_should_offer

  socket.on 'remote_user_logoff', (data) ->
    EventBus.publish ChatConstants.EVENT_REMOTE_USER_LOGGED_OFF,
      peer_id: data.user_id

  socket.on 'remote_description', (data) ->
    EventBus.publish ChatConstants.EVENT_REMOTE_DESCRIPTION_RECEIVED,
      peer_id: data.sender_id
      description: data.description

  socket.on 'remote_ice_candidate', (data) ->
    EventBus.publish ChatConstants.EVENT_REMOTE_ICE_CANDIDATE_RECEIVED,
      peer_id: data.sender_id
      candidate: data.candidate

  EventBus.subscribe ChatConstants.EVENT_PEER_LOCAL_DESCRIPTION, (data) ->
    socket.emit 'remote_description',
      recipient_id: data.peer_id
      description: data.description

  EventBus.subscribe ChatConstants.EVENT_PEER_LOCAL_ICE_CANDIDATE, (data) ->
    socket.emit 'remote_ice_candidate',
      recipient_id: data.peer_id
      candidate: data.candidate

  EventBus.subscribe ChatConstants.EVENT_SHUTDOWN_APP, () =>
    if socket?
      socket.disconnect()

  socket.emit('user_auth', {
    username: UserdataStore.get_username()
    room_id: room_id
  }, (data) =>
    EventBus.publish ChatConstants.EVENT_LOCAL_USER_AUTHENTICATED,
      user_id: data.user_id
      username: data.username
    socket.emit('user_ready')
  )

  return @


module.exports = SignalingHandler

