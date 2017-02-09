Enabling Hubot Listener

 It can be useful to have him listening for incoming message from outside
sources. You can have Hubot run an HTTP listener and define routes that trigger
custom actions (much like routes in an express node app or a Backbone app).
The first thing you have to do is make sure your hubot is listening for HTTP
requests. To do so, simply define the PORT env variable in your bin/hubot config
to whatever port you want.

export PORT=8585

Now you have to create a coffee script in your hubot's script directory that
listens for routes, or URL paths, and then does something for you. Here is a
pretty generic example of a script that gets triggered when "/flybot/message" is
hit and passes a message along to a user or channel. It looks for two query
string parameters, the user or channel to relay the message to, and the message
itself.
url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.get "/mybot/message", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    user = {}
    user.room = query.room if query.room

    try
       robot.send user, "INCOMING MESSAGE: " + query.message

       res.end "message sent: #{query.message}"

    catch error
      console.log "message-listner error: #{error}."
•   robot.router.get "/flybot/message" is what tells hubot to listen for GET
requests to "/flybot/message". You can also listen for POSTs via
robot.router.get and the POST payload is available in req.body.payload
•   robot.send sends the message to the User object (which can be a user or a
channel). For a user you can use something like "jsolis" and for a channel you
would have to send something like "#mychannel" (remember to URLEncode the # in
your querystring %23mychannel).
•   res.end will end your response and send the string parameter back to caller.



