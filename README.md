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

## How it works

1. Ask hubot to create PR
1. hubot create PR via GitHub API.
1. The default head branch is `master`, base branch would be that you specified.

## Examples

```
user1>> hubot release <repo-name> <base-branch>
user1>> hubot release test-repo production
user1>> hubot release test-repo staging
user1>> hubot release test-repo edge
```

## Configuration:

Required ENVs:

 * GH_RELEASE_PR_TOKEN
 * GH_RELEASE_PR_USER

Optional ENVs:

 * GH_RELEASE_PR_CUSTOM_ENDPOINT
 * GH_RELEASE_PR_GITHUB_DEBUG
 * GH_RELEASE_PR_GITHUB_HOST
 * GH_RELEASE_PR_GITHUB_PATH_PREFIX
 * GH_RELEASE_PR_GITHUB_PATH_PROTOCOL

## Customize Branch
