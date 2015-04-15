ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'
React = require 'react'


ConnectionLost = React.createClass

  getInitialState: () ->
    return {connection_lost: false}

  componentDidMount: () ->
    EventBus.subscribe ChatConstants.EVENT_SOCKET_CONNECTION_LOST, () =>
      @setState({connection_lost: true})

  _reload_page: (e) ->
    e.preventDefault()
    e.stopPropagation()
    location.reload()

  render: () ->
    if @state.connection_lost
      return <div className="info">You've lost your internet connection. Please reconnect and <a href="#" onClick={@_reload_page}>reload the page</a> to return to the chat.</div>
    else
      return <div className="info"></div>


module.exports = ConnectionLost
