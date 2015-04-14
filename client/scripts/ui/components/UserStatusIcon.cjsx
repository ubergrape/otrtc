ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'



UserStatusIcon = React.createClass

  render: () ->
    icon_class_name = ''
    switch @props.status
      when ChatConstants.PEER_STATUS_CONNECTING
        icon_class_name = 'fa-circle-o-notch fa-spin'
      when ChatConstants.PEER_STATUS_DISCONNECTED
        icon_class_name = 'fa-times'
      when ChatConstants.PEER_STATUS_CONNECTED
        icon_class_name = 'fa-unlock'
      when ChatConstants.PEER_STATUS_SECURE_LINE
        icon_class_name = 'fa-lock'
        if @props.verified
          verified_icon = <i className="fa fa-check" />

    return <span className="icons"><i className={'fa ' + icon_class_name} />{verified_icon}</span>


module.exports = UserStatusIcon
