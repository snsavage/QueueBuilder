# README

## Local Testing Instructions To test a local development instance of
QueueBuilder with Slack's API, your local development environment will need to
be exposed to the open internet.  One way to achieve this is to use the
[ngrok](https://ngropk.com).  This service can be used to create a http or
https tunnel to your local development environment.  After installing ngrok,
the tunnel can be created by running `ngrok http 3000`, where`3000` is the port
for your local development service.  ngrok will provide a forwarding URL to be
added to the Request URL field in the Slack interface for Event Subscriptions.
The URL should have the path `/slack/event`.


