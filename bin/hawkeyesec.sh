#!/bin/bash

mkdir -p "${WORKSPACE}/reports/hawkeye"
# Ignore failure to generating reports
set +e
chmod 777 ${WORKSPACE}/reports/hawkeye
docker run --rm --volume ${WORKSPACE}:/target hawkeyesec/scanner-cli -j reports/hawkeye/${BUILD_TAG}.json
set -e
