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

<!-- action-docs-inputs source="action.yml" -->
## Inputs

| name | description | required | default |
| --- | --- | --- | --- |
| `author` | <p>The author name and email address in the format Display Name <a href="&#109;&#x61;i&#108;&#x74;&#111;&#58;&#x65;&#x6d;&#97;&#105;&#x6c;&#64;&#x61;&#100;&#100;&#x72;&#101;&#115;&#x73;&#x2e;&#x63;&#111;&#x6d;">&#101;&#109;&#x61;&#x69;l&#64;&#x61;&#100;&#x64;r&#x65;&#x73;&#x73;&#x2e;c&#111;&#x6d;</a>. Defaults to the user who triggered the workflow run.</p> | `false` | `${{github.actor}} <${{github.actor}}@users.noreply.github.com>` |
| `auto-merge` | <p>Whether or not to enable "Auto-merge" on the pull request.</p> | `false` | `false` |
| `branch` | <p>The pull request branch name.</p> | `false` | `bump-${{github.repository}}/patch` |
| `commit-message` | <p>The message to use when committing changes.</p> | `false` | `[bot] Bump ${{github.event.repository.name}}` |
| `committer` | <p>The committer name and email address in the format Display Name <a href="m&#x61;&#x69;&#108;&#116;&#111;&#x3a;&#x65;&#x6d;&#x61;&#105;&#x6c;&#64;&#x61;&#x64;&#100;&#114;&#101;&#115;&#x73;&#46;&#99;&#x6f;&#109;">&#x65;ma&#x69;&#108;&#64;&#97;&#x64;d&#x72;&#101;&#x73;&#115;&#46;&#x63;o&#109;</a>. Defaults to the GitHub Actions bot user.</p> | `false` | `GitHub <noreply@github.com>` |
| `dry-run` | <p>Set to true to not really raise a PR. This is useful for testing.</p> | `false` | `false` |
| `labels` | <p>A comma or newline-separated list of labels.</p> | `false` | `bot` |
| `octosts-identity` | <p>The OctoSTS identity to assume for target repository operations</p> | `false` | `pr-downstream` |
| `octosts-scope` | <p>The OctoSTS policy to assume for target repository operations</p> | `false` | `launchdarkly` |
| `ref` | <p>The branch, tag, or commit SHA to checkout from the downstream repository.</p> | `false` | `main` |
| `repository` | <p>The downstream repository that consumes the library dependency.</p> | `true` | `""` |
| `token` | <p>Github PAT used to open PRs. This token must have write access against the repository.</p> | `false` | `""` |
| `relevance-filter` | <p>A path filter used to determine if any relevant files where changed as a result of the <code>update-command</code>. By default, all changes are considered relevant.</p> | `false` | `- '**'` |
| `reviewers` | <p>A comma or newline-separated list of reviewers (GitHub usernames) to request a review from.</p> | `false` | `""` |
| `team-reviewers` | <p>A comma or newline-separated list of GitHub teams to request a review from.</p> | `false` | `""` |
| `title` | <p>The title of the pull request.</p> | `false` | `[bot] Bump ${{github.event.repository.name}}` |
| `update-command` | <p>The command run from the downstream repo that is used to update the library dependency.</p> | `true` | `""` |
| `working-directory` | <p>The relative directory in the downstream repo where all commands will run.</p> | `false` | `""` |
<!-- action-docs-inputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->
## Outputs

| name | description |
| --- | --- |
| `pull-request-number` | <p>The pull request number</p> |
| `pull-request-operation` | <p>The pull request operation performed by the action, <code>created</code>, <code>updated</code> or <code>closed</code>.</p> |
| `pull-request-head-sha` | <p>The commit SHA of the pull request branch.</p> |
| `pull-request-url` | <p>The URL of the pull request.</p> |
<!-- action-docs-outputs source="action.yml" -->

<!-- action-docs-runs source="action.yml" -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs source="action.yml" -->
