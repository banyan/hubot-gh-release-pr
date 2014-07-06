# Note: This params object is created because of sinon.js.
# I used node-github, and their API is like this.
#
# a = new GitHubAPI
# a.b()
# a.b.c()
#
# This kind of nested API, sinon.js (mock) can't work well.
# Since node-github is tested itself, so I end up to test as mock,
# instead I choose to use params object whether arguments are propely created or not.

qs = require 'qs'

module.exports = {
  toInit: ->
    version: "3.0.0"
    protocol: process.env.GH_RELEASE_PR_GITHUB_PROTOCOL or "https"
    debug: !!process.env.GH_RELEASE_PR_GITHUB_DEBUG or false
    timeout: 5000
    host: process.env.GH_RELEASE_PR_GITHUB_HOST or 'api.github.com' # for GHEs
    pathPrefix: process.env.GH_RELEASE_PR_GITHUB_PATH_PREFIX or null # for GHEs

  toAuth: ->
    type: "oauth"
    token: process.env.GH_RELEASE_PR_TOKEN

  toCreatePR: (repo, environment, msg) ->
    customBranch = if process.env.GH_RELEASE_PR_CUSTOM_BRANCH
      qs.parse(process.env.GH_RELEASE_PR_CUSTOM_BRANCH)[repo]
    else
      null

    user: process.env.GH_RELEASE_PR_USER
    repo: customBranch?.repo or repo
    title: "#{@now()} #{environment} deployment by #{msg.message.user.name}"
    body: ""
    base: customBranch?.base?[environment] or environment
    head: customBranch?.head or 'master'

  now: (d = new Date) ->
    pad = (s) -> if (s < 10) then "0#{s}" else s
    [d.getFullYear(), pad(d.getMonth() + 1), pad(d.getDate())].join '.'
}