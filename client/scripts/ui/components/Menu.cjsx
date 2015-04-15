ChatConstants = require '../../constants/ChatConstants.coffee'
ConnectionCoordinator = require '../../transport/ConnectionCoordinator.coffee'
PeerManager = require '../../transport/PeerManager.coffee'
React = require 'react'
SmpBox = require './SmpBox.cjsx'
UserdataStore = require '../stores/UserdataStore.coffee'
Userlist = require './Userlist.cjsx'
VerificationBox = require './VerificationBox.cjsx'
WhoAmI = require './WhoAmI.cjsx'


connection_coordinator = new ConnectionCoordinator(ROOM_ID)


get_peers_state = () ->
  return {
    my_name: UserdataStore.get_username()
    peers: PeerManager.get_peers()
    verifying_peer: UserdataStore.verifying_peer
    smp_answering: UserdataStore.smp_answering
  }


Menu = React.createClass

  getInitialState: () ->
    return get_peers_state()

  componentDidMount: () ->
    PeerManager.on ChatConstants.EVENT_STORE_CHANGED, @_update_state
    UserdataStore.on ChatConstants.EVENT_STORE_CHANGED, @_update_state

  componentWillUnmount: () ->
    PeerManager.removeListener ChatConstants.EVENT_STORE_CHANGED, @_update_state
    UserdataStore.removeListener ChatConstants.EVENT_STORE_CHANGED, @_update_state

  _update_state: () ->
    @setState get_peers_state()

  render: () ->
    if @state.verifying_peer?
      box = <VerificationBox
        peer={@state.verifying_peer}
        my_fingerprint={UserdataStore.get_my_fingerprint()}
        key={@state.verifying_peer.id} />
    else if @state.smp_answering?
      box = <SmpBox
        peer={@state.smp_answering.peer}
        question={@state.smp_answering.question}
        key={@state.smp_answering.peer.id} />
    else
      box = null
    <div className="menu">
      <WhoAmI name={@state.my_name} />
      <Userlist peers={@state.peers} />
      {box}
    </div>


module.exports = Menu
