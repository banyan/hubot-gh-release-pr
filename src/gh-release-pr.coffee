# Description
#   A hubot script to create GitHub's PR for release
#
# Configuration:
#   required ENVs:
#     * GH_RELEASE_PR_TOKEN
#     * GH_RELEASE_PR_USER
#
#   optional ENVs:
#     * GH_RELEASE_PR_GITHUB_DEBUG
#     * GH_RELEASE_PR_GITHUB_HOST
#     * GH_RELEASE_PR_GITHUB_PATH_PREFIX
#     * GH_RELEASE_PR_GITHUB_PATH_PROTOCOL
#
# Commands:
#   hubot release <repo-name> <environment>
#
# Author:
#   banyan

GitHubApi = require 'github'

module.exports = (robot) ->
  now = (d = new Date) ->
    pad = (s) -> if (s < 10) then "0#{s}" else s
    [d.getFullYear(), pad(d.getMonth() + 1), pad(d.getDate())].join '.'

  client = new GitHubApi(
    version: "3.0.0"
    protocol: process.env.GH_RELEASE_PR_GITHUB_PROTOCOL or "https"
    debug: !!process.env.GH_RELEASE_PR_GITHUB_DEBUG or false
    timeout: 5000
    host: process.env.GH_RELEASE_PR_GITHUB_HOST or 'api.github.com' # for GHEs
    pathPrefix: process.env.GH_RELEASE_PR_PATH_PREFIX or undefined # for GHEs
  )

  client.authenticate
    type: "oauth"
    token: process.env.GH_RELEASE_PR_TOKEN

  robot.respond /release\s*(\w+)\s*(\w+)/i, (msg) ->
    repo        = msg.match[1].trim()
    environment = msg.match[2].trim()

    client.pullRequests.create
      user: process.env.GH_RELEASE_PR_USER
      repo: repo
      title: "#{now()} #{environment} deployment by #{msg.message.user.name}"
      body: ""
      base: environment
      head: 'master'
    , (err, res) ->
      throw err if err
      msg.send "Release PR is sent to #{repo}"
