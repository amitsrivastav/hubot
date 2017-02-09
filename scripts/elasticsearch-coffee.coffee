# Description:
#   Log all the things to ElasticSearch then lets you ask hubot what you missed
#
# Dependencies:
#   None
#
# Configuration:
#   ELASTICSEARCH_HOSTNAME - E.G. elasticsearch.example.com:9200, where to send the put requests
#   ELASTICSEARCH_USERNAME - OPTIONAL basic auth username
#   ELASTICSEARCH_PASSWORD - OPTIONAL basic auth password
#
# Commands:
#   hubot what did I miss
#   hubot what did (user) say
#   hubot tell me about (search term)
#   hubot when did you last see (user)
#
# Author:
#   clundquist

elasticsearch_hostname = process.env.ELASTICSEARCH_HOSTNAME || 'localhost:9200'
elasticsearch_username = process.env.ELASTICSEARCH_USERNAME
elasticsearch_password = process.env.ELASTICSEARCH_PASSWORD
elasticsearch_url = "http://" + elasticsearch_hostname + "/hubot/"

print_result = (err,res,body,msg) ->
        if(err)
          msg.send err
          msg.send res
          msg.send body
        else
          data = JSON.parse body
          logs = data.hits.hits.sort (a,b) -> if a._source.date > b._source.date then 1 else -1
          msg.send "#{new Date(log._source.date)} #{log._source.user}: #{log._source.message}" for log in logs

search_hubot = (msg, data) ->
    data = JSON.stringify(data)
    msg.http(elasticsearch_url + "_search/" )
    .auth(elasticsearch_username, elasticsearch_password)
    .header('Content-Length', data.length) #XXX To work around NGINX 411 errors
    .post(data) (err, res, body) ->        # Because we don't support GET request
      print_result(err, res, body, msg)

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.last_exit  ||= {}
    robot.brain.data.last_enter ||= {}

  robot.leave (msg) ->
     robot.brain.data.last_exit[msg.message.user.name] = Date.now()

  robot.enter (msg) ->
     robot.brain.data.last_enter[msg.message.user.name] = Date.now()

  # Log everything in this chat room to elastic_search
  robot.hear /./i, (msg) ->
    data = { user: msg.message.user.name, message: msg.message.text, room: msg.message.user.room, date: Date.now()}
    data = JSON.stringify(data)
    msg.http(elasticsearch_url + msg.message.user.name + "/" + Date.now())
    .header('Content-Length', data.length) # #XXX To work around NGINX 411 errors
    .auth(elasticsearch_username, elasticsearch_password)
    .put(data) (err, res, body) ->
      if(err)
        msg.send err
        msg.send res
        msg.send body

  robot.respond /when did you last see (.+)/i, (msg) ->
     msg.send "I saw #{msg.match[1]} at #{new Date(robot.brain.data.last_exit[msg.match[1]])}"

  robot.respond /what did (.+) say/i, (msg) ->
     msg.send "in the last hour #{msg.match[1]} said:"
     data = { query: { bool: { must: { match: { user: msg.match[1] }, range: { date: {from: (Date.now() - 3600) }}}}, size:50}}
     search_hubot(msg,data)

  robot.respond /tell me about (.+)/i, (msg) ->
     msg.send "searching chat logs for #{msg.match[1]}:"
     data = { query: { match: { _all: msg.match[1]}}, size:50}
     search_hubot(msg,data)

  robot.respond /what did I miss/i, (msg) ->
     msg.send "Oh I'll tell you what happened"
     data = { query: { range: { date: { from: robot.brain.data.last_exit[msg.message.user.name] } }}, size:3600}
     search_hubot(msg,data)