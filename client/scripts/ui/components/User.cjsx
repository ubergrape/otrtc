ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'



User = React.createClass

  _handle_click: () ->
    ChatActionCreators.verify_peer(@props.user)

  render: () ->
    status_string = ' '
    class_name = 'offline'
    switch @props.user.status
      when ChatConstants.PEER_STATUS_CONNECTING
        status_string = '...'
      when ChatConstants.PEER_STATUS_DISCONNECTED
        status_string = 'x'
      when ChatConstants.PEER_STATUS_CONNECTED
        status_string = 'c'
        class_name = 'online'
      when ChatConstants.PEER_STATUS_SECURE_LINE
        if @props.user.verified
          status_string = 'v'
          class_name = 'online verified'
        else
          status_string = 's'
          class_name = 'online secure'

    <li className={class_name} onClick={@_handle_click}>{@props.user.username} ({status_string})</li>


module.exports = User
