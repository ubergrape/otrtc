AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'
assign = require 'object-assign'
ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'
EventEmitter = require('events').EventEmitter


PeerVerificationStore = assign({}, EventEmitter.prototype, {

  verification_data: null

  emitChange: () ->
    @emit(ChatConstants.EVENT_STORE_CHANGED)

  addChangeListener: (callback) ->
    @on(ChatConstants.EVENT_STORE_CHANGED, callback)

  removeChangeListener: (callback) ->
    @removeListener(ChatConstants.EVENT_STORE_CHANGED, callback)
})


PeerVerificationStore.dispatchToken = AppDispatcher.register (action) =>
  switch action.type
    when ChatConstants.ACTIONTYPE_SHOW_VERIFICATION_BOX
      if action.peer? and action.peer.otr? and action.peer.otr.msgstate == OTR.CONST.MSGSTATE_ENCRYPTED
        PeerVerificationStore.verification_data =
          peer: action.peer
          my_fingerprint: _private_key.fingerprint()
          peer_fingerprint: action.peer.otr.their_priv_pk.fingerprint()
        PeerVerificationStore.emitChange()
      else
        console.log 'cannot verify peer without a secure connection'
    when ChatConstants.ACTIONTYPE_CLOSE_VERIFICATION_BOX
      PeerVerificationStore.verification_data = null
      PeerVerificationStore.emitChange()


module.exports = PeerVerificationStore
