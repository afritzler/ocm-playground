#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

BASE_DEFINITION_PATH="${SCRIPT_DIR}/../component-descriptor.yaml"
COMPONENT_DESCRIPTOR_PATH="${SCRIPT_DIR}/../component-descriptor.yaml"

repo_root_dir="${SCRIPT_DIR}/.."
descriptor_out_file="${repo_root_dir}/gen/ca/component-descriptor.yaml"

version=$(yq e '.component.version' "${repo_root_dir}/component-descriptor.yaml")
component_name=$(yq e '.component.version' "${repo_root_dir}/component-descriptor.yaml")

echo "Found ${version} for component"

mkdir -p charts
curl -Ss https://raw.githubusercontent.com/onmetal/gardener-extension-provider-onmetal/main/charts/images.yaml?ref=${version} -o "${repo_root_dir}/charts/images.yaml"

echo "Enriching component descriptor from ${BASE_DEFINITION_PATH}"

mkdir -p gen/ca
cp "${BASE_DEFINITION_PATH}" "${descriptor_out_file}"

if [[ -f "$repo_root_dir/charts/images.yaml" ]]; then
  if [[ -z "${GENERIC_DEPENDENCIES}" ]]; then
    GENERIC_DEPENDENCIES="hyperkube,kube-apiserver,kube-controller-manager,kube-scheduler,kube-proxy"
  fi

  if [[ -z "${COMPONENT_CLI_ARGS}" ]]; then
    COMPONENT_CLI_ARGS="
    --comp-desc ${descriptor_out_file} \
    --image-vector "$repo_root_dir/charts/images.yaml" \
    --component-prefixes "${COMPONENT_PREFIXES}" \
    --generic-dependencies "${GENERIC_DEPENDENCIES}" \
    "
  fi

  # translates all images defined the images.yaml into component descriptor resources.
  # For detailed documentation see https://github.com/gardener/component-cli/blob/main/docs/reference/components-cli_image-vector_add.md
  ./bin/component-cli image-vector add ${COMPONENT_CLI_ARGS}
fi

./bin/component-cli ctf add -f "${repo_root_dir}"/gen/ca "${repo_root_dir}"/gen/ctf
