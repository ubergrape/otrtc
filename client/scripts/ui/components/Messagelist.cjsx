React = require 'react'
Message = require './Message.cjsx'
MessageSmpRequest = require './MessageSmpRequest.cjsx'
NoMessagesYet = require './NoMessagesYet.cjsx'
MessageStore = require '../stores/MessageStore.coffee'
$ = require 'jquery'
moment = require 'moment'


get_messages_state = () ->
  return {
    messages: MessageStore.get_all()
  }


Messagelist = React.createClass

  getInitialState: () ->
    return get_messages_state()

  componentDidMount: () ->
    MessageStore.addChangeListener(@_onChange)

  componentWillUnmount: () ->
    MessageStore.removeChangeListener(@_onChange)

  componentDidUpdate: () ->
    @_scrollToBottom()

  _scrollToBottom: () ->
    ml = @refs.message_list.getDOMNode()
    $("html, body").animate({ scrollTop: ml.scrollHeight }, "slow")

  _onChange: () ->
    @setState(get_messages_state())

  render: () ->
    messages = []
    last_userid = null
    last_time = null
    @state.messages.forEach (message) ->
      timestring = moment(message.time).format('HH:mm')
      if last_userid != message.user_id then username = message.username else username = ''
      if last_time != timestring then time = timestring else time = ''
      last_userid = message.user_id
      last_time = timestring
      if message.type == 'smp_request'
        messages.push <MessageSmpRequest
          peer={message.peer}
          username={message.username}
          question={message.question}
          time={time}
          key={message.id}
        />
      else
        messages.push <Message username={username} text={message.text} time={time} key={message.id} />

    if messages.length == 0
      messages.push <NoMessagesYet />

    <div className="message_list" ref="message_list">{messages}</div>


module.exports = Messagelist
