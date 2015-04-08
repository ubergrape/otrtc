
RoomsManager = () ->
  @_id_counter = 0
  @rooms = {}
  return @


RoomsManager.prototype.add_user = (user, room_id) ->
  room_id = String(room_id)
  user_id = String(user.id)
  if room_id not in @rooms
    @rooms[room_id] = {}
  @rooms[room_id][user_id] = user


RoomsManager.prototype.create_user = (username, room_id, socket) ->
  room_id = String(room_id)
  user_id = String(@_id_counter)
  @_id_counter += 1
  user = {
      id: user_id
      username: username
      room_id: room_id
      socket: socket
  }
  if not @rooms[room_id]?
    @rooms[room_id] = {}
  @rooms[room_id][user_id] = user
  return user


RoomsManager.prototype.get_users_in_room = (room_id) ->
  room_id = String(room_id)
  if @rooms[room_id]?
    return @rooms[room_id]
  else
    return {}


RoomsManager.prototype.delete_user = (room_id, user_id) ->
  room_id = String(room_id)
  user_id = String(user_id)
  if @rooms[room_id]?[user_id]?
    delete @rooms[room_id][user_id]
    if @_is_room_empty(room_id)
      delete @rooms[room_id]


RoomsManager.prototype._is_room_empty = (room_id) ->
  users_in_room = 0
  for key, value of @get_users_in_room(room_id)
    users_in_room += 1
  return users_in_room == 0


RoomsManager.prototype.get_user = (room_id, user_id) ->
  room_id = String(room_id)
  user_id = String(user_id)
  if @rooms[room_id]?[user_id]?
    return @rooms[room_id][user_id]
  else
    return null


module.exports = RoomsManager

