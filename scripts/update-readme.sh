#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o errtrace

if ! (command -v describe-action >/dev/null 2>&1) ; then
    go install github.com/actions-ecosystem/describe-action/cmd/describe-action@v0.2.0
fi

PWD=$(cd "$(dirname "$0")" && pwd -P)
export INPUT_TABLE=$(describe-action --input --yaml ${PWD}/../action.yml)
export OUTPUT_TABLE=$(describe-action --output --yaml ${PWD}/../action.yml)

perl -i -0pe "s#<!-- BEGIN_ACTION_INPUT_TABLE -->.*<!-- END_ACTION_INPUT_TABLE -->#<!-- BEGIN_ACTION_INPUT_TABLE -->\n\$ENV{INPUT_TABLE}\n<!-- END_ACTION_INPUT_TABLE -->#smg" "${PWD}/../README.md"

perl -i -0pe "s#<!-- BEGIN_ACTION_OUTPUT_TABLE -->.*<!-- END_ACTION_OUTPUT_TABLE -->#<!-- BEGIN_ACTION_OUTPUT_TABLE -->\n\$ENV{OUTPUT_TABLE}\n<!-- END_ACTION_OUTPUT_TABLE -->#smg" "${PWD}/../README.md"