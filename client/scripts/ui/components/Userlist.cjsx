React = require 'react'
User = require './User.cjsx'


Userlist = React.createClass

  render: () ->
    users = []
    for id, peer of @props.peers
      users.push <User user={peer} key={peer.id} />
    return <ul className="user_list">{users}</ul>


module.exports = Userlist
