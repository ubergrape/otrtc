React = require 'react'


Message = React.createClass

  render: () ->
    <div className="message">
      <span className="username">{@props.username}</span>
      <span className="text">{@props.text}</span>
      <span className="time">{@props.time}</span>
    </div>


module.exports = Message
