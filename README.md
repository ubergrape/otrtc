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
