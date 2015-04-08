ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'


ENTER_KEY_CODE = 13

Inputbox = React.createClass

  getInitialState: () ->
    return {text: ''}

  render: () ->
    <div className="inputbox">
      <input
        type="text"
        autoFocus=true
        placeholder="Type your message here..."
        value={@state.text}
        onChange={@_onChange}
        onKeyDown={@_onKeyDown}
      />
    </div>

  _onChange: (event, value) ->
    @setState({text: event.target.value})

  _onKeyDown: (event) ->
    if (event.keyCode == ENTER_KEY_CODE)
      event.preventDefault()
      text = @state.text.trim()
      if text
        ChatActionCreators.create_message(text)
      @setState({text: ''})

module.exports = Inputbox
