ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'
SocialistMillionaireInit = require './SocialistMillionaireInit.cjsx'


ENTER_KEY_CODE = 13

_handle_close = (event) ->
  event.preventDefault()
  ChatActionCreators.close_smp_box()
  return false


SmpBox = React.createClass

  getInitialState: () ->
    return {
      windowHeight: window.innerHeight
      windowWidth: window.innerWidth
      verifying_peer_smp_status: @props.peer.smp_status
    }

  handleResize: (e) ->
    this.setState({
      windowHeight: window.innerHeight
      windowWidth: window.innerWidth
    })

  _update_smp_state: () ->
    @setState({verifying_peer_smp_status: @props.peer.smp_status})

  componentDidMount: () ->
    window.addEventListener('resize', this.handleResize)
    @props.peer.on ChatConstants.EVENT_PEER_SMP_STATUS_CHANGED, @_update_smp_state

  componentWillUnmount: () ->
    window.removeEventListener('resize', this.handleResize)
    @props.peer.removeListener ChatConstants.EVENT_PEER_SMP_STATUS_CHANGED, @_update_smp_state

  _onKeyDown: (event) ->
    if (event.keyCode == ENTER_KEY_CODE)
      event.preventDefault()
      @_answer_smp()

  _answer_smp: () ->
    answer = @refs.answerInput.getDOMNode().value
    ChatActionCreators.send_smp_answer(@props.peer, answer)

  render: () ->
    div_styles = {
      top: Math.round((@state.windowHeight - 250) / 2.45) + "px"
      left: Math.round((@state.windowWidth - 500) / 2) + "px"
    }
    if @props.question?
      question = <p><strong>Hint:</strong> {@props.question}</p>

    status_classname = 'status '
    switch @state.verifying_peer_smp_status
      when ChatConstants.PEER_SMP_STATUS_ASKING
        status_icon = <i className="fa fa-circle-o-notch fa-spin" />
        status_string = 'Checking if secrets match.'
      when ChatConstants.PEER_SMP_STATUS_VERIFIED
        status_string = @props.peer.username + ' entered the same secret.'
        status_classname += 'verified'
      when ChatConstants.PEER_SMP_STATUS_FALSIFIED
        status_string = @props.peer.username + ' did not enter the same secret. One of you might be an impostor!'
        status_classname += 'falsified'
      when ChatConstants.PEER_SMP_STATUS_ABORTED
        status_string = 'The protocol was aborted. Maybe we\'ve lost the connection to ' + @props.peer.username + '.'

    <div className="smp_box" style={div_styles} ref="box">
      <a className="close_button" href="#" onClick={_handle_close}>Close</a>
      <h2>Answer verification request</h2>
      {question}
      <p>
        <input
          type="text"
          id="answer"
          ref="answerInput"
          placeholder="Shared secret"
          value={@state.answer}
          onChange={@_on_change}
          autoFocus=true
          onKeyDown={@_onKeyDown}
        />
      </p>
      <p>
        <button onClick={@_answer_smp}>Compare shared secrets</button>
        <span className={status_classname}>{status_icon}{status_string}</span>
      </p>
    </div>


module.exports = SmpBox
