React = require 'react'
# AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'


OTRChat = React.createClass

  render: () ->
    <div>
      <Menu peers={@props.peers} />
      <Messagelist messages= {@props.messages} />
    </div>


module.exports = OTRChat
