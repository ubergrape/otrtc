AppDispatcher = require '../../dispatcher/AppDispatcher.coffee'
ChatConstants = require '../../constants/ChatConstants.coffee'
EventBus = require '../../utils/EventBus.coffee'
Inputbox = require './Inputbox.cjsx'
Menu = require './Menu.cjsx'
Messagelist = require './Messagelist.cjsx'
React = require 'react'
UserdataStore = require '../stores/UserdataStore.coffee'
VerificationBox = require './VerificationBox.cjsx'
WelcomeScreen = require './WelcomeScreen.cjsx'


get_state = () ->
  return {
    status: UserdataStore.get_status()
    verification_data: UserdataStore.verification_data
  }


window.onbeforeunload = (event) ->
  EventBus.publish ChatConstants.EVENT_SHUTDOWN_APP
  return null


OTRChat = React.createClass

  getInitialState: () ->
    return get_state()

  componentDidMount: () ->
    UserdataStore.on ChatConstants.EVENT_STORE_CHANGED, () =>
      @_update_state()

  componentWillUnmount: () ->
    return

  _update_state: () ->
    @setState get_state()

  render: () ->
    if @state.verification_data?
      ver_box = <VerificationBox verification_data={@state.verification_data} />
    else
      ver_box = null
    if @state.status == ChatConstants.USER_STATUS_SETUP_COMPLETE
      view = <div><Menu /><Messagelist /><Inputbox />{ver_box}</div>
    else
      view = <WelcomeScreen status={@state.status} />
    return <div>{view}</div>


module.exports = OTRChat
