React = require 'react'


NoMessagesYet = React.createClass

  getInitialState: () ->
    return {windowHeight: window.innerHeight}

  handleResize: (e) ->
    this.setState({windowHeight: window.innerHeight})

  componentDidMount: () ->
    window.addEventListener('resize', this.handleResize)

  componentWillUnmount: () ->
    window.removeEventListener('resize', this.handleResize)

  render: () ->
    div_styles = {marginTop: Math.round(@state.windowHeight / 2.45) + "px"}
    <div className="no_messages_yet" style={div_styles}>Starting a chat and then not saying anything is not enough.</div>


module.exports = NoMessagesYet
