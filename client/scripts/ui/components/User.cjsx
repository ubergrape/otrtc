ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'
UserStatusIcon = require './UserStatusIcon.cjsx'



User = React.createClass

  _handle_click: () ->
    ChatActionCreators.verify_peer(@props.user)

  render: () ->
    class_name = 'offline'
    switch @props.user.status
      when ChatConstants.PEER_STATUS_CONNECTED
        class_name = 'online'
      when ChatConstants.PEER_STATUS_SECURE_LINE
        if @props.user.verified
          class_name = 'online verified'
        else
          class_name = 'online secure'

    <li className={class_name} onClick={@_handle_click}>
      <UserStatusIcon status={@props.user.status} verified={@props.user.verified} />
      {@props.user.username}
    </li>


module.exports = User
