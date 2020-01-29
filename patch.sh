#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
# Copyright:: Copyright 2019, Cinc Project
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

TOP_DIR="$(pwd)"
source /home/omnibus/load-omnibus-toolchain.sh
# remove any previous builds
rm -rf chef omnibus-software
echo "Cloning ${REF:-chef-15} branch from ${ORIGIN:-https://github.com/chef/chef.git}"
git clone -q --depth=1 -b ${REF:-chef-15} ${ORIGIN:-https://github.com/chef/chef.git}
cd chef
echo "Patching chef..."
for patch in $(find ${TOP_DIR}/patches/chef/ -type f | sort) ; do
  patch -p1 < $patch
done
cd omnibus
echo "Cloning omnibus-software..."
ruby ${TOP_DIR}/scripts/checkout-omnibus-software.rb
cd $TOP_DIR/omnibus-software
echo "Patching omnibus-software..."
for patch in $(find ${TOP_DIR}/patches/omnibus-software/ -type f | sort) ; do
  patch -p1 < $patch
done
cd $TOP_DIR
echo "Copying Cinc resources..."
cp -rp cinc/* chef/
echo "Updating omnibus configuration..."
mkdir -p ${CI_PROJECT_DIR:-$TOP_DIR}/{cache,cache/git_cache}
echo "cache_dir '${CI_PROJECT_DIR:-$TOP_DIR}/cache'" >> chef/omnibus/omnibus.rb
echo "git_cache_dir '${CI_PROJECT_DIR:-$TOP_DIR}/cache/git_cache'" >> chef/omnibus/omnibus.rb
sed -i -e 's/^use_git_caching false/use_git_caching true/g' chef/omnibus/omnibus.rb
