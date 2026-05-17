#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2019-2026, Cinc Project
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

# Determine the cinc branch to build from based on REF / CINC_REF.
if [ -n "${CINC_REF}" ] ; then
  CINC_BRANCH="${CINC_REF}"
elif [ "${REF}" == "main" -o "${REF}" == "chef-18" -o -z "${REF}" ] ; then
  CINC_BRANCH="stable/cinc-18"
else
  CINC_BRANCH="stable/cinc-${REF}"
fi

TOP_DIR="$(pwd)"
source /home/omnibus/load-omnibus-toolchain.sh
set -ex
# remove any previous builds
rm -rf chef
git config --global user.email || git config --global user.email "maintainers@cinc.sh"

CINC_ORIGIN="${CINC_ORIGIN:-https://gitlab.com/cinc-project/upstream/chef.git}"
echo "Cloning cinc ${CINC_BRANCH} from ${CINC_ORIGIN}"
git clone -q -b ${CINC_BRANCH} ${CINC_ORIGIN} chef
cd chef
# Register the 'ignore' merge driver referenced from .gitattributes so
# merges from upstream auto-keep cinc's version of VERSION, version.rb,
# Gemfile.lock, etc.
git config merge.ignore.name 'ignore changes merge driver'
git config merge.ignore.driver 'touch %A'
echo "Adding upstream remote ${ORIGIN:-https://github.com/chef/chef.git}"
git remote add upstream ${ORIGIN:-https://github.com/chef/chef.git}
echo "Merging upstream/${REF:-chef-18} into ${CINC_BRANCH}"
scripts/cinc-merge-upstream.sh upstream/${REF:-chef-18}
cd $TOP_DIR

echo "Updating Gemfile.lock"
cd chef
gem install -N bundler:2.3.7
bundle lock
cd omnibus
bundle lock --conservative --update license_scout
cd ../
echo "Commit the new Gemfile.lock"
git add Gemfile.lock omnibus/Gemfile.lock
git commit -m 'Update Gemfile.lock to handle cinc patches'
cd $TOP_DIR
