ChatActionCreators = require '../actions/ChatActionCreators.coffee'
React = require 'react'


_handle_close = (event) ->
  event.preventDefault()
  ChatActionCreators.close_verification_box()


SocialistMillionaireInit = React.createClass

  getInitialState: () ->
    return {
      question: ''
      answer: ''
    }

  # componentDidMount: () ->
  #   return

  # componentWillUnmount: () ->
  #   return

  _on_change: () ->
    @setState
      question: @refs.questionInput.getDOMNode().value
      answer: @refs.answerInput.getDOMNode().value

  _init_smp: () ->
    question = @refs.questionInput.getDOMNode().value
    answer = @refs.answerInput.getDOMNode().value
    @props.on_init(question, answer)

  render: () ->
    <div className="socialist_millionaire" >
      <h3>Socialist Millionaire Protocol</h3>
      <p>
        <label htmlFor="answer"></label>
        <input
          type="text"
          id="answer"
          ref="answerInput"
          placeholder="Shared secret"
          value={@state.answer}
          onChange={@_on_change}
        />
      </p>
      <p>
        <label htmlFor="question"></label>
        <input
          type="text"
          id="question"
          ref="questionInput"
          placeholder="(Optionally provide a reminder of your shared secret)"
          value={@state.question}
          onChange={@_on_change}
        />
      </p>
      <p>
        <button onClick={@_init_smp}>Check peer's authenticity</button>
        <span className="status">
          <i className="fa fa-circle-o-notch fa-spin" />
          Doing stuff todo and more
        </span>
      </p>
    </div>


module.exports = SocialistMillionaireInit
