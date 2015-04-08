AppDispatcher = require '../dispatcher/AppDispatcher.coffee'
assign = require 'object-assign'
ChatConstants = require '../constants/ChatConstants.coffee'
EventBus = require '../utils/EventBus.coffee'
EventEmitter = require('events').EventEmitter
Peer = require './Peer.coffee'


PeerManager = assign({}, EventEmitter.prototype, {
  _peers: {}
  get_peers: () ->
    return @_peers
})


EventBus.subscribe ChatConstants.EVENT_REMOTE_USER_LOGGED_ON, (data) =>
  if data.user_id not in PeerManager._peers
    peer = new Peer(data.user_id, data.username, data.create_offer)
    PeerManager._peers[data.user_id] = peer
    PeerManager.emit ChatConstants.EVENT_STORE_CHANGED

EventBus.subscribe ChatConstants.EVENT_PEER_STATUS_CHANGED, (data) =>
  if data.new_status == ChatConstants.PEER_STATUS_DISCONNECTED && data.new_status != data.old_status
    if PeerManager._peers[data.peer_id]?
      window.setTimeout(() =>
        delete PeerManager._peers[data.peer_id]
        PeerManager.emit ChatConstants.EVENT_STORE_CHANGED
      , 3000)
  else
    PeerManager.emit ChatConstants.EVENT_STORE_CHANGED

AppDispatcher.register (action) ->
  switch action.type
    when ChatConstants.ACTIONTYPE_VERIFY_PEER
      action.peer.verified = true
      PeerManager.emit ChatConstants.EVENT_STORE_CHANGED
    when ChatConstants.ACTIONTYPE_UNVERIFY_PEER
      action.peer.verified = false
      PeerManager.emit ChatConstants.EVENT_STORE_CHANGED

module.exports = PeerManager

