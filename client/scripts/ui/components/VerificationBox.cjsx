ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'
SocialistMillionaireInit = require './SocialistMillionaireInit.cjsx'


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
    ChatActionCreators.toggle_verified(@props.peer)

  _on_smp_init: (question, answer) ->
    console.log @props.peer.id, question, answer

  render: () ->
    div_styles = {
      top: Math.round((@state.windowHeight - 250) / 2.45) + "px"
      left: Math.round((@state.windowWidth - 500) / 2) + "px"
    }
    <div className="verification_box" style={div_styles} ref="box">
      <a className="close_button" href="#" onClick={_handle_close}>Close</a>
      <h2>Peer Review</h2>
      <p><strong>Your fingerprint:</strong> {@props.my_fingerprint}</p>
      <p><strong>{@props.peer.username}'s fingerprint:</strong> {@props.peer.get_fingerprint()}</p>
      <p><input type="checkbox" id="verified" checked={@props.peer.verified} onChange={@_on_toggle_verified} />&nbsp;
        <label htmlFor="verified">I've verified {@props.peer.username}'s fingerprint</label>
      </p>
      <SocialistMillionaireInit on_init={@_on_smp_init} />
    </div>


module.exports = VerificationBox
