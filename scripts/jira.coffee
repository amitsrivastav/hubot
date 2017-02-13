# Hubot plugin, that listens for JIRA webhooks, and announces in a room when new
#tickets are created:
#______________________________
#module.exports = (robot) ->
#  robot.router.post '/hubot/tickets', (req, res) ->
#    data = if req.body.payload? then JSON.parse req.body.payload else req.body
#    if data.webhookEvent = 'jira:issue_created'
#      console.dir("#{new Date()} New ticket created")
#      shortened_summary = if data.issue.fields.summary.length >= 20 then
#data.issue.fields.summary.substring(0, 20) + ' ...' else
#data.issue.fields.summary
#      shortened_description = if data.issue.fields.description.length >= 50 then
#data.issue.fields.description.substring(0, 50) + ' ...' else
#data.issue.fields.description
#      console.log("New **#{data.issue.fields.priority.name.split ' ', 1}**
#created by #{data.user.name} (**#{data.issue.fields.customfield_10030.name}**) -
#{shortened_summary} - #{shortened_description}")
#      robot.messageRoom "glados-test", "New
#**#{data.issue.fields.priority.name.split ' ', 1}** | #{data.user.name}
#(**#{data.issue.fields.customfield_10030.name}**) | #{shortened_summary} |
##{shortened_description}"
#    res.send 'OK'


