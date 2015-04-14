AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'
Inputbox = require './Inputbox.cjsx'
Menu = require './Menu.cjsx'
Messagelist = require './Messagelist.cjsx'
React = require 'react'
UserdataStore = require '../stores/UserdataStore.coffee'
WelcomeScreen = require './WelcomeScreen.cjsx'


get_state = () ->
  return {
    status: UserdataStore.get_status()
  }


window.onbeforeunload = (event) ->
  EventBus.publish ChatConstants.EVENT_SHUTDOWN_APP
  return null


OTRChat = React.createClass

  getInitialState: () ->
    return get_state()

  componentDidMount: () ->
    UserdataStore.on ChatConstants.EVENT_STORE_CHANGED, @_update_state

  componentWillUnmount: () ->
    UserdataStore.removeListener ChatConstants.EVENT_STORE_CHANGED, @_update_state
    return

  _update_state: () ->
    @setState get_state()

  render: () ->
    if @state.status == ChatConstants.USER_STATUS_SETUP_COMPLETE
      view = <div><Menu /><Messagelist /><Inputbox /></div>
    else
      view = <WelcomeScreen status={@state.status} />
    return <div>{view}</div>


module.exports = OTRChat
