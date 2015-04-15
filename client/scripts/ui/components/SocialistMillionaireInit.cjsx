ChatActionCreators = require '../actions/ChatActionCreators.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
React = require 'react'


ENTER_KEY_CODE = 13

_handle_close = (event) ->
  event.preventDefault()
  event.stopPropagation()
  ChatActionCreators.close_verification_box()


SocialistMillionaireInit = React.createClass

  getInitialState: () ->
    return {
      question: ''
      secret: ''
      input_disabled: false
    }

  # componentDidMount: () ->
  #   return

  # componentWillUnmount: () ->
  #   return

  _on_change: () ->
    @setState
      question: @refs.questionInput.getDOMNode().value
      secret: @refs.secretInput.getDOMNode().value

  _onKeyDown: (event) ->
    if (event.keyCode == ENTER_KEY_CODE)
      event.preventDefault()
      @_init_smp()

  _init_smp: () ->
    question = @state.question.trim()
    secret = @state.secret.trim()
    if secret
      @setState({input_disabled: true})
      @props.on_init(question, secret)

  render: () ->
    status_classname = 'status '
    switch @props.smp_status
      when ChatConstants.PEER_SMP_STATUS_ASKING
        status_icon = <i className="fa fa-circle-o-notch fa-spin" />
        status_string = 'Waiting for ' + @props.username + ' to answer.'
      when ChatConstants.PEER_SMP_STATUS_VERIFIED
        status_string = @props.username + ' entered the same secret.'
        status_classname += 'verified'
      when ChatConstants.PEER_SMP_STATUS_FALSIFIED
        status_string = @props.username + ' did not enter the same secret. ' + @props.username + ' might not be ' + @props.username + '!'
        status_classname += 'falsified'
      when ChatConstants.PEER_SMP_STATUS_ABORTED
        status_string = 'The protocol was aborted. Maybe we\'ve lost the connection to ' + @props.username + '.'

    <div className="socialist_millionaire" >
      <h3>Socialist Millionaire Protocol</h3>
      <p>
        <input
          type="text"
          id="secret"
          ref="secretInput"
          placeholder="Shared secret"
          value={@state.secret}
          onChange={@_on_change}
          autoFocus=true
          onKeyDown={@_onKeyDown}
          disabled={@state.input_disabled}
        />
      </p>
      <p>
        <input
          type="text"
          id="question"
          ref="questionInput"
          placeholder="(Optionally provide a reminder of your shared secret)"
          value={@state.question}
          onChange={@_on_change}
          onKeyDown={@_onKeyDown}
          disabled={@state.input_disabled}
        />
      </p>
      <p>
        <button onClick={@_init_smp} disabled={@state.input_disabled}>Check peer's authenticity</button>
        <span className={status_classname}>{status_icon}{status_string}</span>
      </p>
    </div>


module.exports = SocialistMillionaireInit
