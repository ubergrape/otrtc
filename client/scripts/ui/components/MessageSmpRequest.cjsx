ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'


MessageSmpRequest = React.createClass

  on_verify: (event) ->
    event.preventDefault()
    event.stopPropagation()
    ChatActionCreators.answer_smp(@props.peer, @props.question)


  render: () ->
    if @props.active
      text = <span className="text">{@props.username} asked you to verify your identity via the Socialist Millionaire Protocol. <a href="#" onClick={@on_verify}>Verify now</a></span>
    else
      text = <span className="text">You've answered {@props.username}'s request to verify your identity via the Socialist Millionaire Protocol.</span>
    <div className="message smp_request">
      <span className="username"></span>
      {text}
      <span className="time">{@props.time}</span>
    </div>


module.exports = MessageSmpRequest
