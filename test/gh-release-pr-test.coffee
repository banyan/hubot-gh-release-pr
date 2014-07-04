assert      = require 'power-assert'
sinon       = require 'sinon'
Hubot       = require 'hubot'
TextMessage = Hubot.TextMessage
GitHubApi   = require 'github'

describe 'gh-release-pr', ->
  beforeEach (done) ->
    @ghReleasePrToken = process.env.GH_RELEASE_PR_TOKEN
    @ghReleasePrUser  = process.env.GH_RELEASE_PR_USER

    process.env.GH_RELEASE_PR_TOKEN = 'bogus-token'
    process.env.GH_RELEASE_PR_USER  = 'foo'

    @user  = null
    @robot = new Hubot.loadBot null, 'mock-adapter', false, "Hubot"
    @robot.adapter.on 'connected', =>
      require('../src/gh-release-pr')(@robot)
      @user = @robot.brain.userForId('1', { name: 'jasmine' })
      done()
    @robot.run()

  afterEach ->
    @server.restore()
    @robot.shutdown()

    process.env.GH_RELEASE_PR_TOKEN = @ghReleasePrToken
    process.env.GH_RELEASE_PR_USER  = @ghReleasePrUser

  xit 'respond to release', (done) ->
    @robot.adapter.on 'send', (envelope, strings) ->
      console.log "strings: #{strings}"
      done()

    @robot.receive(new TextMessage(@user, 'hubot release repo production'))
