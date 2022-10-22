#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2020, Cinc Project
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cat << EOF > /tmp/docker-token
$DOCKER_TOKEN
EOF
cat /tmp/docker-token | docker login --username $DOCKER_USERNAME --password-stdin
rm -rf /tmp/docker-token
cd chef

VERSION="$(cat VERSION)"
MAJ="$(cat VERSION | cut -d '.' -f 1)"
MIN="$(cat VERSION | cut -d '.' -f 2)"
# Point directly to OSUOSL master mirror
URL="https://ftp-osl.osuosl.org/pub/cinc/files/${CHANNEL}/cinc/${VERSION}/el/7/cinc-${VERSION}-1.el7.x86_64.rpm"
COUNT=0
SLEEP=10
MAX_COUNT=300

# The Dockerfile pulls a built rpm from a URL instead of using the source. The
# following ensures that we wait until the RPM has been deployed onto our
# mirrors. By default, it will try the URL, wait 10 seconds if it fails and keep
# doing that for 5 minutes. If nothing happens within those five minutes, then
# something is obviously wrong and exits with 1.
while [ ${COUNT} -le ${MAX_COUNT} ] ; do
  if [ ${COUNT} -ge ${MAX_COUNT} ] ; then
    echo "Exceeded ${MAX_COUNT} seconds, giving up..."
    exit 1
  fi
  curl --output /dev/null --silent --head --fail "$URL"
  STATUS=$?
  if [ "${STATUS}" -eq 0 ] ; then
    echo "${URL} ready!"
    break
  else
    echo "${URL} is not ready, waiting for ${SLEEP} seconds... (${COUNT}/${MAX_COUNT})"
    sleep ${SLEEP}
    COUNT=`expr ${COUNT} + ${SLEEP}`
  fi
done

set -x
docker build --pull --no-cache -t cincproject/cinc:${VERSION} .
# If we're building a current channel build, then tag appropriately
if [ "${CHANNEL}" == "current" ] ; then
  docker tag cincproject/cinc:${VERSION} cincproject/cinc:current
  docker push cincproject/cinc:current
else
  docker tag cincproject/cinc:${VERSION} cincproject/cinc:latest
  docker tag cincproject/cinc:${VERSION} cincproject/cinc:${MAJ}.${MIN}
  docker tag cincproject/cinc:${VERSION} cincproject/cinc:${MAJ}
  docker push cincproject/cinc:latest
  docker push cincproject/cinc:${MAJ}.${MIN}
  docker push cincproject/cinc:${MAJ}
fi
docker push cincproject/cinc:${VERSION}
rm -rf ${HOME}/.docker
