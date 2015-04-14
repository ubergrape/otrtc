ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'
Spinner = require 'react-spin'


ENTER_KEY_CODE = 13

spinCnfg =
  lines: 11  # The number of lines to draw
  length: 3  # The length of each line
  width: 3  # The line thickness
  radius: 6  # The radius of the inner circle
  corners: 1  # Corner roundness (0..1)
  rotate: 0  # The rotation offset
  direction: 1  # 1: clockwise  -1: counterclockwise
  color: '#000'  # #rgb or #rrggbb or array of colors
  speed: 1.2  # Rounds per second
  trail: 100  # Afterglow percentage
  shadow: false  # Whether to render a shadow
  hwaccel: false  # Whether to use hardware acceleration
  className: 'spinner'  # The CSS class to assign to the spinner
  zIndex: 2e9  # The z-index (defaults to 2000000000)
  top: '50%'  # Top position relative to parent
  left: '50%' # Left position relative to parent
  position: 'relative'


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
    if @props.status == ChatConstants.USER_STATUS_GENERATING_KEY or @props.status == ChatConstants.USER_STATUS_AUTHENTICATING
      spinner = <Spinner config={spinCnfg} />
    else
      spinner = ''
    switch @props.status
      when ChatConstants.USER_STATUS_FRESH
        statusMsg = ''
      when ChatConstants.USER_STATUS_AUTHENTICATING
        statusMsg = 'Setting up the session with the server'
      when ChatConstants.USER_STATUS_AUTHENTICATED_ON_SERVER
        statusMsg = ''
      when ChatConstants.USER_STATUS_GENERATING_KEY
        statusMsg = 'Generating your key for the OTR encryption'
      when ChatConstants.USER_STATUS_SETUP_COMPLETE
        statusMsg = 'Setup is complete. We\'ll take you to the room now.'
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
      <p className="status">{statusMsg}</p>
      <p className="spinner">{spinner}</p>
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
