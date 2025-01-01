#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2019-2025, Cinc Project
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
  elif [ "${REF}" == "main" -o -z "${REF}" ] ; then
    CINC_BRANCH="stable/cinc"
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
rm -rf chef
git config --global user.email || git config --global user.email "maintainers@cinc.sh"
echo "Cloning ${REF:-main} branch from ${ORIGIN:-https://github.com/chef/chef.git}"
git clone -q -b ${REF:-main} ${ORIGIN:-https://github.com/chef/chef.git}
cd chef
git_patch chef ${CINC_REF}
cd $TOP_DIR

echo "Updating Gemfile.lock"
cd chef
gem install -N bundler:2.3.7
bundle lock
echo "Commit the new Gemfile.lock"
git add Gemfile.lock
git commit -m 'Update Gemfile.lock to handle cinc-auditor'
cd $TOP_DIR
