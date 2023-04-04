#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

repo_root_dir="${SCRIPT_DIR}/.."

./bin/component-cli ctf push "${repo_root_dir}"/gen/ctf
