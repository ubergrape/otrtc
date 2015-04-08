ChatConstants = require '../../constants/ChatConstants.coffee'
ConnectionCoordinator = require '../../transport/ConnectionCoordinator.coffee'
EventBus = require '../../utils/EventBus.coffee'
PeerManager = require '../../transport/PeerManager.coffee'
React = require 'react'
UserdataStore = require '../stores/UserdataStore.coffee'
Userlist = require './Userlist.cjsx'
WhoAmI = require './WhoAmI.cjsx'


connection_coordinator = new ConnectionCoordinator(ROOM_ID)


get_peers_state = () ->
  return {
    my_name: UserdataStore.get_username()
    peers: PeerManager.get_peers()
  }


Menu = React.createClass

  getInitialState: () ->
    return get_peers_state()

  componentDidMount: () ->
    PeerManager.on ChatConstants.EVENT_STORE_CHANGED, () =>
      @_update_state()

  componentWillUnmount: () ->
    return

  _update_state: () ->
    @setState get_peers_state()

  render: () ->
    <div className="menu">
      <WhoAmI name={@state.my_name} />
      <Userlist peers={@state.peers} />
    </div>


module.exports = Menu
