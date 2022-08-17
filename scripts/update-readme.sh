#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o errtrace

if command -v describe-action >/dev/null 2>&1 ; then
else
    go install github.com/actions-ecosystem/describe-action/cmd/describe-action@v0.2.0
fi

PWD=$(cd "$(dirname "$0")" && pwd -P)
export NEW_TABLE=$(describe-action --input --yaml ${PWD}/../action.yml)

echo ${NEW_TABLE}

perl -i -0pe "s#<!-- BEGIN_ACTION_INPUT_TABLE -->.*<!-- END_ACTION_INPUT_TABLE -->#<!-- BEGIN_ACTION_INPUT_TABLE -->\n\$ENV{NEW_TABLE}\n<!-- END_ACTION_INPUT_TABLE -->#smg" "${PWD}/../README.md"
