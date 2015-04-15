ChatConstants = require '../constants/ChatConstants.coffee'
SignalingHandler = require './SignalingHandler.coffee'
UserdataStore = require '../ui/stores/UserdataStore.coffee'


ConnectionCoordinator = (room_id) ->
  UserdataStore.on ChatConstants.EVENT_STORE_CHANGED, () =>
    username = UserdataStore.get_username()
    # if username? and not @signaling_handler?
    if UserdataStore.get_status() == ChatConstants.USER_STATUS_AUTHENTICATING
      @signaling_handler = new SignalingHandler(room_id)

  return @


module.exports = ConnectionCoordinator
