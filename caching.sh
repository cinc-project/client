# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2021, Cinc Project
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
export CI_PROJECT_DIR=${CI_PROJECT_DIR:-${TOP_DIR}}
echo "cache_dir '${CI_PROJECT_DIR}/cache'" >> chef/omnibus/omnibus.rb
mkdir -p ${CI_PROJECT_DIR}/cache
if [ "${GIT_CACHE}" == "true" ] ; then
  mkdir -p ${CI_PROJECT_DIR}/cache/git_cache
  echo "git_cache_dir '${CI_PROJECT_DIR}/cache/git_cache'" >> chef/omnibus/omnibus.rb
  echo "use_git_caching true" >> chef/omnibus/omnibus.rb
else
  echo "git cache has been disabled"
fi
