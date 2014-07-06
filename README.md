# hubot-gh-release-pr

A hubot script to create GitHub's PR for release

See [`src/gh-release-pr.coffee`](src/gh-release-pr.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-gh-release-pr --save`

Then add **hubot-gh-release-pr** to your `external-scripts.json`:

```json
["hubot-gh-release-pr"]
```

## Examples

```json
user1>> hubot release test-repo production
hubot>> Release PR is sent to test-repo
```

## How it works

`hubot-gh-release-pr` creates a PR for release.
The default head branch is `master` and can be changed as you like.

## Configuration:

Required ENVs:

 * GH_RELEASE_PR_TOKEN
 * GH_RELEASE_PR_USER

Optional ENVs:

 * GH_RELEASE_PR_CUSTOM_BRANCH
 * GH_RELEASE_PR_GITHUB_DEBUG
 * GH_RELEASE_PR_GITHUB_HOST
 * GH_RELEASE_PR_GITHUB_PATH_PREFIX
 * GH_RELEASE_PR_GITHUB_PATH_PROTOCOL

## Customize Branch
