#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2024-2025, Cinc Project
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

TOP_DIR="$(pwd)"
set -ex
# Fix windows permissions
chmod -R o-w data/windows
# Add symlinks to other supported versions of Windows
cd data/windows
ln -s 2016 2012r2
ln -s 2016 2019
ln -s 2016 2022
ln -s 2016 10
ln -s 2016 11
cd ${TOP_DIR}
# TODO: temporary work around for upcoming debian release
mkdir -p data/debian/trixie
cd data/debian/trixie
ln -s ../13 sid
cd ${TOP_DIR}
# Deploy to primary mirror
ssh cinc@${DOWNLOADS_HOST} "mkdir -p /data/incoming/files/${CHANNEL}/cinc/$(cat VERSION)"
ssh cinc@${DOWNLOADS_HOST} "mkdir -p /data/incoming/source/${CHANNEL}/cinc/"
rsync -avH --delete data/ cinc@${DOWNLOADS_HOST}:/data/incoming/files/${CHANNEL}/cinc/$(cat VERSION)/
rsync -avH --delete source/ cinc@${DOWNLOADS_HOST}:/data/incoming/source/${CHANNEL}/cinc/
ssh cinc@${DOWNLOADS_HOST} "chmod 755 /data/incoming/files/${CHANNEL}/cinc/$(cat VERSION)/"
