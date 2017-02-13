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
