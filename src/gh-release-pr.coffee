# Description
#   A hubot script to create GitHub's PR for release
#
# Configuration:
#   See README.md
#
# Commands:
#   hubot release <repo-name> <environment>
#
# Author:
#   banyan

GitHubApi = require 'github'
params    = require './params'

module.exports = (robot) ->
  client = new GitHubApi params.toInit()
  client.authenticate params.toAuth()

  robot.respond /release\s*(\w+)\s*(\w+)/i, (msg) ->
    repo        = msg.match[1].trim()
    environment = msg.match[2].trim()

    client.pullRequests.create(
      params.toCreatePR(repo, environment, msg, customBranch)
    ) (err, res) ->
      throw err if err
      msg.send "Release PR is sent to #{repo}"
