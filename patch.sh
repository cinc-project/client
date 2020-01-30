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
  CINC_BRANCH=${2:-stable/cinc}
  echo "Patching ${1} from ${CINC_BRANCH}..."
  git remote add -f --no-tags -t ${CINC_BRANCH} cinc https://gitlab.com/cinc-project/${1}.git
  git merge --no-edit cinc/${CINC_BRANCH}
}

TOP_DIR="$(pwd)"
source /home/omnibus/load-omnibus-toolchain.sh
# remove any previous builds
rm -rf chef omnibus-software chef-zero inspec
git config --global user.email || git config --global user.email "maintainers@cinc.sh"
echo "Cloning ${REF:-chef-15} branch from ${ORIGIN:-https://github.com/chef/chef.git}"
git clone -q -b ${REF:-chef-15} ${ORIGIN:-https://github.com/chef/chef.git}
cd chef
git_patch chef ramereth/gemfile-patches
cd omnibus
ruby ${TOP_DIR}/scripts/checkout.rb -n omnibus-software -p $TOP_DIR
cd $TOP_DIR/omnibus-software
git_patch omnibus-software no-chef-zero
cd $TOP_DIR/chef
ruby ${TOP_DIR}/scripts/checkout.rb -n chef-zero -r https://github.com/chef/chef-zero.git -p $TOP_DIR
cd ${TOP_DIR}/chef-zero
git_patch chef-zero
cd $TOP_DIR/chef
ruby ${TOP_DIR}/scripts/checkout.rb -g inspec-core -n inspec -r https://github.com/inspec/inspec.git -p $TOP_DIR
cd ${TOP_DIR}/inspec
git_patch inspec
cd $TOP_DIR
echo "Copying Cinc resources..."
cp -rp cinc/* chef/
