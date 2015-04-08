require './crypto/Crypto.coffee'
OTRChat = require './ui/components/OTRChat.cjsx'
React = require 'react'


React.render(
    <OTRChat />
    document.getElementById('chat_container')
)
