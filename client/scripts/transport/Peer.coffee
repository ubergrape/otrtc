AppDispatcher = require '../dispatcher/AppDispatcher.coffee'
EventBus = require '../utils/EventBus.coffee'
PeerConnection = require('rtcpeerconnection')
ChatConstants = require '../constants/ChatConstants.coffee'


_constraints =
  mandatory:
    OfferToReceiveAudio: false
    OfferToReceiveVideo: false


Peer = (peer_id, username, create_offer) ->
  @id = peer_id
  @username = username
  @is_offer_creator = create_offer
  @status = ChatConstants.PEER_STATUS_CONNECTING

  config =
    iceServers: [{
      url: 'stun:stun.stunprotocol.org'
    }]
    bundlePolicy: 'max-compat'

  @_connection = new PeerConnection(config, {
    optional: [
      {RtpDataChannels: false}
      #make sure to not use RTP. Firefox doesn't support it.
      {andyetFirefoxMakesMeSad: 10000}
      #working around https://bugzilla.mozilla.org/show_bug.cgi?id=1087551
      #no idea if this has any effect
    ]
  })

  @_connection.on 'addChannel', (channel) =>
    @_channel = channel

  @_channel = @_connection.createDataChannel('chat', { reliable: false })

  @_channel.onmessage = (event) =>
    console.log 'message inbound', event.data
    EventBus.publish ChatConstants.EVENT_ENCRYPTED_MESSAGE_INBOUND, {
      peer: @
      message: event.data
    }

  @_channel.onopen = () =>
    @_change_status ChatConstants.PEER_STATUS_CONNECTED

  @_channel.onclose = () =>
    @_change_status ChatConstants.PEER_STATUS_DISCONNECTED

  @_connection.on 'ice', (candidate) ->
    EventBus.publish ChatConstants.EVENT_PEER_LOCAL_ICE_CANDIDATE,
      peer_id: peer_id
      candidate: candidate

  EventBus.subscribe ChatConstants.EVENT_REMOTE_DESCRIPTION_RECEIVED, (data) =>
    #only process event if it concerns the remote peer we're managing here
    if data.peer_id == peer_id
      if create_offer
        @_connection.handleAnswer(data.description)
      else
        @_connection.handleOffer(data.description, () =>
          @_connection.answer _constraints, (err, answer) =>
            if (!err)
              EventBus.publish ChatConstants.EVENT_PEER_LOCAL_DESCRIPTION,
                peer_id: peer_id
                description: answer
        )

  EventBus.subscribe ChatConstants.EVENT_REMOTE_ICE_CANDIDATE_RECEIVED, (data) =>
    #only process event if it concerns the remote peer we're managing here
    if data.peer_id == peer_id
      # console.log 'received ICE'
      @_connection.processIce(data.candidate)

  EventBus.subscribe ChatConstants.EVENT_REMOTE_USER_LOGGED_OFF, (data) =>
    #only process event if it concerns the remote peer we're managing here
    if data.peer_id == peer_id
      @close()

  if create_offer
    @_connection.offer(_constraints, (err, offer) ->
      if (!err)
        EventBus.publish ChatConstants.EVENT_PEER_LOCAL_DESCRIPTION,
          peer_id: peer_id
          description: offer
    )

  return @


Peer.prototype._change_status = (new_status) ->
  old_status = @status
  @status = new_status
  # console.log new_status, @id
  EventBus.publish ChatConstants.EVENT_PEER_STATUS_CHANGED,
    peer: @
    peer_id: @id
    new_status: new_status
    old_status: old_status


Peer.prototype.send_message = (message) ->
  if (@status == ChatConstants.PEER_STATUS_CONNECTED or @status == ChatConstants.PEER_STATUS_SECURE_LINE) and @_channel?
    console.log 'message outbound', message
    @_channel.send(message)


Peer.prototype.close = () ->
  if @_channel? then @_channel.close()
  if @_connection? then @_connection.close()
  @_change_status ChatConstants.PEER_STATUS_DISCONNECTED


module.exports = Peer
