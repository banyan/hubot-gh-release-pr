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
  robot.respond /release (.*)$/i, (msg) ->
    [repo, environment] = msg.match[1].trim().split ' '

    client = new GitHubApi params.toInit()
    client.authenticate params.toAuth()

    client.pullRequests.create params.toCreatePR(repo, environment, msg), (err, res) ->
      throw err if err
      msg.send "Release PR is sent to #{repo}"
