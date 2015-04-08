ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'


ENTER_KEY_CODE = 13

WelcomeScreen = React.createClass

  getInitialState: () ->
    return {
      username: ''
      windowHeight: window.innerHeight
    }

  handleResize: (e) ->
    this.setState({windowHeight: window.innerHeight})

  componentDidMount: () ->
    window.addEventListener('resize', this.handleResize)

  componentWillUnmount: () ->
    window.removeEventListener('resize', this.handleResize)

  render: () ->
    div_styles = {marginTop: Math.round((@state.windowHeight - 240) / 2.45) + "px"}
    <div className="welcome_screen" style={div_styles}>
      <h1>Welcome to WebRTC-Chat from ChatGrape</h1>
      <p>
        <input
          type="text"
          autoFocus=true
          placeholder="What's your name?"
          value={@state.username}
          onChange={@_onChange}
          onKeyDown={@_onKeyDown}
        />
      </p>
      <p>
        <button onClick={@_log_in}>Enter private chatroom</button>
      </p>
      <p className="status">{@props.status}</p>
    </div>

  _onChange: (event, value) ->
    @setState({username: event.target.value})

  _onKeyDown: (event) ->
    if (event.keyCode == ENTER_KEY_CODE)
      event.preventDefault()
      @_log_in()

  _log_in: () ->
    username = @state.username.trim()
    if username
      ChatActionCreators.login_user(username)

module.exports = WelcomeScreen
