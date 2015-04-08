AppDispatcher = require '../dispatcher/AppDispatcher.coffee'
ChatConstants = require '../constants/ChatConstants.coffee'
EventBus = require '../utils/EventBus.coffee'
PeerManager = require '../transport/PeerManager.coffee'
UserdataStore = require '../ui/stores/UserdataStore.coffee'


Crypto = () ->
  EventBus.subscribe ChatConstants.EVENT_PEER_STATUS_CHANGED, (data) =>
    if data.new_status == ChatConstants.PEER_STATUS_CONNECTED
      #peer is connected, initiate OTR protocol
      peer = data.peer
      peer.otr = new OTR( {priv: UserdataStore.get_private_key()} )
      peer.otr.REQUIRE_ENCRYPTION = true
      # if peer.is_offer_creator
      #just send out OTR protocol instantiation tags - ignoring if the other party might have
      #sent out one aswell or is about to prepare. it might have been lost
      peer.otr.sendQueryMsg()

      peer.otr.on('status', (state) ->
        switch state
          when OTR.CONST.STATUS_AKE_SUCCESS
            peer._change_status ChatConstants.PEER_STATUS_SECURE_LINE
          when OTR.CONST.STATUS_END_OTR
            peer._change_status ChatConstants.PEER_STATUS_CONNECTED
      )
      peer.otr.on 'ui', (msg, encrypted, meta) ->
        # encrypted == true, if the received msg was encrypted
        AppDispatcher.dispatch {
          type: ChatConstants.ACTIONTYPE_MESSAGE_INBOUND
          message: JSON.parse(msg)
          encrypted: encrypted
        }

      peer.otr.on 'io', (msg, meta) ->
        peer.send_message(msg)

      peer.otr.on 'error', (err, severity) ->
        if (severity == 'error')  # either 'error' or 'warn'
          console.error("error occurred: " + err)

  EventBus.subscribe ChatConstants.EVENT_MESSAGE_OUTBOUND, (data) =>
    for key, peer of PeerManager.get_peers()
      if peer.otr?
        peer.otr.sendMsg(JSON.stringify(data), {blabla: 'foobar'})

  EventBus.subscribe ChatConstants.EVENT_ENCRYPTED_MESSAGE_INBOUND, (data) =>
    peer = data.peer
    if peer.otr?
      peer.otr.receiveMsg(data.message)

  EventBus.subscribe ChatConstants.EVENT_SHUTDOWN_APP, () =>
    for key, peer of PeerManager.get_peers()
      if peer.otr?
        peer.otr.endOtr(() ->
          peer.close()
        )


module.exports = new Crypto()
