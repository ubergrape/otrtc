ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'
SocialistMillionaireInit = require './SocialistMillionaireInit.cjsx'


_handle_close = (event) ->
  event.preventDefault()
  event.stopPropagation()
  ChatActionCreators.close_verification_box()


VerificationBox = React.createClass

  getInitialState: () ->
    return {
      windowHeight: window.innerHeight
      windowWidth: window.innerWidth
      verifiying_peer_smp_status: @props.peer.smp_status
    }

  handleResize: (e) ->
    this.setState({
      windowHeight: window.innerHeight
      windowWidth: window.innerWidth
    })

  _update_smp_state: () ->
    @setState({verifiying_peer_smp_status: @props.peer.smp_status})

  componentDidMount: () ->
    window.addEventListener('resize', this.handleResize)
    @props.peer.on ChatConstants.EVENT_PEER_SMP_STATUS_CHANGED, @_update_smp_state

  componentWillUnmount: () ->
    window.removeEventListener('resize', this.handleResize)
    @props.peer.removeListener ChatConstants.EVENT_PEER_SMP_STATUS_CHANGED, @_update_smp_state

  _on_toggle_verified: () ->
    ChatActionCreators.toggle_verified(@props.peer)

  _on_smp_init: (question, answer) ->
    ChatActionCreators.init_smp(@props.peer, answer, question)

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
        <label htmlFor="verified">I've verified {@props.peer.username}'s identity</label>
      </p>
      <SocialistMillionaireInit
        username={@props.peer.username}
        on_init={@_on_smp_init}
        smp_status={@state.verifiying_peer_smp_status}
      />
    </div>


module.exports = VerificationBox
