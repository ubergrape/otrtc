# OTR group chat via WebRTC

This is a group chat via WebRTC with messages being encrypted using the
OTR protocol. We've written a simple node.js server for signaling and
room management and used React/Flux for the front-end.

## Running

You must have [npm](https://www.npmjs.org/) installed on your computer.
From the root project directory run these commands from the command line:

`npm install`

This will install all dependencies.

To start a local server and a watch-task updating all buildfiles, run:

`grunt reloading`

To build the project like we've done for a cloudfoundry-type staging
server, run:

`grunt build`

and deploy everything inside the build directory.

## Technical Details

We've only specified a single STUN server in
`client/scripts/transport/Peer.coffee` and omitted TURN-servers. If you
want to add your own servers (STUN and/or TURN), add them to that list.

You can find quite an up-to-date list here: [STUN+TURN servers
list](https://gist.github.com/yetithefoot/7592580). This should get you
started for trying out the chat. But for production applications you
should get permission from all TURN/STUN servers you use and only use
servers you trust as clients expose info about their networking
infrastructure to them. Ideally you would set up your own servers.
