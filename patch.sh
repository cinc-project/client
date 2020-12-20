#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2019-2020, Cinc Project
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

# This will patch Chef using Cinc branded patches
git_patch() {
  if [ -n "${2}" ] ; then
    CINC_BRANCH="${2}"
  elif [ "${REF}" == "master" -o -o "${REF}" == "chef-16" -z "${REF}" ] ; then
    CINC_BRANCH="stable/cinc-16"
  else
    CINC_BRANCH="stable/cinc-${REF}"
  fi
  echo "Patching ${1} from ${CINC_BRANCH}..."
  git remote add -f --no-tags -t ${CINC_BRANCH} cinc https://gitlab.com/cinc-project/upstream/${1}.git
  git merge --no-edit cinc/${CINC_BRANCH}
}

TOP_DIR="$(pwd)"
source /home/omnibus/load-omnibus-toolchain.sh
set -ex
# remove any previous builds
rm -rf chef omnibus-software
git config --global user.email || git config --global user.email "maintainers@cinc.sh"
echo "Cloning ${REF:-chef-16} branch from ${ORIGIN:-https://github.com/chef/chef.git}"
git clone -q -b ${REF:-chef-16} ${ORIGIN:-https://github.com/chef/chef.git}
cd chef
git_patch chef ${CINC_REF}
cd omnibus
ruby ${TOP_DIR}/scripts/checkout.rb -n omnibus-software -p $TOP_DIR
cd $TOP_DIR/omnibus-software
git_patch omnibus-software stable/cinc
cd $TOP_DIR

echo "cache_dir '${TOP_DIR}/cache'" >> chef/omnibus/omnibus.rb
mkdir -p ${TOP_DIR}/cache
if [ "${GIT_CACHE}" == "true" ] ; then
  mkdir -p ${TOP_DIR}/cache/git_cache
  echo "git_cache_dir '${TOP_DIR}/cache/git_cache'" >> chef/omnibus/omnibus.rb
  echo "use_git_caching true" >> chef/omnibus/omnibus.rb
else
  echo "git cache has been disabled"
fi

echo "Updating Gemfile.lock"
cd chef
bundle lock
echo "Commit the new Gemfile.lock"
git add Gemfile.lock
git commit -m 'Update Gemfile.lock to handle cinc-auditor'
rm results/*.hart || true # Cleanup previous builds hart packages and ignore no files error
