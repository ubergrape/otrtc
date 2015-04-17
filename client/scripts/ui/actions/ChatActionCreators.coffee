AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'

module.exports =
  create_message: (text) ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_MESSAGE_OUTBOUND
      text: text
    )

  receive_message: (message) ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_MESSAGE_INBOUND
      message: message
    )

  login_user: (username) ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_USERNAME_SUPPLIED
      username: username
    )

  verify_peer: (peer) ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_SHOW_VERIFICATION_BOX
      peer: peer
    )

  close_verification_box: () ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_CLOSE_VERIFICATION_BOX
    )

  toggle_verified: (peer) ->
    if peer.verified
      AppDispatcher.dispatch(
        type: ChatConstants.ACTIONTYPE_UNVERIFY_PEER
        peer: peer
      )
    else
      AppDispatcher.dispatch(
        type: ChatConstants.ACTIONTYPE_VERIFY_PEER
        peer: peer
      )

  init_smp: (peer, secret, question) ->
    EventBus.publish ChatConstants.EVENT_SMP_OUTBOUND,
      peer: peer
      secret: secret
      question: question

  answer_smp: (peer, question) ->
    AppDispatcher.dispatch
      type: ChatConstants.ACTIONTYPE_SHOW_SMP_BOX
      peer: peer
      question: question

  send_smp_answer: (peer, secret) ->
    EventBus.publish ChatConstants.EVENT_SMP_OUTBOUND,
      peer: peer
      secret: secret

  close_smp_box: () ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_CLOSE_SMP_BOX
    )

  deactivate_smp_request_messages: (peer_id) ->
    AppDispatcher.dispatch(
      type: ChatConstants.ACTIONTYPE_DEACTIVATE_SMP_REQUEST_MESSAGES
      peer_id: peer_id
    )

