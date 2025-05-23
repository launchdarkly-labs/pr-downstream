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
      - uses: launchdarkly-labs/pr-downstream@v1.4.0
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
### Action inputs

<!-- BEGIN_ACTION_INPUT_TABLE -->
|        NAME         |                                                                        DESCRIPTION                                                                        | REQUIRED |                             DEFAULT                              |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------------------------------------------------------------|
| `author`            | The author name and email address in the format Display Name <email@address.com>. Defaults to the user who triggered the workflow run.                    | `false`  | `${{github.actor}} <${{github.actor}}@users.noreply.github.com>` |
| `auto-merge`        | Whether or not to enable "Auto-merge" on the pull request.                                                                                                | `false`  | `false`                                                          |
| `branch`            | The pull request branch name.                                                                                                                             | `false`  | `bump-${{github.repository}}/patch`                              |
| `commit-message`    | The message to use when committing changes.                                                                                                               | `false`  | `[bot] Bump ${{github.event.repository.name}}`                   |
| `committer`         | The committer name and email address in the format Display Name <email@address.com>. Defaults to the GitHub Actions bot user.                             | `false`  | `GitHub <noreply@github.com>`                                    |
| `dryrun`            | Set to true to not really raise a PR. This is useful for testing.                                                                                         | `false`  | `false`                                                          |
| `labels`            | A comma or newline-separated list of labels.                                                                                                              | `false`  | `bot`                                                            |
| `relevance-filter`  | A path filter used to determine if any relevant files where changed as a result of the `update-command`. By default, all changes are considered relevant. | `false`  | `- '**'`                                                         |
| `repository`        | The downstream repository that consumes the library dependency.                                                                                           | `true`   | `N/A`                                                            |
| `reviewers`         | A comma or newline-separated list of reviewers (GitHub usernames) to request a review from.                                                               | `false`  | `N/A`                                                            |
| `team-reviewers`    | A comma or newline-separated list of GitHub teams to request a review from.                                                                               | `false`  | `N/A`                                                            |
| `title`             | The title of the pull request.                                                                                                                            | `false`  | `[bot] Bump ${{github.event.repository.name}}`                   |
| `token`             | Github PAT used to open PRs. This token must have write access against the repository.                                                                    | `true`   | `N/A`                                                            |
| `update-command`    | The command run from the downstream repo that is used to update the library dependency.                                                                   | `true`   | `N/A`                                                            |
| `working-directory` | The relative directory in the downstream repo where all commands will run.                                                                                | `false`  | `N/A`                                                            |
<!-- END_ACTION_INPUT_TABLE -->

### Action outputs

<!-- BEGIN_ACTION_OUTPUT_TABLE -->
|           NAME           |                                      DESCRIPTION                                      |
|--------------------------|---------------------------------------------------------------------------------------|
| `pull-request-head-sha`  | The commit SHA of the pull request branch.                                            |
| `pull-request-number`    | The pull request number                                                               |
| `pull-request-operation` | The pull request operation performed by the action, `created`, `updated` or `closed`. |
| `pull-request-url`       | The URL of the pull request.                                                          |
<!-- END_ACTION_OUTPUT_TABLE -->

## Development

If you change or add an input, use `./scripts/update-readme.sh` to keep the above **Action inputs** table up to date.

### Publishing a new release

This Repo uses [release-drafter](https://github.com/release-drafter/release-drafter) to draft a new release every time a PR is merged. The version number is incremented anytime any of the following labels are included on a PR:

- `patch`
- `minor`
- `major`

After merging a PR, visit the [releases section](https://github.com/launchdarkly-labs/pr-downstream/releases) to publish the draft release.
