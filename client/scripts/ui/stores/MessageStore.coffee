AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'
assign = require 'object-assign'
ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'
EventEmitter = require('events').EventEmitter
UserdataStore = require './UserdataStore.coffee'


_messages = []


MessageStore = assign({}, EventEmitter.prototype, {
  emitChange: () ->
    @emit(ChatConstants.EVENT_STORE_CHANGED)

  addChangeListener: (callback) ->
    @on(ChatConstants.EVENT_STORE_CHANGED, callback)

  removeChangeListener: (callback) ->
    @removeListener(ChatConstants.EVENT_STORE_CHANGED, callback)

  get_all: () ->
    return _messages
})


MessageStore.dispatchToken = AppDispatcher.register (action) ->
  switch action.type
    when ChatConstants.ACTIONTYPE_MESSAGE_OUTBOUND
      message =
        id: _messages.length
        user_id: UserdataStore.get_user_id()
        username: UserdataStore.get_username()
        text: action.text
        time: new Date()
        type: 'message'
      _messages.push(message)
      MessageStore.emitChange()
      EventBus.publish ChatConstants.EVENT_MESSAGE_OUTBOUND, message
    when ChatConstants.ACTIONTYPE_MESSAGE_INBOUND
      message =
        id: _messages.length
        user_id: action.message.user_id
        username: action.message.username
        text: action.message.text
        time: new Date()
        type: 'message'
      _messages.push(message)
      MessageStore.emitChange()
    when ChatConstants.ACTIONTYPE_SMP_INBOUND
      message =
        id: _messages.length
        user_id: action.peer.id
        username: action.peer.username
        peer: action.peer
        question: action.question
        time: new Date()
        type: 'smp_request'
      _messages.push(message)
      MessageStore.emitChange()


module.exports = MessageStore
