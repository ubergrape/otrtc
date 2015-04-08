RoomsManager = require './RoomsManager'

rm = new RoomsManager()


_handle_user_connect = (socket) ->
  return


_handle_user_auth = (data, socket) ->
  return rm.create_user(data.username, data.room_id, socket)


_handle_user_ready = (user) ->
  for key, other_user of rm.get_users_in_room(user.room_id)
    if other_user.id != user.id
      #the user with the lower ID should offer and the other should answer
      should_user_offer = user.id < other_user.id
      other_user.socket.emit 'remote_user_logon', {
        user_id: user.id
        username: user.username
        you_should_offer: !should_user_offer
      }
      user.socket.emit 'remote_user_logon', {
        user_id: other_user.id
        username: other_user.username
        you_should_offer: should_user_offer
      }


_handle_remote_description = (data, user) ->
  recipient = rm.get_user(user.room_id, data.recipient_id)
  if recipient
    recipient.socket.emit 'remote_description', {
      sender_id: user.id
      description: data.description
    }


_handle_remote_ice_candidate = (data, user) ->
  recipient = rm.get_user(user.room_id, data.recipient_id)
  if recipient
    recipient.socket.emit 'remote_ice_candidate', {
      sender_id: user.id
      candidate: data.candidate
    }


_handle_user_disconnect = (data, user) ->
  rm.delete_user(user.room_id, user.id)
  for id, other_user of rm.get_users_in_room(user.room_id)
    other_user.socket.emit 'remote_user_logoff', {
      user_id: user.id
    }


module.exports = {
  connect_user: (socket) ->
    user = null

    socket.on 'user_auth', (data, callback) ->
      user = _handle_user_auth(data, socket)
      callback({user_id: user.id, username: user.username})

    socket.on 'user_ready', (data) ->
      if user? then _handle_user_ready(user)

    socket.on 'remote_description', (data) ->
      if user? then _handle_remote_description(data, user)

    socket.on 'remote_ice_candidate', (data) ->
      if user? then _handle_remote_ice_candidate(data, user)

    socket.on 'disconnect', (data) ->
      if user? then _handle_user_disconnect(data, user)
}
