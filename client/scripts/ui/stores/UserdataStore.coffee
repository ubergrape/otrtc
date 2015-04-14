AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'
assign = require 'object-assign'
ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'
EventEmitter = require('events').EventEmitter


_my_username = null
_my_user_id = null
_status = ChatConstants.USER_STATUS_FRESH
_private_key = null


UserdataStore = assign({}, EventEmitter.prototype, {

  verifying_peer: null

  emitChange: () ->
    @emit(ChatConstants.EVENT_STORE_CHANGED)

  addChangeListener: (callback) ->
    @on(ChatConstants.EVENT_STORE_CHANGED, callback)

  removeChangeListener: (callback) ->
    @removeListener(ChatConstants.EVENT_STORE_CHANGED, callback)

  get_username: () ->
    return _my_username

  get_user_id: () ->
    return _my_user_id

  get_status: () ->
    return _status

  get_private_key: () ->
    return _private_key

  get_my_fingerprint: () ->
    return _private_key.fingerprint()
})


UserdataStore.dispatchToken = AppDispatcher.register (action) =>
  switch action.type
    when ChatConstants.ACTIONTYPE_USERNAME_SUPPLIED
      _my_username = action.username
      _status = ChatConstants.USER_STATUS_GENERATING_KEY
      UserdataStore.emitChange()
      window.setTimeout(() ->
        _private_key = new DSA()
        # this saves the key to the localstore. should only be done during dev
        # if not localStorage['private_key']?
        #   _private_key = new DSA()
        #   localStorage.setItem('private_key', _private_key.packPrivate())
        # _private_key = DSA.parsePrivate(localStorage['private_key'])
        _status = ChatConstants.USER_STATUS_AUTHENTICATING
        UserdataStore.emitChange()
      , 100)
    when ChatConstants.ACTIONTYPE_SHOW_VERIFICATION_BOX
      if action.peer? and action.peer.otr? and action.peer.otr.msgstate == OTR.CONST.MSGSTATE_ENCRYPTED
        UserdataStore.verifying_peer = action.peer
        UserdataStore.emitChange()
      else
        console.log 'cannot verify peer without a secure connection'
    when ChatConstants.ACTIONTYPE_CLOSE_VERIFICATION_BOX
      UserdataStore.verifying_peer = null
      UserdataStore.emitChange()


EventBus.subscribe ChatConstants.EVENT_LOCAL_USER_AUTHENTICATED, (data) =>
  _my_username = data.username
  _my_user_id = data.user_id
  _status = ChatConstants.USER_STATUS_AUTHENTICATED_ON_SERVER
  #so now we no longer have a step between being authenticated and the setup
  #being complete. maybe get rid of USER_STATUS_AUTHENTICATED_ON_SERVER
  _status = ChatConstants.USER_STATUS_SETUP_COMPLETE #TODO
  UserdataStore.emitChange()

# just for dev to speedup login
window.setTimeout(() ->
  AppDispatcher.dispatch(
    type: ChatConstants.ACTIONTYPE_USERNAME_SUPPLIED
    username: 'Alice'
  )
, 100)


module.exports = UserdataStore
