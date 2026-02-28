#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2020-2025, Cinc Project
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

set -ex
mkdir -p ${CI_PROJECT_DIR}/cache/git_cache

# Validate git cache - remove if corrupted
GIT_CACHE="${CI_PROJECT_DIR}/cache/git_cache/opt/cinc"
if [ -d "${GIT_CACHE}" ] && ! git --git-dir="${GIT_CACHE}" rev-parse --git-dir > /dev/null 2>&1; then
  echo "Git cache is corrupted, removing..."
  rm -rf "${GIT_CACHE}"
fi

echo "cache_dir '${CI_PROJECT_DIR}/cache'" >> chef/omnibus/omnibus.rb
echo "git_cache_dir '${CI_PROJECT_DIR}/cache/git_cache'" >> chef/omnibus/omnibus.rb
echo "use_git_caching true" >> chef/omnibus/omnibus.rb
cd chef/omnibus
bundle config set --local path ${CI_PROJECT_DIR}/bundle/vendor
bundle config set --local without 'development'
bundle install
bundle exec omnibus build cinc -l ${OMNIBUS_LOG_LEVEL:-info} --override append_timestamp:false
mkdir ${CI_PROJECT_DIR}/data
mv -v pkg/cinc* ${CI_PROJECT_DIR}/data/
cp ../VERSION ${CI_PROJECT_DIR}/
