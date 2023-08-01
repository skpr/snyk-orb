#!/bin/env bash

# shellcheck disable=SC2120,SC2148
snyk_image_scan() {

  cat < ${PARAM_MANIFEST} | jq -c ".[]" | jq "select(.type == \"runtime\")" | jq  '.tag' -r > manifest-target.txt
  while IFS= read -r line
  do
    snyk image test ${line} --org=${PARAM_ORG}
  done < manifest-target.txt

}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
# shellcheck disable=SC2295
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    snyk_image_scan
fi
