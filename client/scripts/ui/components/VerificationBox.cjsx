ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'


_handle_close = (event) ->
  event.preventDefault()
  ChatActionCreators.close_verification_box()


VerificationBox = React.createClass

  getInitialState: () ->
    return {
      windowHeight: window.innerHeight
      windowWidth: window.innerWidth
    }

  handleResize: (e) ->
    this.setState({
      windowHeight: window.innerHeight
      windowWidth: window.innerWidth
    })

  componentDidMount: () ->
    window.addEventListener('resize', this.handleResize)

  componentWillUnmount: () ->
    window.removeEventListener('resize', this.handleResize)

  _on_toggle_verified: () ->
    ChatActionCreators.toggle_verified(@props.verification_data.peer)

  render: () ->
    peer = @props.verification_data.peer
    div_styles = {
      top: Math.round((@state.windowHeight - 150) / 2.45) + "px"
      left: Math.round((@state.windowWidth - 500) / 2) + "px"
    }
    <div className="verification_box" style={div_styles} ref="box">
      <a className="close_button" href="#" onClick={_handle_close}>Close</a>
      <h2>Peer Review</h2>
      <p><strong>Your fingerprint:</strong> {@props.verification_data.my_fingerprint}</p>
      <p><strong>{peer.username}'s fingerprint:</strong>
        {@props.verification_data.peer_fingerprint}</p>
      <p><input type="checkbox" checked={peer.verified} onChange={@_on_toggle_verified} />
        <label>I've verified {peer.username}'s fingerprint</label>
      </p>
    </div>


module.exports = VerificationBox
