ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'


Message = React.createClass

  on_verify: (event) ->
    event.preventDefault()
    event.stopPropagation()
    ChatActionCreators.answer_smp(@props.peer, @props.question)


  render: () ->
    <div className="message smp_request">
      <span className="username"></span>
      <span className="text">{@props.username} asked you to verify your identity via the Socialist Millionaire Protocol. <a href="#" onClick={@on_verify}>Verify now</a></span>
      <span className="time">{@props.time}</span>
    </div>


module.exports = Message
