assert = require 'power-assert'
params = require '../src/params'

describe 'params', ->
  describe 'toInit', ->
    context 'without ENV', ->
      beforeEach ->
        @subject = params.toInit()

      it 'gets expected values', ->
        assert.equal @subject.version, '3.0.0'
        assert.equal @subject.protocol, 'https'
        assert.equal @subject.debug, false
        assert.equal @subject.timeout, 5000
        assert.equal @subject.host, 'api.github.com'

    context 'with ENV', ->
      beforeEach ->
        @protocol   = process.env.GH_RELEASE_PR_GITHUB_PROTOCOL
        @debug      = process.env.GH_RELEASE_PR_GITHUB_DEBUG
        @host       = process.env.GH_RELEASE_PR_GITHUB_HOST
        @pathPrefix = process.env.GH_RELEASE_PR_GITHUB_PATH_PREFIX

        process.env.GH_RELEASE_PR_GITHUB_PROTOCOL    = 'http'
        process.env.GH_RELEASE_PR_GITHUB_DEBUG       = 'true'
        process.env.GH_RELEASE_PR_GITHUB_HOST        = 'github.my-GHE-enabled-company.com'
        process.env.GH_RELEASE_PR_GITHUB_PATH_PREFIX = '/api/v3'

        @subject = params.toInit()

      afterEach ->
        process.env.GH_RELEASE_PR_GITHUB_PROTOCOL    = @protocol
        process.env.GH_RELEASE_PR_GITHUB_DEBUG       = @debug
        process.env.GH_RELEASE_PR_GITHUB_HOST        = @host
        process.env.GH_RELEASE_PR_GITHUB_PATH_PREFIX = @pathPrefix

      it 'gets expected values', ->
        assert.equal @subject.version, '3.0.0'
        assert.equal @subject.protocol, 'http'
        assert.equal @subject.debug, true
        assert.equal @subject.timeout, 5000
        assert.equal @subject.host, 'github.my-GHE-enabled-company.com'
        assert.equal @subject.pathPrefix, '/api/v3'

  describe 'toAuth', ->
    beforeEach ->
      @token = process.env.GH_RELEASE_PR_TOKEN
      process.env.GH_RELEASE_PR_TOKEN = 'bogus-token'

      @subject = params.toAuth()

    afterEach ->
      process.env.GH_RELEASE_PR_TOKEN = @token

    it 'gets expected values', ->
      assert.equal @subject.type, 'oauth'
      assert.equal @subject.token, 'bogus-token'

  describe 'toCreatePR', ->
    beforeEach ->
      @repo = 'test-repo'
      @user = process.env.GH_RELEASE_PR_USER
      process.env.GH_RELEASE_PR_USER = 'user'

    afterEach ->
      process.env.GH_RELEASE_PR_USER = @user

    context 'without custom branch', ->
      it 'gets expected values', ->
        @subject = params.toCreatePR @repo, 'production', {message: user: name: 'foo'}

        assert.equal @subject.user, 'user'
        assert.equal @subject.repo, 'test-repo'
        assert.equal @subject.title, "#{params.now()} production deployment by foo"
        assert.equal @subject.body, ''
        assert.equal @subject.base, 'production'
        assert.equal @subject.head, 'master'

    context 'with custom branch', ->
      beforeEach ->
        @customBranch = process.env.GH_RELEASE_PR_CUSTOM_ENDPOINT
        process.env.GH_RELEASE_PR_CUSTOM_ENDPOINT = 'test-repo[repo]=original-test-repo&test-repo[base][production]=another-name-of-production&test-repo[head]=another-name-of-master'

      afterEach ->
        process.env.GH_RELEASE_PR_CUSTOM_ENDPOINT = @customBranch

      it 'gets expected values', ->
        @subject = params.toCreatePR @repo, 'production', {message: user: name: 'foo'}

        assert.equal @subject.user, 'user'
        assert.equal @subject.repo, 'original-test-repo'
        assert.equal @subject.title, "#{params.now()} production deployment by foo"
        assert.equal @subject.body, ''
        assert.equal @subject.base, 'another-name-of-production'
        assert.equal @subject.head, 'another-name-of-master'
