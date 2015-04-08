RoomsManager = require '../RoomsManager.coffee'


module.exports =
  setUp: (cb) ->
    @rm = new RoomsManager()
    cb()

  test_empty_room: (test) ->
    test.deepEqual(@rm.get_users_in_room(123), {}, 'Room shoul be empty')
    test.done()

  test_create_user: (test) ->
    @rm.create_user('Alice', 4567890, null)
    expected = { '4567890': { '0': { id: '0', username: 'Alice', room_id: '4567890', socket: null } } }
    test.deepEqual(@rm.rooms, expected, 'The first user should be Alice')
    test.done()

  test_get_users_in_room: (test) ->
    @rm.create_user('Alice', 4567890, null)
    expected = { '0': { id: '0', username: 'Alice', room_id: '4567890', socket: null } }
    test.deepEqual(@rm.get_users_in_room(4567890), expected, 'The first user should be Alice')
    test.done()

  test_delete_user: (test) ->
    a = @rm.create_user('Alice', 4567890, null)
    b = @rm.create_user('Bob', 345678, null)
    c = @rm.create_user('Charlie', 4567890, null)
    expected =
      '4567890':
        '0': { id: '0', username: 'Alice', room_id: '4567890', socket: null }
        '2': { id: '2', username: 'Charlie', room_id: '4567890', socket: null }
      '345678':
        '1': { id: '1', username: 'Bob', room_id: '345678', socket: null }
    test.deepEqual(@rm.rooms, expected, 'Alice and Charlie should be in the same room and Bob in another one')
    test.done()

  test_delete_last_user_in_room: (test) ->
    a = @rm.create_user('Alice', 4567890, null)
    b = @rm.create_user('Bob', 345678, null)
    c = @rm.create_user('Charlie', 4567890, null)
    @rm.delete_user(345678, b.id)
    @rm.delete_user(4567890, a.id)
    expected =
      '4567890':
        '2': { id: '2', username: 'Charlie', room_id: '4567890', socket: null }
    test.deepEqual(@rm.rooms, expected, 'Only one room Charlie should exist')
    test.done()

  test_get_user_by_id: (test) ->
    a = @rm.create_user('Alice', 4567890, null)
    b = @rm.create_user('Bob', 345678, null)
    c = @rm.create_user('Charlie', 4567890, null)
    test.deepEqual(@rm.get_user(4567890, 2), c, 'We should receive Charlie')
    test.deepEqual(@rm.get_user(345678, 1), b, 'We should receive Bob')
    test.deepEqual(@rm.get_user(4567890, 1), null, 'We should receive no user')
    test.done()

