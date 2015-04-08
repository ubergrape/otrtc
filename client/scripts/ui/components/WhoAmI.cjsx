React = require 'react'


WhoAmI = React.createClass

  render: () ->
    <div className="who_am_i">{@props.name}</div>


module.exports = WhoAmI
