# PR downstream Github Action
A Github action to create a pull request on a downstream Go repository when changes to a library repository are merged.

### Example usage

```yml
name: Open PR on downstream repository if relevant changes were made

on:
  push:
    branches:
      - main

jobs:
  pr-downstream-if-necessary:
    name: Goaltender
    runs-on: ubuntu-latest
    steps:
      - uses: launchdarkly-labs/pr-downstream@v1.0.0
        with:
          repository: launchdarkly-labs/some-repo
          reviewer: ${{ github.actor }}
          token: ${{ secrets.PR_CREATOR_GH_TOKEN }}
          update-command: |
            go get github.com/${{github.repository}}
            go mod tidy
            go mod vendor
            go generate ./...

          # If the only changes that were made impacted `go.mod`, `go.sum`, and/or `vendor/modules.txt`, then the change
          # is not worth a PR.
          relevance-filter: |
            - '!(go.mod|go.sum|vendor/modules.txt)'
        env:
          GOPRIVATE: github.com/launchdarkly-labs/*
```

## Development

### Publishing a new release

This Repo uses [release-drafter](https://github.com/release-drafter/release-drafter) to draft a new release every time a PR is merged. The version number is incremented anytime any of the following labels are included on a PR:

- `patch`
- `minor`
- `major`

After merging a PR, visit the [releases section](https://github.com/launchdarkly-labs/pr-downstream/releases) to publish the draft release.
