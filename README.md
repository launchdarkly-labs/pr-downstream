# pr-downstream
A Github action to create a pull request on a downstream repository when changes to a library repository are merged.

### Example usage

```yml
name: Open PRs on downstream repos

on:
  push:
    branches:
      - main

jobs:
  open-downstream-prs-if-necessary:
    name: Open downstream PRs if necessary
    runs-on: ubuntu-latest
    steps:
      - uses: launchdarkly-labs/pr-downstream-action@v1.0.0
        with:
          repository: goaltender
          team-reviewers: squad-integrations
          token: ${{ secrets.PR_CREATOR_GH_TOKEN }}
          update-command: |
            go get github.com/${{github.repository}}
            go mod tidy
            go mod vendor
            go generate ./...
```

## Development

### Publishing a new release

This Repo uses [release-drafter](https://github.com/release-drafter/release-drafter) to draft a new release every time a PR is merged. The version number is incremented anytime any of the following labels are included on a PR:

- `patch`
- `minor`
- `major`

After merging a PR, visit the [releases section](https://github.com/launchdarkly-labs/pr-downstream/releases) to publish the draft release.
