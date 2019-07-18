#!/bin/bash

# Check whether we are inside the Jeniks environment or not
[ -z "${WORKSPACE}" ] && echo 'WORKSPACE is not defined.' && exit

[ -z "${BUILD_TAG}" ] && echo 'BUILD_TAG is not defined.' && exit

mkdir -p "${WORKSPACE}/reports/zap"

# Deploy Docker stack & ZAP scanning
# Ignore failure to generating reports
set +e
DB_PASSWORD=${BUILD_TAG} docker stack deploy ${BUILD_TAG} --compose-file "${WORKSPACE}/docker-compose-jenkins.yml"
chmod 777 ${WORKSPACE}/reports/zap
docker run -v ${WORKSPACE}/reports/zap:/zap/wrk:rw owasp/zap2docker-stable:latest zap-baseline.py -t http://192.168.56.105:3000/ -r ${BUILD_TAG}.html -x ${BUILD_TAG}.xml
set -e


